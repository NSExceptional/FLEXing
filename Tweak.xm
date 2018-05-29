//
//  Tweak.m
//  FLEXing
//
//  Created by Tanner Bennett on 2016-07-11
//  Copyright © 2016 Tanner Bennett. All rights reserved.
//

#import "Interfaces.h"

%hook UIApplication
- (id)init {
    [FLEXNotificationCenter initializeCenter];
    return %orig;
}
%end

%hook UIWindow
- (BOOL)_shouldCreateContextAsSecure {
    return [self isKindOfClass:%c(FLEXWindow)] ? YES : %orig;
}
%end