//
//  FLEXNotificationCenter.h
//  FLEXing
//
//  Created by Tanner Bennett on 2018-05-29
//  Copyright © 2016 Tanner Bennett. All rights reserved.
//

@interface FLEXNotificationCenter : NSObject

@property (nonatomic, readonly, class) FLEXNotificationCenter *shared;

+ (void)initializeCenter;

@end
