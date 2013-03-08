//
//  FirstViewController.m
//  smallFoot
//
//  Created by Ben Perkins on 3/7/13.
//  Copyright (c) 2013 Klugman, Tsai & Perkins. All rights reserved.
//

#import "FirstViewController.h"

@interface FirstViewController ()

@end

@implementation FirstViewController 

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

- (IBAction)emptyButtonPressed:(id)sender {
    // This literally trashes the plist file WITHOUT ANY CONFIRMATION WHATSOEVER
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Delete" message:@"This will erase ALL entries" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Ok", nil];
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 1)
    {
        // Get path for gasLog.plist
        NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
        NSString *gasPath = [path stringByAppendingPathComponent:@"gasLog.plist"];
        NSString *electricPath = [path stringByAppendingPathComponent:@"electricLog.plist"];
        NSString *offsetPath = [path stringByAppendingPathComponent:@"offsetLog.plist"];
        
        // Create empty dictionary
        NSMutableDictionary *emptyLog = [[NSMutableDictionary alloc] init];
        
        // Write the empty dictionary back to the plist
        [emptyLog writeToFile:gasPath atomically:YES];
        [emptyLog writeToFile:electricPath atomically:YES];
        [emptyLog writeToFile:offsetPath atomically:YES];
        NSLog(@"Trashed plists");
        [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadContributionsTable" object:nil];
    }
}
@end
