

#import <UIKit/UIKit.h>
#import "TIBLECBKeyfob.h"

@interface TIBLEViewController : UIViewController <TIBLECBKeyfobDelegate> { 
    TIBLECBKeyfob *t; //TI keyfob class (private)
}

// UI elements actions
- (IBAction)TIBLEUIScanForPeripheralsButton:(id)sender;
- (IBAction)TIBLEUISoundBuzzerButton:(id)sender;
- (IBAction)Start:(id)sender;


// UI elements outlets
@property (weak, nonatomic) IBOutlet UIButton *Start;
@property (weak, nonatomic) IBOutlet UIProgressView *TIBLEUIBatteryBar;
@property (weak, nonatomic) IBOutlet UILabel *TIBLEUIBatteryBarLabel;
@property (weak, nonatomic) IBOutlet UIProgressView *TIBLEUIAccelXBar;
@property (weak, nonatomic) IBOutlet UIProgressView *TIBLEUIAccelYBar;
@property (weak, nonatomic) IBOutlet UIProgressView *TIBLEUIAccelZBar;
@property (weak, nonatomic) IBOutlet UISwitch *TIBLEUILeftButton;
@property (weak, nonatomic) IBOutlet UISwitch *TIBLEUIRightButton;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *TIBLEUISpinner;
@property (weak, nonatomic) IBOutlet UIButton *TIBLEUIConnBtn;


//Timer methods
- (void) batteryIndicatorTimer:(NSTimer *)timer;
- (void) connectionTimer:(NSTimer *)timer;

@end
