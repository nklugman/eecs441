//
//  AutoViewController.m
//  smallFoot
//
//  Created by Ben Perkins on 4/5/13.
//  Copyright (c) 2013 Klugman, Tsai & Perkins. All rights reserved.
//

#import "AutoViewController.h"

const double MS2MPH = 2.23694;

bool running;
double averageSpeed;
int speedSamples;
long startTime;

@interface AutoViewController ()

@end

@implementation AutoViewController

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
    [_map setDelegate:self];
    [super viewDidLoad];
    [_recording setHidden:YES];
    [_recordingIndicator setHidden:YES];
    startTime = [[NSDate date] timeIntervalSince1970];
    averageSpeed = 0;
    speedSamples = 0;
    [self centerMapOnUser];
    running = NO;
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)startStopButtonPressed:(id)sender {
    if([[[_startStopButton titleLabel] text] isEqualToString:@"Start"]){
        [_startStopButton setTitle:@"Stop" forState:UIControlStateNormal];
        [_recording setHidden:NO];
        [_recordingIndicator setHidden:NO];
        running = YES;
        startTime = [[NSDate date] timeIntervalSince1970];
        averageSpeed = 0;
        speedSamples = 0;
        //[_progress setHidden:NO];
        [self getLocation];

    }else{
        [_startStopButton setTitle:@"Start" forState:UIControlStateNormal];
        [_recording setHidden:YES];
        [_recordingIndicator setHidden:YES];
        running = NO;
        [_progress setHidden:YES];
    }
}

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{    
    [self centerMapOnUser];
}

-(void)centerMapOnUser
{
    _map.showsUserLocation = YES;
    
    MKUserLocation *userLocation = _map.userLocation;
    
    //double accuracy = [[userLocation location] horizontalAccuracy];
    CLLocationCoordinate2D coordinate = [[userLocation location] coordinate];
    
    
    MKCoordinateRegion region =
    MKCoordinateRegionMakeWithDistance (coordinate, 2000, 2000);
    [_map setRegion:region animated:NO];
    //if(accuracy == 0) [self performSelector:@selector(centerMapOnUser) withObject:self afterDelay:0.1 ];
    //if(!running) [self performSelector:@selector(centerMapOnUser) withObject:self afterDelay:2];
    //if(running) [self getLocation];
}

-(void)getLocation
{
    MKUserLocation *userLocation = _map.userLocation;
    double distance = 0;
    double speed = [[userLocation location] speed] * MS2MPH;
    double time = ([[NSDate date] timeIntervalSince1970] - startTime);
    int hours = time / 3600;
    int minutes = (time - (hours * 3600)) / 60;
    int seconds = (time - (hours * 3600) - (minutes * 60));
    if(speed > 0)
    {
        averageSpeed *= speedSamples;
        speedSamples++;
        averageSpeed += speed;
        averageSpeed /= speedSamples;
    }
    distance = averageSpeed * time / 3600;
    
    [_currentSpeed setText:[NSString stringWithFormat:@"%0.2fmph", speed]];
    [_averageSpeed setText:[NSString stringWithFormat:@"%0.2fmph", averageSpeed]];
    [_time setText:[NSString stringWithFormat:@"%02d:%02d:%02d", hours, minutes, seconds]];
    [_distance setText:[NSString stringWithFormat:@"%0.3fmi", distance]];
    
    if((int)time % 2 == 0)
    {
        [_recordingIndicator setImage:[UIImage imageNamed:@"recordOff"]];
    }
    else
    {
        [_recordingIndicator setImage:[UIImage imageNamed:@"recordOn"]];
    }
    
    if(running) [self performSelector:@selector(getLocation) withObject:self afterDelay:0.5 ];
}
@end
