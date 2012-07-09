//
//  SlotsController.m
//  SlotsTickerDemo
//
//  Created by Mark Glagola on 6/21/12.
//  Copyright (c) 2012 Independent. All rights reserved.
//

#import "SlotsController.h"
#import "SlotNumberLayer.h"
#import "SlotCommaLayer.h"

@interface SlotsController ()
{
    NSMutableArray *digits;
}

@property (nonatomic) NSMutableArray *commas;

@end

@implementation SlotsController

@synthesize slots = _slots, fontSize = _fontSize, value = _value, speed = _speed, color = _color, size = _size, padding = _padding, contentSize = _contentSize, showZeros = _showZeros, alignment = _alignment, commas = _commas, commasEnabled = _commasEnabled;

- (NSMutableArray*) slots
{
    if (_slots == nil) {
        _slots = [[NSMutableArray alloc] init];            
    }
    return _slots;
}

- (NSMutableArray*) commas
{
    if (_commas == nil) {
        _commas = [[NSMutableArray alloc] init];
    }
    return _commas;
}

- (void) setFontSize:(CGFloat)fontSize
{
    _fontSize = fontSize;
    [self repositionDigitsStartingAtIndex:0];
    _contentSize = CGSizeMake(self.fontSize * self.size + self.padding, self.fontSize);
}

- (void) setPadding:(int)padding
{
    _padding = padding;
    [self setFontSize:self.fontSize]; //repositions with new padding
}

- (void) setColor:(CGColorRef)color
{
    _color = color;
    for (SlotNumberLayer *slot in self.slots)
        slot.color = _color;
    for (SlotCommaLayer *comma in self.commas)
        comma.color = _color;
}

- (void) setCommasEnabled:(BOOL)commasEnabled
{
    _commasEnabled = commasEnabled;
    
    //reconfigure commas' visibility
    if (commasEnabled)
        [self setValue:self.value];
}

- (void) setValue:(int)value
{
    //removes all old data
    [digits removeAllObjects];
    
    int integer = value;
    int length = ((NSString*)[NSString stringWithFormat:@"%i",integer]).length;

    //make sure the integer is not too big
    if (length > self.size) {
        integer = pow(10, self.size) - 1;
        length = self.size;
    }
    else if (integer < 0) {
        integer = 0;
    }
    
    //seperate the integer into digits
    for (int i = 0; i < length; i++) 
    {
        int digit = integer % 10;
        [digits addObject:[NSNumber numberWithInt:digit]];
        integer = integer / 10;
    }
    
    //adds 0 to array if the length of the value is less the zeros
    if (length < self.size)
    {
        for (int i = length; i < self.size; i++)
        {
            if (self.showZeros)
                [digits addObject:[NSNumber numberWithInt:0]];
            else
                [digits addObject:[NSNumber numberWithInt:-1]]; //will show as invisible
        }
        
        //if true - need to reorganize -1 (aka invisibile) slots to the back of array
        if (self.showZeros == NO && self.alignment == SlotAlignmentLeft) 
        {
            NSMutableArray* newDigits = [NSMutableArray arrayWithArray:[[digits reverseObjectEnumerator] allObjects]];
            for (int i = 0; i < self.size; i++)
            {
                int invisibleInt = [[newDigits objectAtIndex:i] intValue];
                //shifts digits over to the right of array
                if (invisibleInt == -1)
                {
                    for (int j = i+1; j < self.size; j++)
                    {
                        NSNumber *num2 = [newDigits objectAtIndex:j];
                        if ([num2 intValue] != -1) {
                            [newDigits replaceObjectAtIndex:i withObject:num2];
                            [newDigits replaceObjectAtIndex:j withObject:[NSNumber numberWithInt:invisibleInt]];
                            break;
                        }
                    }
                }
            }
            
            digits = [NSMutableArray arrayWithArray:[[newDigits reverseObjectEnumerator] allObjects]];
        }
        
    }
    
    //hide all commas
    for (SlotCommaLayer *comma in self.commas)
        comma.show = NO;
    
    if (self.commasEnabled) {
        
        int sizeFactor = self.size;
        if (self.showZeros == NO && self.alignment == SlotAlignmentLeft)
            sizeFactor = length;
        
        //if true = we are going to have to show atleast 1 comma
        if (sizeFactor > 3 && value > pow(10,3)-1) {
            
            int index = sizeFactor - 4;
            SlotCommaLayer *commaToShow = [self.commas objectAtIndex:index];
            commaToShow.show = YES;
            //[self repositionDigitsStartingAtIndex:index];
            
            //if true = we are going to have to show 2 commas
            if (sizeFactor > 6 && value > pow(10,6)-1) {
                index = sizeFactor - 7;
                SlotCommaLayer *commaToShow = [self.commas objectAtIndex:index];
                commaToShow.show = YES;
                //[self repositionDigitsStartingAtIndex:index];
            }
        }
    }
            
    //animate slots
    for (int i = 0; i < self.size; i++)
    {
        SlotNumberLayer *slot = (SlotNumberLayer*) [self.slots objectAtIndex:(self.size-1)-i];
        int newValue = [[digits objectAtIndex:i] intValue];
        slot.value = newValue;
    }
}

