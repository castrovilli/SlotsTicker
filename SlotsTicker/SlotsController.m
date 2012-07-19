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
    int originalSize;
}

@property (nonatomic) NSMutableArray *commas;

@end

@implementation SlotsController

@synthesize slots = _slots, fontSize = _fontSize, value = _value, speed = _speed, color = _color, size = _size, padding = _padding, contentSize = _contentSize, showZeros = _showZeros, alignment = _alignment, commas = _commas, commasEnabled = _commasEnabled, autoresize = _autoresize, minimumFontSize = _minimumFontSize;

//Cont
int const kSlotsSizeMax = 9;
int const kSlotsSizeMin = 1;

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
    
    if (!self.autoresize)
        _contentSize = CGSizeMake(_fontSize * self.size + self.padding, _fontSize);
    
    [self repositionDigits];
}

- (void) setContentSize:(CGSize)contentSize
{
    _contentSize = contentSize;
    [self repositionDigits];
}

- (void) setPadding:(int)padding
{
    _padding = padding;
    [self repositionDigits];
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

- (void) setAutoresize:(BOOL)autoresize
{
    if (autoresize == YES) {
        _size = kSlotsSizeMax;
        _minimumFontSize = self.fontSize;
    }
    else
        _size = originalSize;
    
    _autoresize = autoresize;
    [self repositionDigits];
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
            [self setSlotNumberAlignmentAccordingToSize:sizeFactor];
            
            //if true = we are going to have to show 2 commas
            if (sizeFactor > 6 && value > pow(10,6)-1) {
                index = sizeFactor - 7;
                SlotCommaLayer *commaToShow = [self.commas objectAtIndex:index];
                commaToShow.show = YES; 
                [self setSlotNumberAlignmentAccordingToSize:sizeFactor];
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
    
    [self repositionDigitsLookingForResize:YES];
}

- (void) setSpeed:(float)speed
{
    _speed = speed;
    for (SlotNumberLayer *slot in self.slots)
        slot.speed = _speed;
    for (SlotCommaLayer *comma in self.commas)
        comma.speed = _speed;
}

- (void) setMinimumFontSize:(int)minimumFontSize
{
    _minimumFontSize = minimumFontSize;

    if (_minimumFontSize < 0)
        _minimumFontSize = 1;
    if (_minimumFontSize > self.fontSize)
        _minimumFontSize = self.fontSize;
    if (_minimumFontSize < self.fontSize-50.0f)
        _minimumFontSize = self.fontSize-50.0f;
    [self repositionDigits];
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
        
        SlotCommaLayer *comma = [[SlotCommaLayer alloc] init];
        comma.position = CGPointMake((self.fontSize * i * .5) + self.fontSize*.5, self.fontSize*.5);
        comma.show = self.commasEnabled;
        [self.commas addObject:comma];
        [self addSublayer:comma];
    }
    
    self.speed = 5.0f;
    self.alignment = SlotAlignmentRight;
    originalSize = _size;
}

- (id) init
{
    if (self = [super init])
    {
        _size = kSlotsSizeMax;
        [self setDefaults];
    }
    return self;
}

- (id) initWithSize:(int) size
{
    if (self = [super init])
    {
        if (size > kSlotsSizeMax)
            _size = kSlotsSizeMax;
        else if (size < kSlotsSizeMin)
            _size = kSlotsSizeMin;
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
    
    [self repositionDigits];
}

//==================TODO: METHOD NEEDS REFACTORING?==================
- (void) setSlotNumberAlignmentAccordingToSize:(int) size
{
    //resets all commas back to right alignment
    for (SlotCommaLayer *comma in self.commas) {
        comma.alignmentMode = kCAAlignmentRight;
    }
    
    if (size > 6) 
    {        
        //sets right values to align right
        for (int i = 0; i < size; i++) {
            SlotNumberLayer *slot = [self.slots objectAtIndex:i];
            
            if (i < size-6)
                slot.alignmentMode = kCAAlignmentLeft;
            else if (i < size-3)
                slot.alignmentMode = kCAAlignmentCenter;
            else
                slot.alignmentMode = kCAAlignmentRight;
        }
        //check to see if two commas are shown
        //finds the the first comma
        //then sets the first comma to alingmentCenter
        int shownCommas = 0;
        for (SlotCommaLayer *comma in self.commas) {
            if (comma.show == YES)
                shownCommas++;
        }
        if (shownCommas >= 2)
        {
            for (SlotCommaLayer *comma in self.commas) {
                if (comma.show == YES) {
                    comma.alignmentMode = kCAAlignmentCenterRight;
                    break;
                }
            }
        }
    }
    else if (size > 3) 
    {
        int index = size - 3;
        
        //sets right values to align right
        for (int i = index; i < size; i++) {
            SlotNumberLayer *slot = [self.slots objectAtIndex:i];
            slot.alignmentMode = kCAAlignmentRight;
        }
        //resets left value to defaults
        for (int i = index-1; i >= 0; i--) {
            SlotNumberLayer *slot = [self.slots objectAtIndex:i];
            slot.alignmentMode = kCAAlignmentCenter;
        }

    }
}

- (BOOL) needsResizeWithFontSize:(float) fontSize
{
    return ((fontSize + self.padding)*self.numOfVisibleIntegers > self.contentSize.width);
}

- (int) numOfVisibleIntegers
{
    int count = 0;
    for (NSNumber *number in digits) {
        if ([number intValue] != -1)
            count++;
    }
    return count;
}

//always update fontsizes etc
- (void) repositionDigits
{
    [self repositionDigitsLookingForResize:NO];
}

//only refresh font size if have to (yes = must, no = depends)
- (void) repositionDigitsLookingForResize:(BOOL) isLookingForResize
{
    int fontSize = _fontSize;
    if (self.autoresize) {
        if ([self needsResizeWithFontSize:fontSize]) {
            int newFontSize = fontSize;
            while (newFontSize > self.minimumFontSize)
            {
                if ([self needsResizeWithFontSize:newFontSize])
                    newFontSize--;
                else
                    break;
            }
            fontSize = newFontSize;
        }
    }
    else {
        _contentSize = CGSizeMake(self.fontSize * self.size + self.padding,self.fontSize);
    }
    
    if ((isLookingForResize && fontSize < _fontSize) || (!isLookingForResize)) {
        for (int i = 0; i < self.size; i++) {
            SlotNumberLayer *slot = [self.slots objectAtIndex:i];
            slot.fontSize = fontSize;
            float previousX = (i > 0) ? ((SlotNumberLayer*)[self.slots objectAtIndex:i-1]).position.x : 0;
            SlotCommaLayer *comma = [self.commas objectAtIndex:i];
            comma.fontSize = fontSize;
            
            slot.position = CGPointMake(previousX + fontSize * .5f + self.padding, self.contentSize.height);
            comma.position = slot.position;
        }
    }
}

@end
