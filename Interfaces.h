//
//  Interfaces.h
//  FLEXing
//
//  Created by Tanner Bennett on 2016-07-11
//  Copyright © 2016 Tanner Bennett. All rights reserved.
//

#pragma mark Imports

#import <Foundation/Foundation.h>
#include <dlfcn.h>


#pragma mark Globals

#define kFLEXLongPressGesture 0xdeadbabe

extern BOOL initialized;
extern id manager;
extern SEL show;

// TODO: activator support
// static NSString * const kFLEXingShow   = @"com.pantsthief.flexing.show";
// static NSString * const kFLEXingToggle = @"com.pantsthief.flexing.toggle";


#pragma mark Macros

#define Alert(TITLE,MSG) [[[UIAlertView alloc] \
    initWithTitle:(TITLE) \
    message:(MSG) \
    delegate:nil \
    cancelButtonTitle:@"OK" \
    otherButtonTitles:nil] show \
]

#define Async(block) dispatch_async(dispatch_get_main_queue(), block)
#define After(seconds, block) dispatch_after( \
    dispatch_time(DISPATCH_TIME_NOW, (int64_t)(seconds * NSEC_PER_SEC)), \
    dispatch_get_main_queue(), ^block \
);


#pragma mark Interfaces

@interface UIStatusBarWindow : UIWindow @end

@interface UIApplication (Private)
- (id)displayIdentifier;
@end

@interface SBApplication
- (NSString *)bundleIdentifier;
@end

@interface SpringBoard : UIApplication
- (SBApplication *)_accessibilityFrontMostApplication;
@end

// iOS 13 //

@interface UIStatusBarTapAction : NSObject
@property (nonatomic, readonly) NSInteger type;
@end

@interface SBMainDisplaySceneLayoutStatusBarView : UIView
- (void)_statusBarTapped:(id)sender type:(NSInteger)type;
@end
