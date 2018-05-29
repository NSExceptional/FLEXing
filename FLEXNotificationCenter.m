//
//  FLEXNotificationCenter.m
//  FLEXing
//
//  Created by Tanner Bennett on 2018-05-29
//  Copyright © 2016 Tanner Bennett. All rights reserved.
//

#import "Interfaces.h"
#import "FLEXNotificationCenter.h"
#import "AppSupport/CPDistributedNotificationCenter.h"
#import "FLEXManager.h"

static NSString * const kCenterName    = @"com.pantsthief.FLEXingNotificationCenter";
static NSString * const kSpringBoard   = @"com.apple.springboard";
static NSString * const kFLEXingShow   = @"com.pantsthief.flexing.show";
static NSString * const kFLEXingToggle = @"com.pantsthief.flexing.toggle";

@interface FLEXNotificationCenter ()
@property (nonatomic, readonly) CPDistributedNotificationCenter *center;
@property (nonatomic, readonly) NSMutableSet *clients;
@end

@implementation FLEXNotificationCenter

+ (FLEXNotificationCenter *)shared {
    static FLEXNotificationCenter *shared = nil;
    if (!shared) {
        shared = [self new];
        shared->_center = [CPDistributedNotificationCenter centerNamed:kCenterName];
        if (isSpringBoard) {
            shared->_clients = [NSMutableSet set];
            [[LAActivator sharedInstance] registerListener:shared forName:kFLEXingShow];
            [[LAActivator sharedInstance] registerListener:shared forName:kFLEXingToggle];
        }
    }

    return shared;
}

+ (void)initializeCenter {
    if (isSpringBoard) {
        [self.shared.center runServer];

        [[NSNotificationCenter defaultCenter]
            addObserverForName:@"CPDistributedNotificationCenterClientDidStartListeningNotification"
            object:nil
            queue:nil
            usingBlock:^(NSNotification *notif) {
                [self.shared.clients addObject:notif.userInfo[@"CPBundleIdentifier"]];
            }
        ];
    } else {
        [self.shared.center startDeliveringNotificationsToMainThread];

        [[NSNotificationCenter defaultCenter]
            addObserverForName:kFLEXingToggle
            object:nil
            queue:nil
            usingBlock:^(NSNotification *notif) {
                [[FLEXManager sharedManager] toggleExplorer];
            }
        ];

        [[NSNotificationCenter defaultCenter]
            addObserverForName:kFLEXingShow
            object:nil
            queue:nil
            usingBlock:^(NSNotification *notif) {
                [[FLEXManager sharedManager] showExplorer];
            }
        ];
    }
}

- (void)activator:(LAActivator *)activator receiveEvent:(LAEvent *)event forListenerName:(NSString *)listenerName {
    NSString *frontmostAppID = [(SpringBoard *)[UIApplication sharedApplication] _accessibilityFrontMostApplication].bundleIdentifier;

    if ([self.clients containsObject:frontmostAppID]) {
        [self.center postNotificationName:listenerName userInfo:nil toBundleIdentifier:frontmostAppID];
        event.handled = YES;
    } else if (frontmostAppID) {
        Log(@"Application '%@' not in registered clients", frontmostAppID);
        event.handled = NO;
    } else {
        if ([listenerName isEqualToString:kFLEXingShow]) {
            [[FLEXManager sharedManager] showExplorer];
            event.handled = YES;
        } else if ([listenerName isEqualToString:kFLEXingToggle]) {
            [[FLEXManager sharedManager] toggleExplorer];
            event.handled = YES;
        } else {
            event.handled = NO;
        }
    }
}

@end
