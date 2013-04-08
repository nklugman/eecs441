//
//  SocialViewController.h
//  smallFoot
//
//  Created by Ben Perkins on 4/5/13.
//  Copyright (c) 2013 Klugman, Tsai & Perkins. All rights reserved.
//

#import <FacebookSDK/FacebookSDK.h>
#import <UIKit/UIKit.h>

@interface SocialViewController : UIViewController<FBLoginViewDelegate>

@property (weak, nonatomic) IBOutlet FBLoginView *loginView;
@property (unsafe_unretained, nonatomic) IBOutlet FBProfilePictureView *profilePic;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *footprintTotalLabel;
@property (weak, nonatomic) IBOutlet UIButton * publishButton;

-(IBAction)publishButtonPressed:(id)sender;

@end
