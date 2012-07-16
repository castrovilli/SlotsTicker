//
//  SlotsController.h
//  SlotsTickerDemo
//
//  Created by Mark Glagola on 6/21/12.
//  Copyright (c) 2012 Independent. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>

typedef enum
{
    SlotAlignmentMin = 0,
    SlotAlignmentLeft,
    SlotAlignmentRight,
}SlotAlignment;

@interface SlotsController : CALayer

//Array containing all SlotLayers
@property (nonatomic) NSMutableArray *slots;

//the font size for all SlotLayers
@property (nonatomic) CGFloat fontSize;

//the font color for all SlotLayers
@property (nonatomic) CGColorRef color;

//Set this to animate
//MUST BE a positive # and between 0 and (10^self.size - 1)
@property (nonatomic) int value;

//the slot animation speed for all SlotLayers
@property (nonatomic) float speed;

//The amount of SlotLayers initialized (readonly)
@property (nonatomic, readonly) int size;

//extra padding between CALayers (Default is 0) 
@property (nonatomic) int padding;

//the size of the slot controller
@property (nonatomic,readonly) CGSize contentSize;

//Enable/Disable zeros in front of numbers (Default is YES)
//YES = 000321018
//NO = 321018
@property (nonatomic, getter = isShowingZeros) BOOL showZeros;

//Enable/Disable commas (Default is NO)
@property (nonatomic, getter = isCommasEnabled) BOOL commasEnabled;

//Enable/Disable autoresize font (Default is NO)
@property (nonatomic, getter = isAutoresizeEnabled) BOOL autoresize;

//Set minimumFontSize for autoresizing
//If changed autoresizing is automatically enabled
//Default is self.fontSize
@property (nonatomic) int minimumFontSize;

//Default is SlotAlignmentLeft
//Only used when "showZeros" is set to NO
@property (nonatomic) SlotAlignment alignment;

//Set the max amount of SlotLayers to be initialized (Default is 9)
- (id) initWithSize:(int) size;

//sets the font for all SlotLayers
- (void) setFontWithName:(NSString*) name;

@end
