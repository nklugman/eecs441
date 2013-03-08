//
//  AddGasViewController.m
//  smallFoot
//
//  Created by Ben Perkins on 3/7/13.
//  Copyright (c) 2013 Klugman, Tsai & Perkins. All rights reserved.
//

#import "AddGasViewController.h"

@interface AddGasViewController ()

@end

@implementation AddGasViewController

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
    [_gallonsTextField setText:@""];
    [_gallonsTextField setUserInteractionEnabled:YES];
    [_gallonsTextField setEnabled:YES];
	// Do any additional setup after loading the view.
    
    // Copy gasLog.plist to Documents folder if not already present
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    NSString *plistPath = [documentsDirectory stringByAppendingPathComponent:@"gasLog.plist"];
    
    if (![fileManager fileExistsAtPath:plistPath]) {
        NSString *resourcePath = [[NSBundle mainBundle] pathForResource:@"gasLog" ofType:@"plist"];
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
        NSLog(@"About to save gas info");
        [self saveGas];
    }
    [self.view endEditing:YES];
}

- (void)saveGas {
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    path = [path stringByAppendingPathComponent:@"gasLog.plist"];

    NSFileManager *fileManager = [NSFileManager defaultManager];

    if (![fileManager fileExistsAtPath:path])
    {
        NSLog(@"File does not exist");
    }
    
    // Read gasLog.plist to NSMutableDictionary gasLog
    NSMutableDictionary *gasLog = [[NSMutableDictionary alloc] initWithContentsOfFile:path];

    // Retrieve each of the three arrays (gallonsArray stores doubles, typeArray stores Booleans, dateArray stores dates)
    NSMutableArray* gallonsArray = [gasLog objectForKey:@"gallons"];
    NSMutableArray* typeArray = [gasLog objectForKey:@"type"];
    NSMutableArray* dateArray = [gasLog objectForKey:@"date"];
    
    // If any of the arrays are empty, initialize them
    if(gallonsArray == nil) gallonsArray = [[NSMutableArray alloc] init];
    if(typeArray == nil) typeArray = [[NSMutableArray alloc] init];
    if(dateArray == nil) dateArray = [[NSMutableArray alloc] init];
    
    // Insert the most recent data
    [gallonsArray addObject:[NSNumber numberWithDouble:[[_gallonsTextField text] doubleValue]]];
    [typeArray addObject:[NSNumber numberWithInt:[_gasTypePicker selectedSegmentIndex]]];
    [dateArray addObject:[NSDate date]];
    // Debugging stuff
    NSLog(@"Gallons: %@", gallonsArray);
    NSLog(@"type: %@", typeArray);
    NSLog(@"Date: %@", dateArray);
    
    // Add these arrays back into the dictionary
    [gasLog setObject:gallonsArray forKey:@"gallons"];
    [gasLog setObject:typeArray forKey:@"type"];
    [gasLog setObject:dateArray forKey:@"date"];

    // Write the dictionary back to the plist
    [gasLog writeToFile:path atomically:YES];
    
    [_gallonsTextField setText:@""];
    [_gallonsTextField setUserInteractionEnabled:YES];
}
@end
