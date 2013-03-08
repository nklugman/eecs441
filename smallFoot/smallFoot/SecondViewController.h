//
//  SecondViewController.h
//  smallFoot
//
//  Created by Ben Perkins on 3/7/13.
//  Copyright (c) 2013 Klugman, Tsai & Perkins. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SecondViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIBarButtonItem *nextMonthButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *lastMonthButton;
@property (retain, nonatomic) IBOutlet UINavigationItem *navigationTitle;

- (IBAction)nextMonthButtonPressed:(id)sender;
- (IBAction)lastMonthButtonPressed:(id)sender;

@end