- (void) setSpeed:(float)speed
{
    _speed = speed;
    for (SlotNumberLayer *slot in self.slots)
        slot.speed = _speed;
    for (SlotCommaLayer *comma in self.commas)
        comma.speed = _speed;
}


- (void) setDefaults
{
    digits = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < self.size; i++) {
        SlotNumberLayer *slot = [[SlotNumberLayer alloc] init];
        slot.position = CGPointMake((slot.fontSize * i * .5) + slot.fontSize*.5, slot.fontSize*.5);
        [self.slots addObject:slot];
        [self addSublayer:slot];
        _fontSize = slot.fontSize;
    }
    for (int i = 0; i < self.size; i++) {
        SlotCommaLayer *comma = [[SlotCommaLayer alloc] init];
        comma.position = CGPointMake((self.fontSize * i * .5) + self.fontSize*.5, self.fontSize*.5);
        comma.show = self.commasEnabled;
        [self.commas addObject:comma];
        [self addSublayer:comma];
    }
    
    self.speed = 5.0f;
    self.alignment = SlotAlignmentRight;
}

- (id) init
{
    if (self = [super init])
    {
        _size = 9;
        [self setDefaults];
    }
    return self;
}

- (id) initWithSize:(int) size
{
    if (self = [super init])
    {
        if (size > 9)
            _size = 9;
        else if (size < 1)
            _size = 1;
        else
            _size = size;
        
        [self setDefaults];
    }
    return self;
}

- (void) setFontWithName:(NSString*) name
{
    for (SlotNumberLayer *slot in self.slots)
        [slot setFontWithName:name];
    for (SlotCommaLayer *comma in self.commas)
        [comma setFontWithName:name];
    
    //repositioning
    [self setFontSize:self.fontSize];
}

- (void) repositionDigitsStartingAtIndex:(int) index
{
    int commaPadding = 0;
    if (index > 0)
        commaPadding = self.fontSize * .5f;
    
    for (int i = index; i < self.size; i++) {
        SlotNumberLayer *slot = [self.slots objectAtIndex:i];
        slot.fontSize = _fontSize;
        float previousX = (i > index) ? ((SlotNumberLayer*)[self.slots objectAtIndex:i-1]).position.x : commaPadding;
        slot.position = CGPointMake(previousX + slot.fontSize * .5f + self.padding, slot.fontSize*.5);
        
        SlotCommaLayer *comma = [self.commas objectAtIndex:i];
        comma.fontSize = _fontSize;
        comma.position = slot.position;
        comma.show = self.commasEnabled;
    }
}

@end
