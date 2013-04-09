//
//  AutoViewController.m
//  smallFoot
//
//  Created by Ben Perkins on 4/5/13.
//  Copyright (c) 2013 Klugman, Tsai & Perkins. All rights reserved.
//

#import "AutoViewController.h"
#import "AddressAnnotation.h"
#import <CoreLocation/CoreLocation.h>

const double MS2MPH = 2.23694;

bool running;
double averageSpeed;
int speedSamples;
long startTime;
bool shouldUpdatePosition;
CLLocationCoordinate2D startPoint;
CLLocationCoordinate2D stopPoint;

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
    shouldUpdatePosition = YES;
    
    [_reviewDistance setHidden:YES];
    [_reviewLabelDistance setHidden:YES];
    [_reviewLabel setHidden:YES];
    [_reviewLabelTransportation setHidden:YES];
    [_reviewTransportation setHidden:YES];
    // Load custom button images

    UIImage *buttonImage = [[UIImage imageNamed:@"greyButton.png"]
                            resizableImageWithCapInsets:UIEdgeInsetsMake(18, 18, 18, 18)];
    UIImage *buttonImageHighlight = [[UIImage imageNamed:@"greyButtonHighlight.png"]
                                     resizableImageWithCapInsets:UIEdgeInsetsMake(18, 18, 18, 18)];
    [_startStopButton setBackgroundImage:buttonImage forState:UIControlStateNormal];
    [_startStopButton setBackgroundImage:buttonImageHighlight forState:UIControlStateHighlighted];
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
        _map.showsUserLocation = YES;
        shouldUpdatePosition = YES;
        running = YES;
        startTime = [[NSDate date] timeIntervalSince1970];
        averageSpeed = 0;
        speedSamples = 0;
        //[_progress setHidden:NO];
        [self removeAllPins];
        [self showPin:YES];
        [self getLocation];
    }else if([[[_startStopButton titleLabel] text] isEqualToString:@"Stop"]){
        [_startStopButton setTitle:@"Save" forState:UIControlStateNormal];
        [_recording setHidden:YES];
        [_recordingIndicator setHidden:YES];
        _map.showsUserLocation = NO;
        shouldUpdatePosition = NO;
        running = NO;
        [self showPin:NO];
        [self centerMapOnTrip];
        [_progress setHidden:YES];
        [self reviewData];
    }else if([[[_startStopButton titleLabel] text] isEqualToString:@"Save"]){
        [_startStopButton setTitle:@"Start" forState:UIControlStateNormal];
        [self saveData];
        shouldUpdatePosition = YES;
        [self removeAllPins];
        [self centerMapOnUser];
    }
}

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{    
    [self centerMapOnUser];
}

