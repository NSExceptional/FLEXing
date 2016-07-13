//
//  Tweak.m
//  FLEXing
//
//  Created by Tanner Bennett on 2016-07-11
//  Copyright © 2016 Tanner Bennett. All rights reserved.
//

#import "FLEX/FLEXManager.h"
#include "Activator/libactivator.h"

@interface FLEXingActivatorListenerInstance : NSObject <LAListener>
@end

@implementation FLEXingActivatorListenerInstance

- (void)activator:(LAActivator *)activator receiveEvent:(LAEvent *)event forListenerName:(NSString *)listenerName{

    if( [listenerName isEqualToString:@"com.pantsthief.flexing.show"] ){
        [[FLEXManager sharedManager] showExplorer];
    }

    else if( [listenerName isEqualToString:@"com.pantsthief.flexing.toggle"] ){
        [[FLEXManager sharedManager] toggleExplorer];
    } 

    else { 
        // ..
    }
}

@end


static FLEXingActivatorListenerInstance* FLEXALI;

//
// Creates the actual Activator listener object
//
static void createListener()
{
    NSLog(@"flexing - cl");
    FLEXALI = [[FLEXingActivatorListenerInstance alloc] init];
    [[LAActivator sharedInstance] registerListener:FLEXALI forName:@"com.pantsthief.flexing.show"];
    [[LAActivator sharedInstance] registerListener:FLEXALI forName:@"com.pantsthief.flexing.toggle"];
}


//
// Constructor
//
%ctor
{
    NSLog(@"flexing - ctor");
    CFNotificationCenterAddObserver(CFNotificationCenterGetLocalCenter(), NULL, (CFNotificationCallback)createListener, (CFStringRef)UIApplicationDidFinishLaunchingNotification, NULL, CFNotificationSuspensionBehaviorCoalesce); 
}