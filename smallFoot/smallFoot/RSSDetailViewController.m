//
//  RSSDetailViewController.m
//  smallFoot
//
//  Created by Noah Klugman on 4/10/13.
//  Copyright (c) 2013 Klugman, Tsai & Perkins. All rights reserved.
//


#import "RSSDetailViewController.h"
#import "RSSItem.h"

@interface RSSDetailViewController () <UIWebViewDelegate>
{
    IBOutlet UIWebView* webView;
}
@end

@implementation RSSDetailViewController

-(void)viewDidAppear:(BOOL)animated
{
    RSSItem* item = (RSSItem*)self.detailItem;
    self.title = item.title;
    webView.delegate = self;
    NSURLRequest* articleRequest = [NSURLRequest requestWithURL: item.link];
    webView.backgroundColor = [UIColor clearColor];
    [webView loadRequest: articleRequest];
}

-(void)viewDidDisappear:(BOOL)animated
{
    webView.delegate = nil;
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
}

@end