-(void)centerMapOnUser
{
    if(!shouldUpdatePosition) return;
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

-(void)centerMapOnTrip
{
    CLLocationCoordinate2D middle;
    middle.latitude = (startPoint.latitude + startPoint.latitude) / 2;
    middle.longitude = (startPoint.longitude + startPoint.longitude) / 2;
    CLLocationDistance d = [[[CLLocation alloc] initWithLatitude:startPoint.latitude longitude:startPoint.longitude] distanceFromLocation:[[CLLocation alloc] initWithLatitude:stopPoint.latitude longitude:stopPoint.longitude]];
    MKCoordinateRegion region =
    MKCoordinateRegionMakeWithDistance (middle, 3*d, 3*d);
    [_map setRegion:region animated:YES];
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

- (void)reviewData
{
    NSString *distance = [[[_distance text] componentsSeparatedByCharactersInSet:
                           [[NSCharacterSet characterSetWithCharactersInString:@".0123456789"]
                            invertedSet]]
                          componentsJoinedByString:@""];
    float speed = [[[[_averageSpeed text] componentsSeparatedByCharactersInSet:
                     [[NSCharacterSet characterSetWithCharactersInString:@".0123456789"]
                      invertedSet]]
                    componentsJoinedByString:@""] floatValue];
    [_reviewDistance setText:distance];
    if(speed < 7.5) [_reviewTransportation setSelectedSegmentIndex:3]; // walking & jogging
    else if(speed < 20) [_reviewTransportation setSelectedSegmentIndex:2]; // biking
    else if(speed < 35) [_reviewTransportation setSelectedSegmentIndex:1]; // bus - bad metric, but best I can do for now
    else if(speed < 90) [_reviewTransportation setSelectedSegmentIndex:0]; // car
    else [_reviewTransportation setSelectedSegmentIndex:4]; // train
    
    [_startStopButton setTitle:@"Save" forState:UIControlStateNormal];
    
    [_reviewDistance setHidden:NO];
    [_reviewLabelDistance setHidden:NO];
    [_reviewLabel setHidden:NO];
    [_reviewLabelTransportation setHidden:NO];
    [_reviewTransportation setHidden:NO];
}

- (void)saveData
{
    [_reviewDistance setHidden:YES];
    [_reviewLabelDistance setHidden:YES];
    [_reviewLabel setHidden:YES];
    [_reviewLabelTransportation setHidden:YES];
    [_reviewTransportation setHidden:YES];
    
    // Copy awardLog.plist to Documents folder if not already present
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    NSString *plistPath = [documentsDirectory stringByAppendingPathComponent:@"awardLog.plist"];
    
    if (![fileManager fileExistsAtPath:plistPath]) {
        NSString *resourcePath = [[NSBundle mainBundle] pathForResource:@"awardLog" ofType:@"plist"];
        [fileManager copyItemAtPath:resourcePath toPath:plistPath error:&error];
        NSLog(@"%@", error);
    }
    
    // Save Data
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    path = [path stringByAppendingPathComponent:@"awardLog.plist"];
    
    if (![fileManager fileExistsAtPath:path])
    {
        NSLog(@"File does not exist");
    }
    
    // Read gasLog.plist to NSMutableDictionary gasLog
    NSMutableDictionary *awardLog = [[NSMutableDictionary alloc] initWithContentsOfFile:path];
    
    // Retrieve each of the three arrays (gallonsArray stores doubles, typeArray stores Booleans, dateArray stores dates)
    NSMutableArray* distanceArray = [awardLog objectForKey:@"distance"];
    NSMutableArray* typeArray = [awardLog objectForKey:@"type"];
    NSMutableArray* dateArray = [awardLog objectForKey:@"date"];
    
    // If any of the arrays are empty, initialize them
    if(distanceArray == nil) distanceArray = [[NSMutableArray alloc] init];
    if(typeArray == nil) typeArray = [[NSMutableArray alloc] init];
    if(dateArray == nil) dateArray = [[NSMutableArray alloc] init];
    
    // Insert the most recent data
    [distanceArray addObject:[NSNumber numberWithDouble:[[_reviewDistance text] doubleValue]]];
    [typeArray addObject:[NSNumber numberWithInt:[_reviewTransportation selectedSegmentIndex]]];
    [dateArray addObject:[NSDate date]];
    // Debugging stuff
    NSLog(@"Distance: %@", distanceArray);
    NSLog(@"type: %@", typeArray);
    NSLog(@"Date: %@", dateArray);
    
    // Add these arrays back into the dictionary
    [awardLog setObject:distanceArray forKey:@"distance"];
    [awardLog setObject:typeArray forKey:@"type"];
    [awardLog setObject:dateArray forKey:@"date"];
    
    // Write the dictionary back to the plist
    [awardLog writeToFile:path atomically:YES];
    
    [_reviewDistance setText:@""];
    [_reviewDistance setUserInteractionEnabled:YES];
    
}

-(void)showPin:(BOOL)start
{
    MKUserLocation *userLocation = _map.userLocation;
    if(start)
    {
        NSLog(@"Making point...");
        startPoint = [[userLocation location] coordinate];
        AddressAnnotation *addAnnotation = [[AddressAnnotation alloc] initWithCoordinate:startPoint];
        [_map addAnnotation:addAnnotation];
    }
    else
    {
        NSLog(@"Making point...");
        stopPoint = [[userLocation location] coordinate];
        AddressAnnotation *addAnnotation = [[AddressAnnotation alloc] initWithCoordinate:stopPoint];
        [_map addAnnotation:addAnnotation];
    }
}

-(void)removeAllPins
{
    id userLocation = [_map userLocation];
    NSMutableArray *pins = [[NSMutableArray alloc] initWithArray:[_map annotations]];
    if ( userLocation != nil ) {
        [pins removeObject:userLocation]; // avoid removing user location off the map
    }
    
    [_map removeAnnotations:pins];
}

@end
