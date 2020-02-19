//
//  Tweak.m
//  FLEXing
//
//  Created by Tanner Bennett on 2016-07-11
//  Copyright © 2016 Tanner Bennett. All rights reserved.
//


#import "Interfaces.h"

BOOL initialized = NO;
id manager = nil;
SEL show = nil;

static NSMutableArray *windowsWithGestures = nil;

static id (*FLXGetManager)();
static SEL (*FLXRevealSEL)();
static Class (*FLXWindowClass)();

/// This isn't perfect, but works for most cases as intended
inline bool isLikelyUIProcess() {
    NSString *executablePath = NSProcessInfo.processInfo.arguments[0];

    return [executablePath hasPrefix:@"/var/containers/Bundle/Application"] ||
        [executablePath hasPrefix:@"/Applications"] ||
        [executablePath hasSuffix:@"CoreServices/SpringBoard.app/SpringBoard"];
}

inline bool isSnapchatApp() {
    // See: near line 44 below
    return [NSBundle.mainBundle.bundleIdentifier isEqualToString:@"com.toyopagroup.picaboo"];
} 

%ctor {
    NSString *standardPath = @"/Library/MobileSubstrate/DynamicLibraries/libFLEX.dylib";
    NSFileManager *disk = NSFileManager.defaultManager;
    void *handle = nil;

    if ([disk fileExistsAtPath:standardPath]) {
        // Hey Snapchat / Snap Inc devs,
        // This is so users don't get their accounts locked.
        if (isLikelyUIProcess() && !isSnapchatApp()) {
            handle = dlopen(standardPath.UTF8String, RTLD_LAZY);
        }
    } else {
        // libFLEX not found
        // ...
    }

    if (handle) {
        // FLEXing.dylib itself does not hard-link against libFLEX.dylib,
        // instead libFLEX.dylib provides getters for the relevant class
        // objects so that it can be updated independently of THIS tweak.
        FLXGetManager = (id(*)())dlsym(handle, "FLXGetManager");
        FLXRevealSEL = (SEL(*)())dlsym(handle, "FLXRevealSEL");
        FLXWindowClass = (Class(*)())dlsym(handle, "FLXWindowClass");

        manager = FLXGetManager();
        show = FLXRevealSEL();

        windowsWithGestures = [NSMutableArray new];
        initialized = YES;
    }
}

%hook UIWindow
- (BOOL)_shouldCreateContextAsSecure {
    return (initialized && [self isKindOfClass:FLXWindowClass()]) ? YES : %orig;
}

- (void)becomeKeyWindow {
    %orig;

    if (!initialized) {
        return;
    }

    BOOL needsGesture = ![windowsWithGestures containsObject:self];
    BOOL isFLEXWindow = [self isKindOfClass:FLXWindowClass()];
    BOOL isStatusBar  = [self isKindOfClass:[UIStatusBarWindow class]];
    if (needsGesture && !isFLEXWindow && !isStatusBar) {
        [windowsWithGestures addObject:self];

        // Add 3-finger long-press gesture for apps without a status bar
        UILongPressGestureRecognizer *tap = [[UILongPressGestureRecognizer alloc] initWithTarget:manager action:show];
        tap.minimumPressDuration = .5;
        tap.numberOfTouchesRequired = 3;

        [self addGestureRecognizer:tap];
    }
}
%end

%hook UIStatusBarWindow
- (id)initWithFrame:(CGRect)frame {
    self = %orig;
    
    if (initialized) {
        // Add long-press gesture to status bar
        [self addGestureRecognizer:[[UILongPressGestureRecognizer alloc] initWithTarget:manager action:show]];
    }
    
    return self;
}
%end

%hook FLEXExplorerViewController
- (BOOL)_canShowWhileLocked {
    return YES;
}
%end

// Easily determine the bundle of a specific class within FLEX
// TODO: Move this into the FLEX codebase itself.
%hook NSObject
%new
+ (NSBundle *)__bundle__ {
    return [NSBundle bundleForClass:self];
}
%end
