//
//  BLEViewController.h
//  smallFoot
//
//  Created by Noah Klugman on 4/9/13.
//  Copyright (c) 2013 Klugman, Tsai & Perkins. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TIBLECBKeyfob.h"

@interface BLEViewController : UIViewController <TIBLECBKeyfobDelegate>  {
    TIBLECBKeyfob *t;
}

// UI elements actions
- (IBAction)BLEUIScanForPeripheralsButton:(id)sender;
- (IBAction)Start:(id)sender;

// UI elements outlets
@property (weak, nonatomic) IBOutlet UIButton *BLEUIConnBtn;
@property (weak, nonatomic) IBOutlet UIButton *Start;
@property (weak, nonatomic) IBOutlet UIProgressView *BLEUIBatteryBar;
@property (weak, nonatomic) IBOutlet UILabel *BLEUIBatteryBarLabel;
@property (weak, nonatomic) IBOutlet UIProgressView *BLEUIAccelZBar;
@property (weak, nonatomic) IBOutlet UIProgressView *BLEUIAccelYBar;
@property (weak, nonatomic) IBOutlet UIProgressView *BLEUIAccelXBar;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *BLEUISpinner;

//Timer methods
- (void) batteryIndicatorTimer:(NSTimer *)timer;
- (void) connectionTimer:(NSTimer *)timer;


@end
