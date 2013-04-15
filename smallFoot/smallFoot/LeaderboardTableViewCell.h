//
//  LeaderboardTableViewCell.h
//  smallFoot
//
//  Created by w on 4/15/13.
//  Copyright (c) 2013 Klugman, Tsai & Perkins. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LeaderboardTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *footprintTotal;
@property (weak, nonatomic) IBOutlet UIImageView *profPic;

@end
