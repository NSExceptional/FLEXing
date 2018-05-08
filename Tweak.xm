//
//  Tweak.m
//  FLEXing
//
//  Created by Tanner Bennett on 2016-07-11
//  Copyright © 2016 Tanner Bennett. All rights reserved.
//


#import "Interfaces.h"

UIView * AddGestures(UIView *view) {
    id flex = [FLEXManager sharedManager];
    SEL show = @selector(showExplorer);
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:flex action:show];
    tap.numberOfTapsRequired = 2;
    tap.numberOfTouchesRequired = 2;
    
    UILongPressGestureRecognizer *tap2 = [[UILongPressGestureRecognizer alloc] initWithTarget:flex action:show];
    tap2.minimumPressDuration = .5;
    tap2.numberOfTouchesRequired = 3;
    
    [view addGestureRecognizer:tap];
    [view addGestureRecognizer:tap2];

    return view;
}

%group NoActivator
%hook UIWindow
- (id)initWithFrame:(CGRect)frame {
    return AddGestures(%orig(frame));
}

- (BOOL)_shouldCreateContextAsSecure {
    return [self isKindOfClass:%c(FLEXWindow)] ? YES : %orig;
}

%end
%end

%ctor {
    %init(NoActivator);
    if ([[NSBundle mainBundle].bundleIdentifier isEqualToString:@"com.apple.springboard"]) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [[FLEXManager sharedManager] showExplorer];
        });
        
    }
}
