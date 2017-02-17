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
    
    if ([listenerName isEqualToString:kFLEXingShow] ){
        if (frontmostAppID) {
            [OBJCIPC sendMessageToAppWithIdentifier:frontmostAppID messageName:kFLEXingShow dictionary:nil replyHandler:^(NSDictionary *response) {
                event.handled = YES;
            }];
        } else {
            [[FLEXManager sharedManager] showExplorer];
            event.handled = YES;
        }
    }
    else if ([listenerName isEqualToString:kFLEXingToggle]) {
        if (frontmostAppID) {
            [OBJCIPC sendMessageToAppWithIdentifier:frontmostAppID messageName:kFLEXingToggle dictionary:nil replyHandler:^(NSDictionary *response) {
                event.handled = YES;
            }];
        } else {
            [[FLEXManager sharedManager] toggleExplorer];
            event.handled = YES;
        }
    } else {
        event.handled = NO;
    }
}

@end


%hook UIApplication

- (id)init {
    id application = self;
    if ([NSProcessInfo processInfo].operatingSystemVersion.majorVersion > 9) {
        application = [self class];
    }
    
    NSString *displayID = [application displayIdentifier];
    
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
