//
//  RSSViewController.m
//  smallFoot
//
//  Created by Noah Klugman on 4/10/13.
//  Copyright (c) 2013 Klugman, Tsai & Perkins. All rights reserved.
//

#import "RSSViewController.h"
#import "RSSDetailViewController.h"

#import "RSSLoader.h"
#import "RSSItem.h"

@interface RSSViewController ()
{
    NSArray *_objects;
    NSURL* feedURL;
    UIRefreshControl* refreshControl;
}
@end

@implementation RSSViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    
    //configuration
    self.title = @"News";
    feedURL = [NSURL URLWithString:@"http://www.npr.org/rss/rss.php?id=1025"];
    
    //add refresh control to the table view
    refreshControl = [[UIRefreshControl alloc] init];
    
    [refreshControl addTarget:self
                       action:@selector(refreshInvoked:forState:)
             forControlEvents:UIControlEventValueChanged];
    
    NSString* fetchMessage = [NSString stringWithFormat:@"Fetching: %@",feedURL];
    
    refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:fetchMessage
                                                                     attributes:@{NSFontAttributeName:[UIFont fontWithName:@"Helvetica" size:11.0]}];
    
    [self.tableView addSubview: refreshControl];
    
    
    [self refreshFeed];
}

-(void) refreshInvoked:(id)sender forState:(UIControlState)state
{
    [self refreshFeed];
}

-(void)refreshFeed
{
    RSSLoader* rss = [[RSSLoader alloc] init];
    [rss fetchRssWithURL:feedURL
                complete:^(NSString *title, NSArray *results) {
                    
                    //completed fetching the RSS
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        //UI code on the main queue
                        //[(TableHeaderView*)self.tableView.tableHeaderView setText:title];
                        
                        _objects = results;
                        [self.tableView reloadData];
                        
                        // Stop refresh control
                        [refreshControl endRefreshing];
                    });
                }];
    
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _objects.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    RSSItem *object = _objects[indexPath.row];
    cell.textLabel.attributedText = object.cellMessage;
    cell.textLabel.numberOfLines = 0;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RSSItem *item = [_objects objectAtIndex:indexPath.row];
    CGRect cellMessageRect = [item.cellMessage boundingRectWithSize:CGSizeMake(200,10000)
                                                            options:NSStringDrawingUsesLineFragmentOrigin
                                                            context:nil];
    return cellMessageRect.size.height;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    //if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSLog(@"Test");

        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        RSSItem *object = _objects[indexPath.row];
        [[segue destinationViewController] setDetailItem:object];
    //}
}



@end