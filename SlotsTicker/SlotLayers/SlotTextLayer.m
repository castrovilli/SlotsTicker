//
//  SlotLayer.m
//  SlotsTickerDemo
//
//  Created by Mark Glagola on 6/21/12.
//  Copyright (c) 2012 Independent. All rights reserved.
//

#import "SlotTextLayer.h"

@interface SlotTextLayer ()
@property (nonatomic,readonly) CGPoint alignmentCenterRightPos;
@end

@implementation SlotTextLayer

NSString* const kCAAlignmentCenterRight = @"kCAAlignmentCenterRight";

@synthesize textLayers = _textLayers, fontSize = _fontSize, textLayersContainer = _textLayersContainer, speed = _speed, color = _color,alignmentMode = _alignmentMode,alignmentCenterRightPos = _align;

- (CALayer*) textLayersContainer
{
    if (_textLayersContainer == nil) {
        _textLayersContainer = [[CALayer alloc] init];
        _textLayersContainer.frame = CGRectMake(0, 0, self.fontSize, self.fontSize);
        _textLayersContainer.position = CGPointMake(0, 0);
    }
    return _textLayersContainer;
}

- (NSMutableArray*) textLayers
{
    if (_textLayers == nil)
        _textLayers = [[NSMutableArray alloc] init];
    return _textLayers;
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
    self.textLayersContainer.position = CGPointMake(0, 0);
    
    self.frame = CGRectMake(self.frame.origin.x,self.frame.origin.y, _fontSize, _fontSize);
}
- (void) setSpeed:(float)speed
{
    _speed = speed / (speed * speed);
}

- (void) setAlignmentMode:(NSString *)alignmentMode
{
    
    if ([alignmentMode isEqualToString:kCAAlignmentCenterRight] && ![_alignmentMode isEqualToString:kCAAlignmentCenterRight])
    {
        for (CATextLayer *textLayer in self.textLayers) {
            textLayer.alignmentMode = kCAAlignmentRight;
            textLayer.position = CGPointMake(textLayer.position.x-self.fontSize*.15f, textLayer.position.y);
        }
    }
    else {
        
        //if it was in the custom alignment mode we should set it back to its normal position
        int newPosX = ([_alignmentMode isEqualToString:kCAAlignmentCenterRight]) ? self.fontSize*.15f : 0;
            
        for (CATextLayer *textLayer in self.textLayers) {
            textLayer.alignmentMode = alignmentMode;
            textLayer.position = CGPointMake(textLayer.position.x+newPosX, textLayer.position.y);
        }
    }
    _alignmentMode = alignmentMode;
}

- (void) setColor:(CGColorRef)color
{
    _color = color;
    for (CATextLayer *textLayer in self.textLayers) {
        textLayer.foregroundColor = _color;
    }
}

- (id) init
{
    if (self = [super init])
    {        
        //sets up defaults
        _fontSize = 20.0f;
        
        self.frame = CGRectMake(0, 0, self.fontSize, self.fontSize);
//        self.masksToBounds = YES;
                 
        [self addSublayer:self.textLayersContainer];
    }
    return self;
}

- (void) setFontWithName:(NSString*) name
{
    CGFontRef font = CGFontCreateWithFontName((__bridge CFStringRef)name);
    for (CATextLayer *textLayer in self.textLayers) {
        textLayer.font = font;
    }
    CFRelease(font);
}
@end
