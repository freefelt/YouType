// YouTypeEmojiFix.dylib: makes "Show Emoji & Symbols" in YouType 0.7.3 work on macOS 26 (Tahoe).
//
// YouType opened the Character Viewer by selecting the com.apple.CharacterPaletteIM input
// source. On Tahoe, CharacterPalette only shows its window for the app that is currently
// active, and hides it as soon as that app deactivates. YouType is a menu-bar-only app, so
// the request is ignored (and even if YouType activated itself, the viewer would close the
// moment you clicked back into the app you want to type in).
//
// This library replaces -[YouType.Menu showEmojiAction] with the system's own
// "Edit > Emoji & Symbols" shortcut (Control-Command-Space), posted to the frontmost app.
// Clicking a status-bar menu doesn't take focus away from that app, so the picker opens at
// the text cursor where you were typing. Posting key events uses the Accessibility
// permission YouType already needs for its cursor indicator.

#import <AppKit/AppKit.h>
#import <ApplicationServices/ApplicationServices.h>
#import <objc/runtime.h>

static IMP gOriginal;
static SEL gSelector;

static void PostEmojiShortcut(void) {
    const CGKeyCode kVKSpace = 49;
    CGEventSourceRef source = CGEventSourceCreate(kCGEventSourceStateHIDSystemState);
    CGEventRef down = CGEventCreateKeyboardEvent(source, kVKSpace, true);
    CGEventRef up = CGEventCreateKeyboardEvent(source, kVKSpace, false);
    CGEventSetFlags(down, kCGEventFlagMaskControl | kCGEventFlagMaskCommand);
    CGEventSetFlags(up, kCGEventFlagMaskControl | kCGEventFlagMaskCommand);
    CGEventPost(kCGHIDEventTap, down);
    CGEventPost(kCGHIDEventTap, up);
    CFRelease(down);
    CFRelease(up);
    if (source) CFRelease(source);
}

static void ShowEmojiReplacement(id self, SEL _cmd) {
    if (!AXIsProcessTrusted()) {
        // Can't post key events without Accessibility access; keep the old behavior.
        NSLog(@"YouTypeEmojiFix: Accessibility access not granted; using original action");
        ((void (*)(id, SEL))gOriginal)(self, _cmd);
        return;
    }
    // Give the status menu a moment to close so the shortcut reaches the frontmost app.
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.15 * NSEC_PER_SEC)),
                   dispatch_get_main_queue(), ^{ PostEmojiShortcut(); });
}

static void Install(void) {
    Class cls = objc_getClass("_TtC7YouType4Menu");
    gSelector = sel_registerName("showEmojiAction");
    Method method = cls ? class_getInstanceMethod(cls, gSelector) : NULL;
    if (!method) {
        NSLog(@"YouTypeEmojiFix: YouType.Menu.showEmojiAction not found; fix not applied");
        return;
    }
    gOriginal = method_setImplementation(method, (IMP)ShowEmojiReplacement);
}

__attribute__((constructor)) static void EmojiFixInit(void) {
    // Defer until the run loop starts so the app's Swift classes are fully set up.
    dispatch_async(dispatch_get_main_queue(), ^{ Install(); });
}
