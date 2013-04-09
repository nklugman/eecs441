//
//  ThirdViewController.m
//  smallFoot
//
//  Created by Ben Perkins on 3/18/13.
//  Copyright (c) 2013 Klugman, Tsai & Perkins. All rights reserved.
//

#import "ThirdViewController.h"
#import "CarbonCalculator.h"

@interface ThirdViewController ()

@end

int loadCount;

@implementation ThirdViewController

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
    _activityIndicator.hidesWhenStopped = YES;
    loadCount = 0;
    _recommendedAmount.enabled = NO;
    [_webView setDelegate:self];
    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"https://support.nature.org/site/Donation2?df_id=3901&3901.donation=form1"]]];
	// Do any additional setup after loading the view.
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
    loadCount++;
    [_activityIndicator startAnimating];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    loadCount--;
    //NSLog(@"Loaded a page");
    //if(loadCount > 0) return;
    [_activityIndicator stopAnimating];
    _recommendedAmount.enabled = YES;
    NSLog(@"Done loading!");
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)recommendPressed:(id)sender {
    NSDate           *today           = [NSDate date];
    NSCalendar       *currentCalendar = [NSCalendar currentCalendar];
    
    NSDateComponents *monthComponents = [currentCalendar components:NSMonthCalendarUnit fromDate:today];
    int currentMonth = [monthComponents month];
    
    NSDateComponents *yearComponents  = [currentCalendar components:NSYearCalendarUnit  fromDate:today];
    int currentYear  = [yearComponents year];
    
    CarbonCalculator *calculator = [[CarbonCalculator alloc] init];;
    [calculator calculateForMonth:(currentMonth-1) andYear:currentYear];
    
    float tons = [calculator getTotalPrint];
    float cost;
    NSLog(@"%0.2f", tons);
    tons = tons / 2204.62; // Total pounds / (2204.62lbs / 1 MT) * $15/MT
    cost = tons * 15;
    
    NSLog(@"%0.2f", cost);
    
    UIAlertView *errorAlert = [[UIAlertView alloc]initWithTitle:[NSString stringWithFormat:@"Based on your carbon usage of %0.2f Metic Tons last month, we recommend a donation of $%0.2f", tons, cost]
                                                         message:nil
                                                        delegate:nil
                                               cancelButtonTitle:@"OK"
                                               otherButtonTitles:nil];
    [errorAlert show];
    [_webView stringByEvaluatingJavaScriptFromString:@"document.getElementById('level_standardcompact10043').setAttribute('checked');"];
    [_webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat: @"document.getElementById('level_standardcompact10043amount').value = %0.2f;", cost]];
}
@end
