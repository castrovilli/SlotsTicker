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

@synthesize value = _value, fontSize = _fontSize;

//animates when setting a new value 
- (void) setValue:(int)value
{
    //Only animate if a valid value
    if (value <= 9 && value >= -1)
        [self animateTo:value];
}

//reset positioning according to new font size 
- (void) setFontSize:(CGFloat)fontSize
{
    _fontSize = fontSize;
    for (CATextLayer *textLayer in self.textLayers) {
        textLayer.fontSize = _fontSize;
        textLayer.frame = CGRectMake(textLayer.frame.origin.x,textLayer.frame.origin.y, _fontSize, _fontSize);
        textLayer.position = CGPointMake(_fontSize, _fontSize * [self.textLayers indexOfObject:textLayer] + _fontSize);
    }
    CGRect frame = self.textLayersContainer.frame;
    frame.size = CGSizeMake(_fontSize, _fontSize);
    self.textLayersContainer.frame = frame;    
    self.textLayersContainer.position = CGPointMake(0, -_fontSize * _value);
    self.frame = CGRectMake(self.frame.origin.x,self.frame.origin.y, _fontSize, _fontSize);
}

- (void) addTextLayer:(NSString*)text
{
    CATextLayer *textLayer = [[CATextLayer alloc] init];
    textLayer.string = text;
    textLayer.wrapped = YES;
    textLayer.fontSize = self.fontSize;
    textLayer.contentsScale = [[UIScreen mainScreen] scale];
    textLayer.alignmentMode = kCAAlignmentCenter;
    textLayer.frame = CGRectMake(0,0, self.fontSize, self.fontSize);
    
    [self.textLayersContainer addSublayer:textLayer];
    [self.textLayers addObject:textLayer];
}

- (id) init
{
    if (self = [super init])
    {
        for (int i = 0; i <= 9; i++)
            [self addTextLayer:[NSString stringWithFormat:@"%i",i]];
        
        [self addTextLayer:@" "];
        
        self.fontSize = 20.0f;
        
        [self repositionTextLayerAtCurrentValue];
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
    [CATransaction setCompletionBlock:^{
        [self repositionTextLayerAtCurrentValue];
    }];
    
    CGPoint newPos = self.textLayersContainer.position;
    int distanceY = self.fontSize * abs(targetValue - self.value);
    
//    //animate downward
//    if (targetValue < self.value) 
//        newPos.y += distanceY;
//    //animate upward
//    else if (targetValue > self.value) 
        newPos.y -= distanceY;
    
    self.textLayersContainer.position = newPos;
    _value = targetValue;
    
    [CATransaction commit];
}


- (void) repositionTextLayerAtCurrentValue
{
    [CATransaction begin];
    [CATransaction setValue:[NSNumber numberWithFloat:0] forKey:kCATransactionAnimationDuration];

    for (int i = self.value-1; i >= 0;i--) {
        CATextLayer *textLayer = [self.textLayers objectAtIndex:i];
        textLayer.position = CGPointMake(_fontSize, _fontSize * self.textLayers.count + _fontSize * ([self.textLayers indexOfObject:textLayer] + 1));
    }
    
    [CATransaction commit];
}

@end
