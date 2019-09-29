//
//  Interfaces.h
//  FLEXing
//
//  Created by Tanner Bennett on 2016-07-11
//  Copyright © 2016 Tanner Bennett. All rights reserved.
//

#pragma mark Imports

#import "FLEXManager.h"

#pragma mark Interfaces

@interface FLEXManager : NSObject
+ (instancetype)sharedManager;
- (void)toggleExplorer;
@end

@interface FLEXWindow : UIWindow 
@end

@interface UIStatusBarWindow : UIWindow 
@end