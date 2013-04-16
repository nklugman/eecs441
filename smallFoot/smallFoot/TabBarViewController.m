//
//  TabBarViewController.m
//  smallFoot
//
//  Created by Ben Perkins on 4/15/13.
//  Copyright (c) 2013 Klugman, Tsai & Perkins. All rights reserved.
//

#import "TabBarViewController.h"

@interface TabBarViewController ()

@end

@implementation TabBarViewController

bool hasLaunched = false;

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
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSLog(@"Facebook: %@ - News: %@ - Primary: %@", [defaults objectForKey:@"social_toggle"], [defaults objectForKey:@"news_toggle"], [defaults objectForKey:@"primary_tab"]);
    NSString *social = [[defaults objectForKey:@"social_toggle"] description];
    NSString *news = [[defaults objectForKey:@"news_toggle"] description];
    NSString *bt = [[defaults objectForKey:@"bt_toggle"] description];
    NSString *offset = [[defaults objectForKey:@"offset_toggle"] description];
    NSString *primary = [[defaults objectForKey:@"primary_tab"] description];
    
    
    NSMutableArray * vcs = [NSMutableArray
                            arrayWithArray:[self viewControllers]];
    
    if(news != nil && [news isEqualToString:@"0"]) [vcs removeObjectAtIndex:6];
    if(bt != nil && [bt isEqualToString:@"0"]) [vcs removeObjectAtIndex:5];
    if(social != nil && [social isEqualToString:@"0"]) [vcs removeObjectAtIndex:3];
    if(social != nil && [offset isEqualToString:@"0"]) [vcs removeObjectAtIndex:2];
    
    if(!hasLaunched)
    {
        if(primary != nil && [primary isEqualToString:@"2"]) [self setSelectedIndex:1];
        if(primary != nil && [primary isEqualToString:@"3"]) [self setSelectedIndex:4];
        hasLaunched = true;
    }
	
	[self setViewControllers:vcs];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
