# "Show Emoji & Symbols" fix for macOS 26 Tahoe

On macOS 26 Tahoe, YouType 0.7.3's **Show Emoji & Symbols** menu item does nothing.

**Why it breaks:** YouType opens the Character Viewer by selecting the `com.apple.CharacterPaletteIM`
input source. On Tahoe, the viewer only opens for the app that is currently active, and closes
when that app loses focus. YouType is a menu-bar-only app that never becomes active, so the
request is ignored.

**The fix:** the menu item now sends the system's own *Edit > Emoji & Symbols* shortcut
(⌃⌘Space) to the frontmost app. That opens the emoji picker at your text cursor in the app you
were typing in. This uses the Accessibility permission YouType already has. Without that
permission, the item falls back to the old behavior.

The app's source isn't in this repository, so the fix is a small dylib (`EmojiFix.m`) that
replaces `YouType.Menu.showEmojiAction` at launch. `insert_dylib.py` adds a load command for it
to the YouType executable, and `apply.sh` builds the dylib, patches the app and re-signs it.

## Apply

Quit YouType, then run (needs Xcode Command Line Tools):

```bash
Patches/TahoeEmojiFix/apply.sh /Applications/YouType.app
```

The app is re-signed ad hoc, so macOS treats it as a new app: in **System Settings > Privacy &
Security > Accessibility**, remove YouType and add it again. Sparkle updates would replace the
patched app, but this repository's appcast has no newer version.
