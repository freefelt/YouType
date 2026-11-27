#!/bin/bash
# Patch a copy of YouType.app so "Show Emoji & Symbols" works on macOS 26 (Tahoe).
#
# Usage: Patches/TahoeEmojiFix/apply.sh [path/to/YouType.app]
#   Default target: /Applications/YouType.app
#
# Requires Xcode Command Line Tools (clang, codesign, python3).
set -euo pipefail

HERE="$(cd "$(dirname "$0")" && pwd)"
APP="${1:-/Applications/YouType.app}"
EXE="$APP/Contents/MacOS/YouType"
DYLIB_NAME="YouTypeEmojiFix.dylib"
DYLIB_DEST="$APP/Contents/Frameworks/$DYLIB_NAME"

[ -f "$EXE" ] || { echo "YouType executable not found at $EXE" >&2; exit 1; }

echo "Building $DYLIB_NAME..."
clang -dynamiclib -fobjc-arc -O2 \
    -arch arm64 -arch x86_64 -mmacosx-version-min=11.0 \
    -framework AppKit -framework ApplicationServices \
    -install_name "@executable_path/../Frameworks/$DYLIB_NAME" \
    -o "$DYLIB_DEST" "$HERE/EmojiFix.m"

echo "Adding load command to YouType executable..."
/usr/bin/python3 "$HERE/insert_dylib.py" "$EXE" "@executable_path/../Frameworks/$DYLIB_NAME"

echo "Re-signing (ad hoc)..."
ENT="$(mktemp -t youtype-ent).plist"
codesign -d --entitlements - --xml "$APP" > "$ENT" 2>/dev/null || true
codesign --force --sign - "$DYLIB_DEST"
if [ -s "$ENT" ]; then
    codesign --force --sign - --entitlements "$ENT" "$APP"
else
    codesign --force --sign - "$APP"
fi
rm -f "$ENT"
codesign --verify --strict "$APP"

echo "Done. Restart YouType. If the flag next to the cursor stops appearing, re-grant"
echo "YouType in System Settings > Privacy & Security > Accessibility (remove and re-add it)."
