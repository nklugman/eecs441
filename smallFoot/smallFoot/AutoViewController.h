//
//  AutoViewController.h
//  smallFoot
//
//  Created by Ben Perkins on 4/5/13.
//  Copyright (c) 2013 Klugman, Tsai & Perkins. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface AutoViewController : UIViewController <MKMapViewDelegate>
{
    //CLLocationManager *locationManager;
}

@property (nonatomic, retain) CLLocationManager *locationManager;
@property (weak, nonatomic) IBOutlet UIButton *startStopButton;
@property (strong, nonatomic) IBOutlet MKMapView *map;
@property (weak, nonatomic) IBOutlet UILabel *currentSpeed;
@property (weak, nonatomic) IBOutlet UILabel *averageSpeed;
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UILabel *distance;
@property (weak, nonatomic) IBOutlet UIImageView *progress;
@property (weak, nonatomic) IBOutlet UILabel *recording;
@property (weak, nonatomic) IBOutlet UIImageView *recordingIndicator;


- (IBAction)startStopButtonPressed:(id)sender;
- (void)centerMapOnUser;
- (void)getLocation;
- (void)showPin:(BOOL)start;
- (void)centerMapOnTrip;
- (void)removeAllPins;

@end
