//
//  FootprintViewController.h
//  smallFoot
//
//  Created by Ben Perkins on 3/7/13.
//  Copyright (c) 2013 Klugman, Tsai & Perkins. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FootprintViewController : UITableViewController
@property (strong, nonatomic) IBOutlet UITableView *table;

@property (weak, nonatomic) IBOutlet UIProgressView *gasolineProgressBar;
@property (weak, nonatomic) IBOutlet UIProgressView *electricProgressBar;
@property (weak, nonatomic) IBOutlet UIProgressView *totalProgressBar;

@property (weak, nonatomic) IBOutlet UILabel *gasolinePrintLabel;
@property (weak, nonatomic) IBOutlet UILabel *electricPrintLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalPrintLabel;

@property (weak, nonatomic) IBOutlet UILabel *averageGasolinePrintLabel;
@property (weak, nonatomic) IBOutlet UILabel *averageElectricPrintLabel;
@property (weak, nonatomic) IBOutlet UILabel *averageTotalPrintLabel;

@property (weak, nonatomic) IBOutlet UILabel *gasolineRatingLabel;
@property (weak, nonatomic) IBOutlet UILabel *electricRatingLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalRatingLabel;

@property (weak, nonatomic) IBOutlet UILabel *offsetLabel;

@property (weak, nonatomic) IBOutlet UIButton *graphButton;


- (void)loadData;
- (void)loadOldData;
- (void)showDataForMonth: (int)month andYear: (int)year;
- (IBAction)graphButtonPressed:(id)sender;
- (UIColor*)getColorForRating: (float)rating;
@end
