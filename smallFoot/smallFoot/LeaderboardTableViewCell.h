//
//  LeaderboardTableViewCell.h
//  smallFoot
//
//  Created by w on 4/15/13.
//  Copyright (c) 2013 Klugman, Tsai & Perkins. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>

@interface LeaderboardTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *footprintTotal;
@property (weak, nonatomic) IBOutlet UILabel *achievementsLabel;
@property (weak, nonatomic) IBOutlet UILabel *rankLabel;
@property (weak, nonatomic) IBOutlet FBProfilePictureView *profPic;

@end
