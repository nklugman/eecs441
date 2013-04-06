//
//  AutoViewController.m
//  smallFoot
//
//  Created by Ben Perkins on 4/5/13.
//  Copyright (c) 2013 Klugman, Tsai & Perkins. All rights reserved.
//

#import "AutoViewController.h"

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
    [super viewDidLoad];
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
        running = YES;
        startTime = [[NSDate date] timeIntervalSince1970];
        averageSpeed = 0;
        speedSamples = 0;
        //[_progress setHidden:NO];
        [self centerMapOnUser];

    }else{
        [_startStopButton setTitle:@"Start" forState:UIControlStateNormal];
        running = NO;
        [_progress setHidden:YES];
    }
}

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation{
    
    [self centerMapOnUser];
}

-(void)centerMapOnUser
{
    _map.showsUserLocation = YES;
    
    MKUserLocation *userLocation = _map.userLocation;
    
    double accuracy = [[userLocation location] horizontalAccuracy];
    CLLocationCoordinate2D coordinate = [[userLocation location] coordinate];
    
    
    MKCoordinateRegion region =
    MKCoordinateRegionMakeWithDistance (coordinate, 2500, 2500);
    [_map setRegion:region animated:NO];
    
    if(accuracy == 0) [self performSelector:@selector(centerMapOnUser) withObject:self afterDelay:0.1 ];
    if(running) [self getLocation];
}

-(void)getLocation
{
    
    MKUserLocation *userLocation = _map.userLocation;
    double distance = 0;
    double speed = [[userLocation location] speed];
    double time = ([[NSDate date] timeIntervalSince1970] - startTime);
    if(speed > 0)
    {
        averageSpeed *= speedSamples;
        speedSamples++;
        averageSpeed += speed;
        averageSpeed /= speedSamples;
    }
    distance = averageSpeed * time;
    
    [_currentSpeed setText:[NSString stringWithFormat:@"%0.8f", speed]];
    [_averageSpeed setText:[NSString stringWithFormat:@"%0.8f", averageSpeed]];
    [_time setText:[NSString stringWithFormat:@"%0.1f", time]];
    [_distance setText:[NSString stringWithFormat:@"%0.4f", distance]];
    
    if(running) [self performSelector:@selector(centerMapOnUser) withObject:self afterDelay:0.1 ];
}
@end
