//
//  FootprintViewController.m
//  smallFoot
//
//  Created by Ben Perkins on 3/7/13.
//  Copyright (c) 2013 Klugman, Tsai & Perkins. All rights reserved.
//

#import "FootprintViewController.h"
#import "GraphViewController.h"
#import "CarbonCalculator.h"

@interface FootprintViewController ()

@end

int currentYear;
int currentMonth;
bool isShowingLandscapeView;

@implementation FootprintViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)awakeFromNib
{
    isShowingLandscapeView = NO;
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(orientationChanged:)
                                                 name:UIDeviceOrientationDidChangeNotification
                                               object:nil];
}

- (void)orientationChanged:(NSNotification *)notification
{
    UIDeviceOrientation deviceOrientation = [UIDevice currentDevice].orientation;
    if (UIDeviceOrientationIsLandscape(deviceOrientation) &&
        !isShowingLandscapeView)
    {
      
        //[self performSegueWithIdentifier:@"graph" sender:self];
        isShowingLandscapeView = YES;
    }
    else if (UIDeviceOrientationIsPortrait(deviceOrientation) &&
             isShowingLandscapeView)
    {
        //[self dismissViewControllerAnimated:YES completion:nil];
        isShowingLandscapeView = NO;
    }
}


- (void)viewDidLoad
{
    
    // Get current month and year
    NSDate           *today           = [NSDate date];
    NSCalendar       *currentCalendar = [NSCalendar currentCalendar];
    
    NSDateComponents *monthComponents = [currentCalendar components:NSMonthCalendarUnit fromDate:today];
    currentMonth = [monthComponents month];
    
    NSDateComponents *yearComponents  = [currentCalendar components:NSYearCalendarUnit  fromDate:today];
    currentYear  = [yearComponents year];
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadOldData) name:@"loadOldFootprint" object: nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadData) name:@"loadFootprint" object: nil];
    [self showDataForMonth:currentMonth andYear:currentYear];
    
}

- (void)loadData
{
    [self showDataForMonth:currentMonth andYear:currentYear];
}

- (void)loadOldData
{
    [self showDataForMonth:(currentMonth-1) andYear:currentYear];
}

- (void)showDataForMonth: (int)month andYear:(int)year
{
    CarbonCalculator *calculator = [[CarbonCalculator alloc] init];
    [calculator calculateForMonth:month andYear:year];
    float gasRating = [calculator getGasolinePrint] / [calculator getAverageGasolinePrint];
    float electricRating = [calculator getElectricPrint] / [calculator getAverageElectricPrint];
    float totalRating = [calculator getTotalPrint] / [calculator getAverageTotalPrint];
    [_gasolineProgressBar setProgress:(gasRating/2)];
    [_electricProgressBar setProgress:(electricRating/2)];
    [_totalProgressBar setProgress:(totalRating/2)];
    _gasolineProgressBar.progressTintColor = [self getColorForRating:(gasRating/2)];
    _electricProgressBar.progressTintColor = [self getColorForRating:(electricRating/2)];
    _totalProgressBar.progressTintColor = [self getColorForRating:(totalRating/2)];
    
    [_gasolinePrintLabel setText:[NSString stringWithFormat:@"You used %0.2f pounds of carbon from gasoline this month", [calculator getGasolinePrint]]];
    [_electricPrintLabel setText:[NSString stringWithFormat:@"You used %0.2f pounds of carbon from electricity this month", [calculator getElectricPrint]]];
    [_totalPrintLabel setText:[NSString stringWithFormat:@"Your carbon footprint this month was %0.2f pounds", [calculator getTotalPrint]]];
    
    [_averageGasolinePrintLabel setText:[NSString stringWithFormat:@"The average American uses %0.0f pounds of carbon from gasoline per month", [calculator getAverageGasolinePrint]]];
    [_averageElectricPrintLabel setText:[NSString stringWithFormat:@"The average American uses %0.0f pounds of carbon from electricity per month", [calculator getAverageElectricPrint]]];
    [_averageTotalPrintLabel setText:[NSString stringWithFormat:@"The average American carbon footprint is %0.2f pounds", [calculator getAverageTotalPrint]]];
    
    
    [_gasolineRatingLabel setText:[NSString stringWithFormat:@"You used %.0f%% %@ than the average American", (gasRating < 1)?(100 - gasRating * 100):((gasRating - 1)*100), (gasRating < 1)?@"less":@"more"]];
    [_electricRatingLabel setText:[NSString stringWithFormat:@"You used %.0f%% %@ than the average American", (electricRating < 1)?(100 - electricRating * 100):((electricRating - 1)*100), (electricRating < 1)?@"less":@"more"]];
    [_totalRatingLabel setText:[NSString stringWithFormat:@"You used %.0f%% %@ than the average American", (totalRating < 1)?(100 - totalRating * 100):((totalRating - 1)*100), (totalRating < 1)?@"less":@"more"]];
    
    
    [_offsetLabel setText:[NSString stringWithFormat:@"You saved %0.2f pounds of carbon this month from the trees you've planted!", [calculator getOffset]]];
}

- (IBAction)graphButtonPressed:(id)sender {
    
}

- (UIColor*)getColorForRating: (float)rating
{
    if(rating > .80) return [UIColor redColor];
    if(rating > .60) return [UIColor orangeColor];
    if(rating > .40) return [[UIColor alloc] initWithRed:235.0 / 255 green:225.0 / 255 blue:0.0 / 255 alpha:1.0];
    return [[UIColor alloc] initWithRed:41.0 / 255 green:150.0 / 255 blue:38.0 / 255 alpha:1.0];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
