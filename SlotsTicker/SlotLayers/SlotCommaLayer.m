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
@end

@implementation SlotCommaLayer

@synthesize show = _show;

- (void) setShow:(BOOL)show
{
    [self hideAnimation:show];
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
        [self.textLayers addObject:textLayer]; //bad practice
        
        self.masksToBounds = NO;
    }
    return self;
}



//Animates the textLayersContainer to the targetValue
//To animate, set the "value" property to an integer between 0 and 9 
- (void) hideAnimation:(BOOL)show
{        
    float durration =  0;
    
    [CATransaction begin];
    [CATransaction setValue:[NSNumber numberWithFloat:durration] forKey:kCATransactionAnimationDuration];
    
    CGPoint newPos = self.textLayersContainer.position;
    
    if (show)
        newPos.y = 0;
    else
        newPos.y = -1000;
        
    self.textLayersContainer.position = newPos;
    
    _show = show;

    [CATransaction commit];
}
@end
