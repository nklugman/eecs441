//
//  ContributionsViewController.h
//  smallFoot
//
//  Created by Ben Perkins on 3/7/13.
//  Copyright (c) 2013 Klugman, Tsai & Perkins. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ContributionsViewController : UITableViewController
{
    NSMutableDictionary *gasLog;
    NSMutableDictionary *electricLog;
    NSMutableDictionary *offsetLog;
}
@property (strong, nonatomic) IBOutlet UITableView *contributionsTableView;

- (void)populateDictionaries;
- (void)reloadTable;

@end
