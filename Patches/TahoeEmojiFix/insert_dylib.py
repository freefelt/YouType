#!/usr/bin/env python3
"""Append an LC_LOAD_WEAK_DYLIB load command to every 64-bit slice of a Mach-O binary.

Usage: insert_dylib.py <binary> <dylib install path>

The command goes into the zero padding between the existing load commands and the first
section, so nothing else in the file moves. The binary's code signature becomes invalid;
re-sign it afterwards.
"""
import struct
import sys

FAT_MAGIC = 0xCAFEBABE
MH_MAGIC_64 = 0xFEEDFACF
LC_SEGMENT_64 = 0x19
LC_LOAD_WEAK_DYLIB = 0x80000018
LC_LOAD_DYLIB = 0xC


def patch_slice(data, base, dylib):
    magic, _cpu, _sub, _ftype, ncmds, sizeofcmds, _flags, _res = struct.unpack_from("<8I", data, base)
    if magic != MH_MAGIC_64:
        raise SystemExit(f"slice at {base:#x} is not a 64-bit Mach-O")

    # Walk load commands: refuse if already inserted, and find where section data starts.
    off = base + 32
    first_data = None
    for _ in range(ncmds):
        cmd, cmdsize = struct.unpack_from("<2I", data, off)
        if cmd in (LC_LOAD_DYLIB, LC_LOAD_WEAK_DYLIB):
            name_off = struct.unpack_from("<I", data, off + 8)[0]
            name = bytes(data[off + name_off: off + cmdsize]).split(b"\0")[0].decode()
            if name == dylib:
                print(f"  slice {base:#x}: already loads {dylib}, skipping")
                return
        if cmd == LC_SEGMENT_64:
            nsects = struct.unpack_from("<I", data, off + 64)[0]
            for i in range(nsects):
                s = off + 72 + i * 80
                sect_off = struct.unpack_from("<I", data, s + 48)[0]
                if sect_off and (first_data is None or sect_off < first_data):
                    first_data = sect_off
        off += cmdsize

    name = dylib.encode() + b"\0"
    cmdsize = (24 + len(name) + 7) & ~7
    end = base + 32 + sizeofcmds
    if first_data is None or 32 + sizeofcmds + cmdsize > first_data:
        raise SystemExit("not enough header padding for a new load command")
    if any(data[end:end + cmdsize]):
        raise SystemExit("header padding is not empty; refusing to overwrite")

    cmd = struct.pack("<6I", LC_LOAD_WEAK_DYLIB, cmdsize, 24, 2, 0x10000, 0x10000)
    data[end:end + cmdsize] = (cmd + name).ljust(cmdsize, b"\0")
    struct.pack_into("<2I", data, base + 16, ncmds + 1, sizeofcmds + cmdsize)
    print(f"  slice {base:#x}: added LC_LOAD_WEAK_DYLIB {dylib}")


def main():
    if len(sys.argv) != 3:
        raise SystemExit(__doc__)
    path, dylib = sys.argv[1], sys.argv[2]
    with open(path, "rb") as f:
        data = bytearray(f.read())

    if struct.unpack_from(">I", data, 0)[0] == FAT_MAGIC:
        nfat = struct.unpack_from(">I", data, 4)[0]
        for i in range(nfat):
            _cpu, _sub, offset, _size, _align = struct.unpack_from(">5I", data, 8 + i * 20)
            patch_slice(data, offset, dylib)
    else:
        patch_slice(data, 0, dylib)

    with open(path, "wb") as f:
        f.write(data)


if __name__ == "__main__":
    main()
