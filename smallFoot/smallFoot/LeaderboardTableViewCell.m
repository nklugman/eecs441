//
//  LeaderboardTableViewCell.m
//  smallFoot
//
//  Created by w on 4/15/13.
//  Copyright (c) 2013 Klugman, Tsai & Perkins. All rights reserved.
//

#import "LeaderboardTableViewCell.h"

@implementation LeaderboardTableViewCell

@synthesize name;
@synthesize footprintTotal;
@synthesize profPic;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
