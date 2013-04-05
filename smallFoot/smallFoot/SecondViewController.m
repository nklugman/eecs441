//
//  SecondViewController.m
//  smallFoot
//
//  Created by Ben Perkins on 3/7/13.
//  Copyright (c) 2013 Klugman, Tsai & Perkins. All rights reserved.
//

#import "SecondViewController.h"

@interface SecondViewController ()

@end

@implementation SecondViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)nextMonthButtonPressed:(id)sender {
    [_nextMonthButton setEnabled:NO];
    [_lastMonthButton setEnabled:YES];
    [_navigationTitle setTitle:@"Your Carbon Footprint - April 2013"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"loadFootprint" object:nil];
}

- (IBAction)lastMonthButtonPressed:(id)sender {
    [_nextMonthButton setEnabled:YES];
    [_lastMonthButton setEnabled:NO];
    [_navigationTitle setTitle:@"Your Carbon Footprint - March 2013"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"loadOldFootprint" object:nil];
}
@end
