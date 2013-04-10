//
//  RSSDetailViewController.h
//  smallFoot
//
//  Created by Noah Klugman on 4/10/13.
//  Copyright (c) 2013 Klugman, Tsai & Perkins. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RSSDetailViewController : UIViewController

@property (strong, nonatomic) id detailItem;

@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;
@end
