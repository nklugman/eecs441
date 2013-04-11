//
//  BLEViewController.m
//  smallFoot
//
//  Created by Noah Klugman on 4/9/13.
//  Copyright (c) 2013 Klugman, Tsai & Perkins. All rights reserved.
//

#import "BLEViewController.h"
#import "AutoViewController.h"

@interface BLEViewController ()

@end

@implementation BLEViewController
@synthesize BLEUIBatteryBar;
@synthesize BLEUIBatteryBarLabel;
@synthesize BLEUIAccelXBar;
@synthesize BLEUIAccelYBar;
@synthesize BLEUIAccelZBar;
@synthesize BLEUISpinner;
@synthesize BLEUIConnBtn;
@synthesize Start;

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
    t = [[TIBLECBKeyfob alloc] init];   // Init TIBLECBKeyfob class.
    [t controlSetup:1];                 // Do initial setup of TIBLECBKeyfob class.
    t.delegate = self;                  // Set TIBLECBKeyfob delegate class to point at methods implemented in this class.
    t.TIBLEConnectBtn = self.BLEUIConnBtn;}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)BLEUIScanForPeripheralsButton:(id)sender {
    if (t.activePeripheral) {
        if(t.activePeripheral.isConnected) {
            [[t CM] cancelPeripheralConnection:[t activePeripheral]];
            [BLEUIConnBtn setTitle:@"Scan" forState:UIControlStateNormal];
            t.activePeripheral = nil;
        }
    } else {
        if (t.peripherals) t.peripherals = nil;
        [t findBLEPeripherals:5];
        //        [NSTimer scheduledTimerWithTimeInterval:(float)5.0 target:self selector:@selector(connectionTimer:) userInfo:nil repeats:NO];
        [BLEUISpinner startAnimating];
        [BLEUIConnBtn setTitle:@"Scanning.." forState:UIControlStateNormal];
    }
}



- (IBAction)Start:(id)sender {
    NSString *state = [sender titleForState:UIControlStateNormal];
    if ([state isEqualToString:@"Start"]) {
        [Start setTitle:@"Stop" forState:UIControlStateNormal];
    }
    if ([state isEqualToString:@"Stop"]) {
        [Start setTitle:@"Start" forState:UIControlStateNormal];
    }
}

- (void) batteryIndicatorTimer:(NSTimer *)timer {
    BLEUIBatteryBar.progress = t.batteryLevel / 100;
    [t readBattery:[t activePeripheral]];               // Read battery value of keyfob again
    
}

-(void) accelerometerValuesUpdated:(char)x y:(char)y z:(char)z {
    BLEUIAccelXBar.progress = (float)(x + 50) / 100;
    BLEUIAccelYBar.progress = (float)(y + 50) / 100;
    BLEUIAccelZBar.progress = (float)(z + 50) / 100;
}

-(void) keyValuesUpdated:(char)sw {
    printf("Key values updated ! \r\n");
    if (sw & 0x1) {
        NSLog(@"BUTTON 1 ON");
        
        [Start setTitle:(@"Stop") forState:UIControlStateNormal];
    }
    if (sw & 0x2) {
        NSLog(@"BUTTON 2 ON");
        [Start setTitle:(@"Start") forState:UIControlStateNormal];
        
    }
    
}

-(void) keyfobReady {
    [BLEUIConnBtn setTitle:@"Disconnect" forState:UIControlStateNormal];
    // Start battery indicator timer, calls batteryIndicatorTimer method every 2 seconds
    [NSTimer scheduledTimerWithTimeInterval:(float)2.0 target:self selector:@selector(batteryIndicatorTimer:) userInfo:nil repeats:YES];
    [t enableAccelerometer:[t activePeripheral]];   // Enable accelerometer (if found)
    [t enableButtons:[t activePeripheral]];         // Enable button service (if found)
    [t enableTXPower:[t activePeripheral]];         // Enable TX power service (if found)
    [Start setTitle:(@"Start") forState:UIControlStateNormal];
    [BLEUISpinner stopAnimating];
}

-(void) connectionTimer:(NSTimer *)timer {
    [BLEUISpinner stopAnimating];
    [BLEUIConnBtn setTitle:@"Scan" forState:UIControlStateNormal];
}

@end
