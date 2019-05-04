//
//  Tweak.m
//  FLEXing
//
//  Created by Tanner Bennett on 2016-07-11
//  Copyright © 2016 Tanner Bennett. All rights reserved.
//


#import "Interfaces.h"

%hook UIWindow
- (BOOL)_shouldCreateContextAsSecure {
    return [self isKindOfClass:%c(FLEXWindow)] ? YES : %orig;
}

- (id)initWithFrame:(CGRect)frame {
    self = %orig(frame);
    
    id flex = [FLEXManager sharedManager];
    SEL toggle = @selector(toggleExplorer);
    SEL show = @selector(showExplorer);
    
    UILongPressGestureRecognizer *tap = [[UILongPressGestureRecognizer alloc] initWithTarget:flex action:show];
    tap.minimumPressDuration = .5;
    tap.numberOfTouchesRequired = 3;
    
    [self addGestureRecognizer:tap];
    
    return self;
}

%end

%hook UIStatusBarWindow
- (id)initWithFrame:(CGRect)frame {
    self = %orig;
    
    [self addGestureRecognizer:[[UILongPressGestureRecognizer alloc] initWithTarget:FLEXManager.sharedManager action:@selector(showExplorer)]];
    
    return self;
}
%end

%hook NSObject
%new
+ (NSBundle *)__bundle__ {
    return [NSBundle bundleForClass:self];
}
%end
