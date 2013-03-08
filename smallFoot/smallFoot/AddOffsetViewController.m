//
//  AddOffsetViewController.m
//  smallFoot
//
//  Created by Ben Perkins on 3/7/13.
//  Copyright (c) 2013 Klugman, Tsai & Perkins. All rights reserved.
//

#import "AddOffsetViewController.h"

@interface AddOffsetViewController ()

@end

@implementation AddOffsetViewController

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
	// Do any additional setup after loading the view.
    
    // Copy offsetLog.plist to Documents folder if not already present
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    NSString *plistPath = [documentsDirectory stringByAppendingPathComponent:@"offsetLog.plist"];
    
    if (![fileManager fileExistsAtPath:plistPath]) {
        NSString *resourcePath = [[NSBundle mainBundle] pathForResource:@"offsetLog" ofType:@"plist"];
        [fileManager copyItemAtPath:resourcePath toPath:plistPath error:&error];
        NSLog(@"%@", error);
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if(sender == _saveButton)
    {
        NSLog(@"About to save offset info");
        [self saveOffset];
    }
    [self.view endEditing:YES];
}

- (void)saveOffset {
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    path = [path stringByAppendingPathComponent:@"offsetLog.plist"];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if (![fileManager fileExistsAtPath:path])
    {
        NSLog(@"File does not exist");
    }
    
    // Read offsetLog.plist to NSMutableDictionary gasLog
    NSMutableDictionary *offsetLog = [[NSMutableDictionary alloc] initWithContentsOfFile:path];
    
    // Retrieve each of the three arrays (gallonsArray stores doubles, unleadedArray stores Booleans, dateArray stores dates)
    NSMutableArray* treeCountArray = [offsetLog objectForKey:@"count"];
    NSMutableArray* dateArray = [offsetLog objectForKey:@"date"];
    
    // If any of the arrays are empty, initialize them
    if(treeCountArray == nil) treeCountArray = [[NSMutableArray alloc] init];
    if(dateArray == nil) dateArray = [[NSMutableArray alloc] init];
    
    // Insert the most recent data
    [treeCountArray addObject:[NSNumber numberWithInt:[[_treesTextField text] intValue]]];
    [dateArray addObject:[NSDate date]];
    // Debugging stuff
    NSLog(@"Trees: %@", treeCountArray);
    NSLog(@"Date: %@", dateArray);
    
    // Add these arrays back into the dictionary
    [offsetLog setObject:treeCountArray forKey:@"count"];
    [offsetLog setObject:dateArray forKey:@"date"];
    
    // Write the dictionary back to the plist
    [offsetLog writeToFile:path atomically:YES];
}
@end
