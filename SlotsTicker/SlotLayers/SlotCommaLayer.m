//
//  SlotLayer.m
//  SlotsTickerDemo
//
//  Created by Mark Glagola on 6/21/12.
//  Copyright (c) 2012 Independent. All rights reserved.
//

#import "SlotCommaLayer.h"


@interface SlotCommaLayer ()
{
    CATextLayer *textLayer;
    CGPoint lastVisiblePos;
}
//Returns the y value of the comma container
@property (nonatomic,readonly) int showValue;
@end

@implementation SlotCommaLayer

@synthesize show = _show, fontSize =  _fontSize, showValue = _showValue;

- (void) setShow:(BOOL)show
{
    [self hideAnimation:show];
}

- (CGPoint) positionWithAlignmentOffset
{
    if ([self.alignmentMode isEqualToString:kCAAlignmentCenterRight])
        return CGPointMake(-_fontSize*.15f, self.showValue);
    return CGPointMake(0, self.showValue);
}

- (void) setFontSize:(CGFloat)fontSize
{
    _fontSize = fontSize;
    
    textLayer.fontSize = _fontSize;
    textLayer.frame = CGRectMake(textLayer.frame.origin.x,textLayer.frame.origin.y, _fontSize, _fontSize);
    textLayer.position = CGPointMake(_fontSize, _fontSize * [self.textLayers indexOfObject:textLayer] + _fontSize);
    
    CGRect frame = self.textLayersContainer.frame;
    frame.size = CGSizeMake(_fontSize, _fontSize);
    
    [CATransaction begin];
    [CATransaction setValue:0 forKey:kCATransactionAnimationDuration];
    self.textLayersContainer.frame = frame; 
    self.textLayersContainer.position = [self positionWithAlignmentOffset];
    [CATransaction commit];
    
    self.frame = CGRectMake(self.frame.origin.x,self.frame.origin.y, _fontSize, _fontSize);
}

- (id) init
{
    if (self = [super init])
    {        
        textLayer = [[CATextLayer alloc] init];
        textLayer.string = @",";
        textLayer.wrapped = YES;
        textLayer.fontSize = self.fontSize;
        textLayer.contentsScale = [[UIScreen mainScreen] scale];
        textLayer.alignmentMode = kCAAlignmentRight;
        textLayer.frame = CGRectMake(0,0, self.fontSize, self.fontSize);
        textLayer.position = CGPointMake(self.fontSize, self.fontSize);
        
        [self.textLayersContainer addSublayer:textLayer];
        [self.textLayers addObject:textLayer];
        
        self.masksToBounds = NO;
    }
    return self;
}

- (int) showValue
{
    if (self.show)
        return 0;
    else
        return -1000;
}

//Animates the textLayersContainer to the targetValue
//To animate, set the "value" property to an integer between 0 and 9 
- (void) hideAnimation:(BOOL)show
{        
    float durration =  0;
    
    [CATransaction begin];
    [CATransaction setValue:[NSNumber numberWithFloat:durration] forKey:kCATransactionAnimationDuration];
    
    _show = show;

    CGPoint newPos = self.textLayersContainer.position;
    newPos.y = self.showValue;
    self.textLayersContainer.position = newPos;

    [CATransaction commit];
}

@end
