//
//  Tweak.m
//  FLEXing
//
//  Created by Tanner Bennett on 2016-07-11
//  Copyright © 2016 Tanner Bennett. All rights reserved.
//

#import "Interfaces.h"


%hook UIWindow

- (id)initWithFrame:(CGRect)frame {
    self = %orig(frame);
    
    id flex = [FLEXManager sharedManager];
    SEL toggle = @selector(toggleExplorer);
    SEL show = @selector(showExplorer);
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:flex action:toggle];
    tap.numberOfTapsRequired = 2;
    tap.numberOfTouchesRequired = 2;
    
    UILongPressGestureRecognizer *tap2 = [[UILongPressGestureRecognizer alloc] initWithTarget:flex action:show];
    tap2.minimumPressDuration = .5;
    tap2.numberOfTouchesRequired = 3;
    
    [self addGestureRecognizer:tap];
    [self addGestureRecognizer:tap2];
    
    return self;
}

%end