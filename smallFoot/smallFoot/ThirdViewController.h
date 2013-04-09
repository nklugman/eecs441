//
//  ThirdViewController.h
//  smallFoot
//
//  Created by Ben Perkins on 3/18/13.
//  Copyright (c) 2013 Klugman, Tsai & Perkins. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ThirdViewController : UIViewController <UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (weak, nonatomic) IBOutlet UIWebView *webView;
- (IBAction)recommendPressed:(id)sender;

@end
