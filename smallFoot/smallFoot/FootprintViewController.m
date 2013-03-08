//
//  FootprintViewController.m
//  smallFoot
//
//  Created by Ben Perkins on 3/7/13.
//  Copyright (c) 2013 Klugman, Tsai & Perkins. All rights reserved.
//

#import "FootprintViewController.h"
#import "CarbonCalculator.h"

@interface FootprintViewController ()

@end

@implementation FootprintViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadOldData) name:@"loadOldFootprint" object: nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadData) name:@"loadFootprint" object: nil];
    [self showDataForMonth:3 andYear:2013];
}

- (void)loadData
{
    [self showDataForMonth:3 andYear:2013];
}

- (void)loadOldData
{
    [self showDataForMonth:2 andYear:2013];
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
    
    [_gasolinePrintLabel setText:[NSString stringWithFormat:@"You used %0.2f pounds of carbon from gasoline this month", [calculator getGasolinePrint]]];
    [_electricPrintLabel setText:[NSString stringWithFormat:@"You used %0.2f pounds of carbon from electricity this month", [calculator getElectricPrint]]];
    [_totalPrintLabel setText:[NSString stringWithFormat:@"Your carbon footprint this month was %0.2f pounds", [calculator getTotalPrint]]];
    
    [_averageGasolinePrintLabel setText:[NSString stringWithFormat:@"The average American uses %0.2f pounds of carbon from gasoline this month", [calculator getAverageGasolinePrint]]];
    [_averageElectricPrintLabel setText:[NSString stringWithFormat:@"The average American uses %0.2f pounds of carbon from electricity this month", [calculator getAverageElectricPrint]]];
    [_averageTotalPrintLabel setText:[NSString stringWithFormat:@"The average American carbon footprint is %0.2f pounds", [calculator getAverageTotalPrint]]];
    
    [_gasolineRatingLabel setText:[NSString stringWithFormat:@"%.0f/100", gasRating * 50]];
    [_electricRatingLabel setText:[NSString stringWithFormat:@"%.0f/100", electricRating * 50]];
    [_totalRatingLabel setText:[NSString stringWithFormat:@"%.0f/100", totalRating * 50]];
    
    [_offsetLabel setText:[NSString stringWithFormat:@"You saved %0.2f pounds of carbon this month from the trees you've planted!", [calculator getOffset]]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
