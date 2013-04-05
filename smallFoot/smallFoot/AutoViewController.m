//
//  AutoViewController.m
//  smallFoot
//
//  Created by Ben Perkins on 4/5/13.
//  Copyright (c) 2013 Klugman, Tsai & Perkins. All rights reserved.
//

#import "AutoViewController.h"

bool running;

@interface AutoViewController ()

@end

@implementation AutoViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    running = NO;
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)startStopButtonPressed:(id)sender {
    if([[[_startStopButton titleLabel] text] isEqualToString:@"Start"]){
        [_startStopButton setTitle:@"Stop" forState:UIControlStateNormal];
        running = YES;
    }else{
        [_startStopButton setTitle:@"Start" forState:UIControlStateNormal];
        running = NO;
    }
}
@end
