//
//  AddElectricViewController.h
//  smallFoot
//
//  Created by Ben Perkins on 3/7/13.
//  Copyright (c) 2013 Klugman, Tsai & Perkins. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddElectricViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIBarButtonItem *cancelButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *saveButton;
@property (weak, nonatomic) IBOutlet UISegmentedControl *electricSourcePicker;
@property (weak, nonatomic) IBOutlet UISegmentedControl *monthPicker;
@property (weak, nonatomic) IBOutlet UITextField *kwhTextField;


- (IBAction)useAverageButtonPressed:(id)sender;
- (void)saveElectric;
@end
