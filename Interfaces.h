//
//  Interfaces.h
//  FLEXing
//
//  Created by Tanner Bennett on 2016-07-11
//  Copyright © 2016 Tanner Bennett. All rights reserved.
//

#pragma mark Imports

#import "FLEX/FLEXManager.h"


#pragma mark Macros

/// ie PropertyForKey(dateLabel, UILabel *, UITableViewCell)
#define PropertyForKey(key, propertyType, class) \
@interface class (key) @property (readonly) propertyType key; @end \
@implementation class (key) - (propertyType)key { return [self valueForKey:@"_"@#key]; } @end

#define RWPropertyInf(key, propertyType, class) \
@interface class (key) @property propertyType key; @end

#define Alert(TITLE,MSG) [[[UIAlertView alloc] initWithTitle:(TITLE) \
message:(MSG) \
delegate:nil \
cancelButtonTitle:@"OK" \
otherButtonTitles:nil] show]


#pragma mark Interfaces


