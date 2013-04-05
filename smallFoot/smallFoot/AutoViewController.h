//
//  AutoViewController.h
//  smallFoot
//
//  Created by Ben Perkins on 4/5/13.
//  Copyright (c) 2013 Klugman, Tsai & Perkins. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AutoViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIButton *startStopButton;
- (IBAction)startStopButtonPressed:(id)sender;

@end
