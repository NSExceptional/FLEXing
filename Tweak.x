//
//  Tweak.m
//  FLEXing
//
//  Created by Tanner Bennett on 2016-07-11
//  Copyright © 2016 Tanner Bennett. All rights reserved.
//


#import "Interfaces.h"


// ===================== FLEXManager ==================== //
// ===== add toggle gesture support to trigger once ===== //
// ====================================================== //

%hook FLEXManager

%new - (void)__flexing_toggleExplorer:(UIGestureRecognizer *)sender {
    if (sender.state == UIGestureRecognizerStateBegan) {
        [self toggleExplorer];
    }
}

%end

// ===================== FLEXWindow ===================== //
// === let FLEX to open on the lockscreen while locked == //
// ====================================================== //

%hook FLEXWindow

- (BOOL)_shouldCreateContextAsSecure {
    return YES;
}

%end

// ================== UIStatusBarWindow ================= //
// ====== use the topmost window for the recognizer ===== //
// ====================================================== //

%hook UIStatusBarWindow

- (instancetype)initWithFrame:(CGRect)frame {
    
    if ((self = %orig)) {

        [self addGestureRecognizer:[[UILongPressGestureRecognizer alloc] initWithTarget:FLEXManager.sharedManager action:@selector(__flexing_toggleExplorer:)]];
    }

    return self;
}

%end
