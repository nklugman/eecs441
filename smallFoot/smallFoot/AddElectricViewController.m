//
//  AddElectricViewController.m
//  smallFoot
//
//  Created by Ben Perkins on 3/7/13.
//  Copyright (c) 2013 Klugman, Tsai & Perkins. All rights reserved.
//

#import "AddElectricViewController.h"

@interface AddElectricViewController ()

@end

@implementation AddElectricViewController

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
    
    // Copy electricLog.plist to Documents folder if not already present
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    NSString *plistPath = [documentsDirectory stringByAppendingPathComponent:@"electricLog.plist"];
    
    if (![fileManager fileExistsAtPath:plistPath]) {
        NSString *resourcePath = [[NSBundle mainBundle] pathForResource:@"electricLog" ofType:@"plist"];
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
        NSLog(@"About to save electric info");
        [self saveElectric];
    }
    [self.view endEditing:YES];
}

- (IBAction)useAverageButtonPressed:(id)sender {
    [_kwhTextField setText:@"958"];
}

- (void)saveElectric {
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    path = [path stringByAppendingPathComponent:@"electricLog.plist"];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if (![fileManager fileExistsAtPath:path])
    {
        NSLog(@"File does not exist");
    }
    
    // Read electricLog.plist to NSMutableDictionary gasLog
    NSMutableDictionary *electricLog = [[NSMutableDictionary alloc] initWithContentsOfFile:path];
    
    // Retrieve each of the three arrays (gallonsArray stores doubles, unleadedArray stores Booleans, dateArray stores dates)
    NSMutableArray* kwhArray = [electricLog objectForKey:@"kwh"];
    NSMutableArray* typeArray = [electricLog objectForKey:@"type"];
    NSMutableArray* dateArray = [electricLog objectForKey:@"date"];
    
    // If any of the arrays are empty, initialize them
    if(kwhArray == nil) kwhArray = [[NSMutableArray alloc] init];
    if(typeArray == nil) typeArray = [[NSMutableArray alloc] init];
    if(dateArray == nil) dateArray = [[NSMutableArray alloc] init];
    
    // Insert the most recent data
    
    double kwhForMonth = [[_kwhTextField text] doubleValue];
    int electricSourceType = [_electricSourcePicker selectedSegmentIndex];
    int monthOffset = [_monthPicker selectedSegmentIndex] - 2;
    if(kwhForMonth >= 0) // Change >= to > to disallow entries of 0 (only allow for debugging purposes)
    {
        [kwhArray addObject:[NSNumber numberWithDouble:kwhForMonth]];
        [typeArray addObject:[NSNumber numberWithInt:electricSourceType]];
        
        NSDateComponents* dateComponents = [[NSDateComponents alloc]init];
        [dateComponents setMonth:monthOffset];
        NSCalendar* calendar = [NSCalendar currentCalendar];
        NSDate* newDate = [calendar dateByAddingComponents:dateComponents toDate:[NSDate date] options:0];

        [dateArray addObject:newDate];
        // Debugging stuff
        NSLog(@"KWH: %@", kwhArray);
        NSLog(@"Type: %@", typeArray);
        NSLog(@"Date: %@", dateArray);
        
        // Add these arrays back into the dictionary
        [electricLog setObject:kwhArray forKey:@"kwh"];
        [electricLog setObject:typeArray forKey:@"type"];
        [electricLog setObject:dateArray forKey:@"date"];
        
        // Write the dictionary back to the plist
        [electricLog writeToFile:path atomically:YES];
    }
}

@end
