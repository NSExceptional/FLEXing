//
//  Tweak.m
//  FLEXing
//
//  Created by Tanner Bennett on 2016-07-11
//  Copyright © 2016 Tanner Bennett. All rights reserved.
//

#import "FLEX/FLEXManager.h"
#import "Activator/libactivator.h"
#import <objcipc/objcipc.h>

@interface UIApplication (Private)
-(id)displayIdentifier;
@end

@interface SBApplication
- (NSString *)bundleIdentifier;
@end

@interface SpringBoard : UIApplication
- (SBApplication *)_accessibilityFrontMostApplication;
@end

@interface FLEXingActivatorListenerInstance : NSObject <LAListener>
@end

@implementation FLEXingActivatorListenerInstance

- (void)activator:(LAActivator *)activator receiveEvent:(LAEvent *)event forListenerName:(NSString *)listenerName{

    NSString *frontmostAppID = [[(SpringBoard *)[UIApplication sharedApplication] _accessibilityFrontMostApplication] bundleIdentifier];

    if([listenerName isEqualToString:@"com.pantsthief.flexing.show"] ){
        if(frontmostAppID) {

            [OBJCIPC sendMessageToAppWithIdentifier:frontmostAppID messageName:@"com.pantsthief.flexing.show" dictionary:nil replyHandler:^(NSDictionary *response) {
                [event setHandled:YES];
            }];

        } else {
            [[FLEXManager sharedManager] showExplorer];
            [event setHandled:YES];
        }
        
    }

    else if([listenerName isEqualToString:@"com.pantsthief.flexing.toggle"] ){
        if(frontmostAppID) {

            [OBJCIPC sendMessageToAppWithIdentifier:frontmostAppID messageName:@"com.pantsthief.flexing.toggle" dictionary:nil replyHandler:^(NSDictionary *response) {
                [event setHandled:YES];
            }];

        } else {
            [[FLEXManager sharedManager] toggleExplorer];
            [event setHandled:YES];
        }
    } 

    else { 
        [event setHandled:NO];
    }
}

@end


%hook UIApplication

-(id)init {

    NSString *displayID = [self displayIdentifier];

    //register activator handlers in springboard
    if ([displayID isEqualToString:@"com.apple.springboard"]) {
        FLEXingActivatorListenerInstance *FLEXALI = [[FLEXingActivatorListenerInstance alloc] init];
        [[LAActivator sharedInstance] registerListener:FLEXALI forName:@"com.pantsthief.flexing.show"];
        [[LAActivator sharedInstance] registerListener:FLEXALI forName:@"com.pantsthief.flexing.toggle"];
    } else {

        //register message handlers
        [OBJCIPC registerIncomingMessageFromSpringBoardHandlerForMessageName:@"com.pantsthief.flexing.show" handler:^NSDictionary *(NSDictionary *message) {
            [[FLEXManager sharedManager] showExplorer];
            return nil;
        }];

        [OBJCIPC registerIncomingMessageFromSpringBoardHandlerForMessageName:@"com.pantsthief.flexing.toggle" handler:^NSDictionary *(NSDictionary *message) {
            [[FLEXManager sharedManager] toggleExplorer];
            return nil;
        }];
    }

    return %orig;
}

%end
