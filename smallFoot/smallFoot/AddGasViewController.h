//
//  AddGasViewController.h
//  smallFoot
//
//  Created by Ben Perkins on 3/7/13.
//  Copyright (c) 2013 Klugman, Tsai & Perkins. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface AddGasViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIBarButtonItem *cancelButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *saveButton;
@property (weak, nonatomic) IBOutlet UISegmentedControl *gasTypePicker;
@property (retain, nonatomic) IBOutlet UITextField *gallonsTextField;
@property (weak, nonatomic) IBOutlet UIDatePicker *gasDatePicker;

- (void)saveGas;

@end
