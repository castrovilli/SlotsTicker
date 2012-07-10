//
//  SlotLayer.h
//  SlotsTickerDemo
//
//  Created by Mark Glagola on 6/21/12.
//  Copyright (c) 2012 Independent. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "SlotTextLayer.h"

@interface SlotNumberLayer : SlotTextLayer

//the current value (number) that is being shown (0 - 9)
//SET THIS to animate the slot ticker
@property (nonatomic) int value;

@end
