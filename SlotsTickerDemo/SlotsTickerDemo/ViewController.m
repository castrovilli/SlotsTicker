//
//  ViewController.m
//  SlotsTickerDemo
//
//  Created by Mark Glagola on 6/21/12.
//  Copyright (c) 2012 Independent. All rights reserved.
//

#import "ViewController.h"
#import "AppDelegate.h"
#import "SlotsController.h"

@interface ViewController ()
{
    SlotsController *slots;
    IBOutlet UILabel *randomNumberLabel;
}
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //init and add to layer
    slots = [[SlotsController alloc] init];
    
    //can also init the controller by setting its max size (default is 9)
    //slots = [[SlotsController alloc] initWithSize:5];
    
    [self.view.layer addSublayer:slots];
    
    //set font using the font name of choice
    [slots setFontWithName:@"Arial"];

    //set font size
    slots.fontSize = 40.0f;
    
    //RECOMENDED: Wait till next update to use the autoresize feature
    //This feature has some bugs and needs to be fixed/refactored
    //Next update shouldn't be that far away
//    slots.autoresize = YES;
//    slots.contentSize = CGSizeMake(slots.contentSize.width*.5, slots.contentSize.height);
//    slots.minimumFontSize = 20;
    
    //position the slots
    slots.position = CGPointMake(slots.fontSize*1.5, 160);
    
    //set the slots color (Default is White)
    slots.color = [[UIColor whiteColor] CGColor];
        
    //set extra padding between numbers (Default is 0)
    slots.padding = 5;
    
    //show zeros in front of number (Default is YES)
    slots.showZeros = NO;
    
    //enable commas to be displayed with your digits
    slots.commasEnabled = YES;
                    
    //set specific allignments (Default is SlotAlignmentLeft)
    slots.alignment = SlotAlignmentRight;
}

- (IBAction)animateSlots:(id)sender
{
    int a = 0;
    int size = ((arc4random() % slots.size) + 1);
    int b = pow(10,size)-1;
    int random = ((arc4random() % b-a+1) + a);
    
    randomNumberLabel.text = [NSString stringWithFormat:@"Generated Number: %09d",random];
    
    slots.value = random;
}

- (IBAction)reposition:(id)sender
{
    [slots repositionTextLayerAtCurrentValue];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

@end
