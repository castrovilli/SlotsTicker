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
    //slots = [[SlotsController alloc] initWithSize:2];
    
    [self.view.layer addSublayer:slots];

    //set font using the font name of choice
    [slots setFontWithName:@"Arial"];

    //set font size
    slots.fontSize = 40.0f;
    
    //position the slots
    slots.position = CGPointMake(slots.fontSize*1.5, 160);
    
    //set the slots color (Default is White)
    slots.color = [[UIColor whiteColor] CGColor];
        
    //set extra padding between numbers (Default is 0)
    slots.padding = 2;
    
    //show zeros in front of number (Default is YES)
    slots.showZeros = NO;
    
    //enable commas to be displayed with your digits
    slots.commasEnabled = YES;
    
    //set specific allignments (Default is SlotAlignmentRight)
    slots.alignment = SlotAlignmentRight;
}

- (IBAction)animateSlots:(id)sender
{
    int a = 0;
    int b = pow(10,slots.size)-1;
    int random = ((arc4random() % b-a+1) + a);
    
    randomNumberLabel.text = [NSString stringWithFormat:@"Generated Number: %09d",random];
    
    slots.value = random;
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
