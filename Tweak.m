//
//  Tweak.m
//  FLEXing
//
//  Created by Tanner Bennett on 2016-07-11
//  Copyright © 2016 Tanner Bennett. All rights reserved.
//


#import "Interfaces.h"


@interface FLEXingActivatorListenerInstance : NSObject <LAListener>
@end

@implementation FLEXingActivatorListenerInstance

- (void)activator:(LAActivator *)activator receiveEvent:(LAEvent *)event forListenerName:(NSString *)listenerName {
    NSString *frontmostAppID = [(SpringBoard *)[UIApplication sharedApplication] _accessibilityFrontMostApplication].bundleIdentifier;
    
    if ([listenerName isEqualToString:kFLEXingShow] && !frontmostAppID) {
        [[FLEXManager sharedManager] showExplorer];
    } else if ([listenerName isEqualToString:kFLEXingToggle] && !frontmostAppID) {
        [[FLEXManager sharedManager] toggleExplorer];
    } else {
        event.handled = NO;
        return;
    }
    
    if (frontmostAppID) {
        [OBJCIPC sendMessageToAppWithIdentifier:frontmostAppID messageName:listenerName dictionary:nil replyHandler:^(NSDictionary *response) {
            event.handled = YES;
        }];
    } else {
        event.handled = YES;
    }
}

@end


%hook UIApplication

- (id)init {
    NSString *displayID = [self displayIdentifier];
    
    // Register activator handlers in springboard
    if ([displayID isEqualToString:@"com.apple.springboard"]) {
        FLEXingActivatorListenerInstance *FLEXALI = [FLEXingActivatorListenerInstance new];
        [[LAActivator sharedInstance] registerListener:FLEXALI forName:kFLEXingShow];
        [[LAActivator sharedInstance] registerListener:FLEXALI forName:kFLEXingToggle];
    } else {
        
        // Register message handlers
        [OBJCIPC registerIncomingMessageFromSpringBoardHandlerForMessageName:kFLEXingShow handler:^NSDictionary *(NSDictionary *message) {
            [[FLEXManager sharedManager] showExplorer];
            return nil;
        }];
        
        [OBJCIPC registerIncomingMessageFromSpringBoardHandlerForMessageName:kFLEXingToggle handler:^NSDictionary *(NSDictionary *message) {
            [[FLEXManager sharedManager] toggleExplorer];
            return nil;
        }];
    }
    
    return %orig;
}

%end
