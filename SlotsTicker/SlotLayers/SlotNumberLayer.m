//
//  SlotLayer.m
//  SlotsTickerDemo
//
//  Created by Mark Glagola on 6/21/12.
//  Copyright (c) 2012 Independent. All rights reserved.
//

#import "SlotNumberLayer.h"

@interface SlotNumberLayer ()

@end

@implementation SlotNumberLayer

@synthesize value = _value;

//animates when setting a new value 
- (void) setValue:(int)value
{
    //Only animate if a valid value
    if (value == -1)
        [self animateTo:10];
    else if (value <= 9 && value >= 0)
        [self animateTo:value];
}

- (id) init
{
    if (self = [super init])
    {        
        for (int i = 0; i <= 9; i++)
        {
            CATextLayer *textLayer = [[CATextLayer alloc] init];
            textLayer.string = [NSString stringWithFormat:@"%i",i];
            textLayer.wrapped = YES;
            textLayer.fontSize = self.fontSize;
            textLayer.contentsScale = [[UIScreen mainScreen] scale];
            textLayer.alignmentMode = kCAAlignmentCenter;
            textLayer.frame = CGRectMake(0,0, self.fontSize, self.fontSize);
            textLayer.position = CGPointMake(self.fontSize, self.fontSize * i + self.fontSize);
            
            [self.textLayersContainer addSublayer:textLayer];
            [self.textLayers addObject:textLayer];
        }
    }
    return self;
}

//Animates the textLayersContainer to the targetValue
//To animate, set the "value" property to an integer between 0 and 9 
- (void) animateTo:(int)targetValue
{        
    float durration =  fabsf((targetValue - self.value)* self.speed);
    
    [CATransaction begin];
    [CATransaction setValue:[NSNumber numberWithFloat:durration] forKey:kCATransactionAnimationDuration];
    
    CGPoint newPos = self.textLayersContainer.position;
    int distanceY = self.fontSize * abs(targetValue - self.value);
    
    //animate downward
    if (targetValue < self.value) 
        newPos.y += distanceY;
    //animate upward
    else if (targetValue > self.value) 
        newPos.y -= distanceY; 
    
    self.textLayersContainer.position = newPos;
    _value = targetValue;
    
    [CATransaction commit];
}

@end
