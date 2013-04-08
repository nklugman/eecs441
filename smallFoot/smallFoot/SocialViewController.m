//
//  SocialViewController.m
//  smallFoot
//
//  Created by Ben Perkins on 4/5/13.
//  Copyright (c) 2013 Klugman, Tsai & Perkins. All rights reserved.
//

#import "SocialViewController.h"
#import "SFOGProtocols.h"
#import "CarbonCalculator.h"

@interface SocialViewController ()

@end

@implementation SocialViewController

@synthesize loginView;
@synthesize profilePic;
@synthesize nameLabel;

@synthesize footprintTotal;
@synthesize footprintTotalLabel;
@synthesize footprintDescriptionLabel;
@synthesize publishButton;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        loginView.publishPermissions = @[@"publish_actions"];
        loginView.defaultAudience = FBSessionDefaultAudienceOnlyMe;
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self showCurrentTotals];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - FBLoginViewDelegate Methods

- (void)loginViewShowingLoggedInUser:(FBLoginView *)loginView {
    NSLog(@"user is logged in");
    
    self.publishButton.hidden = NO;
}

- (void)loginViewShowingLoggedOutUser:(FBLoginView *)loginView {
    self.profilePic.profileID = nil;
    self.nameLabel.text = @"";
    
    self.publishButton.hidden = YES;
}

- (void)loginViewFetchedUserInfo:(FBLoginView *)loginView
                            user:(id<FBGraphUser>)user {
    NSLog(@"fetched user info");
    
    self.profilePic.profileID = user.id;
    self.nameLabel.text = [NSString stringWithFormat:
                                @"Welcome, %@", user.first_name];
    
    self.publishButton.hidden = NO;
    
    NSLog(@"Facebook id is: %@", user.id);
    NSLog(@"Facebook access token: %@", [[[FBSession activeSession] accessTokenData] accessToken]);
    
    
}

- (void)loginView:(FBLoginView *)loginView
      handleError:(NSError *)error {
    NSString *alertMessage, *alertTitle;
    if (error.fberrorShouldNotifyUser) {
        // If the SDK has a message for the user, surface it. This conveniently
        // handles cases like password change or iOS6 app slider state.
        alertTitle = @"Facebook Error";
        alertMessage = error.fberrorUserMessage;
    } else if (error.fberrorCategory == FBErrorCategoryAuthenticationReopenSession) {
        // It is important to handle session closures since they can happen
        // outside of the app. You can inspect the error for more context
        // but this sample generically notifies the user.
        alertTitle = @"Session Error";
        alertMessage = @"Your current session is no longer valid. Please log in again.";
    } else if (error.fberrorCategory == FBErrorCategoryUserCancelled) {
        // The user has cancelled a login. You can inspect the error
        // for more context. For this sample, we will simply ignore it.
        NSLog(@"user cancelled login");
    } else {
        // For simplicity, this sample treats other errors blindly.
        alertTitle  = @"Unknown Error";
        alertMessage = @"Error. Please try again later.";
        NSLog(@"Unexpected error:%@", error);
    }
    
    if (alertMessage) {
        [[[UIAlertView alloc] initWithTitle:alertTitle
                                    message:alertMessage
                                   delegate:nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil] show];
    }
}

- (void)fbDidLogin {
    // caching for re-initializing access tokens
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[[[FBSession activeSession] accessTokenData] accessToken] forKey:@"FBAccessTokenKey"];
    [defaults setObject:[[[FBSession activeSession] accessTokenData] expirationDate] forKey:@"FBExpirationDateKey"];
    [defaults synchronize];
}

/*
- (void)sessionStateChanged:(NSNotification*)notification {
    if (FBSession.activeSession.isOpen) {
        self.publishButton.hidden = NO;
        [self.authButton setTitle:@"Logout" forState:UIControlStateNormal];
    } else {
        self.publishButton.hidden = YES;
        [self.authButton setTitle:@"Login" forState:UIControlStateNormal];
    }
}
 */

#pragma mark - UIAlertViewDelegate Methods

- (void) alertView:(UIAlertView *)alertView
didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    [[self presentingViewController]
     dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - SocialViewController Methods

- (id<SFOGFootprint>)footprintObjectForFootprint:(NSString*)footprint
{
    // This URL is specific to this sample, and can be used to
    // create arbitrary OG objects for this app; your OG objects
    // will have URLs hosted by your server.
    bool smallfoot = NO;
    
    NSString *format =
    @"https://sleepy-basin-4726.herokuapp.com/footprint.php?"
    @"fb:app_id=158795857619338&og:type=%@&"
    @"og:title=%@&og:description=%%22%@%%22&"
    @"og:image=%@&"
    @"body=%@";
   
    NSString *object_type = @"ktp_smallfoot:carbon_footprint";
    NSString *img = [NSString stringWithFormat:@"http://sleepy-basin-4726.herokuapp.com/images/%@", smallfoot?@"greenfootprint.png":@"redfootprint.png"];

    id<SFOGFootprint> result = (id<SFOGFootprint>)[FBGraphObject graphObject];
    result.url = [NSString stringWithFormat:format,
                  object_type, footprint, footprint, img, footprint];
    return result;
}

- (void)publishStory
{
    
    id<SFOGFootprint> footprintObject = [self footprintObjectForFootprint:footprintTotal];
    
    NSLog(@"url: %@", footprintObject.url);
     
    // Now create an Open Graph eat action with the meal, our location,
    // and the people we were with.
    id<SFOGRecordFootprintAction> action =
    (id<SFOGRecordFootprintAction>)[FBGraphObject graphObject];
    action.carbon_footprint = footprintObject;

    [FBSettings setLoggingBehavior:[NSSet
                                    setWithObjects:FBLoggingBehaviorFBRequests,
                                    FBLoggingBehaviorFBURLConnections,
                                    nil]];
    
    [FBRequestConnection startForPostWithGraphPath:@"me/ktp_smallfoot:record"
                                       graphObject:action
                                 completionHandler:
     ^(FBRequestConnection *connection, id result, NSError *error) {
         NSString *alertText;
         if (!error) {
             alertText = [NSString stringWithFormat:
                          @"Posted Open Graph action, id: %@",
                          [result objectForKey:@"id"]];
         } else {
             alertText = [NSString stringWithFormat:
                          @"error: domain = %@, code = %d",
                          error.domain, error.code];
             
             NSLog(@"Entire error message: %@", error);
         }
         [[[UIAlertView alloc] initWithTitle:@"Result"
                                     message:alertText
                                    delegate:nil
                           cancelButtonTitle:@"Thanks!"
                           otherButtonTitles:nil]
          show];
     }
     ];

     
}

- (IBAction)publishButtonPressed:(id)sender
{
    // Ask for publish_actions permissions in context
    if ([FBSession.activeSession.permissions
         indexOfObject:@"publish_actions"] == NSNotFound) {
        // No permissions found in session, ask for it
        [FBSession.activeSession
         requestNewPublishPermissions:
         [NSArray arrayWithObject:@"publish_actions"]
         defaultAudience:FBSessionDefaultAudienceOnlyMe
         completionHandler:^(FBSession *session, NSError *error) {
             if (!error) {
                 // If permissions granted, publish the story
                 [self publishStory];
             }
         }];
    } else {
        // If permissions present, publish the story
        [self publishStory];
    }
}

- (void)showCurrentTotals
{
    NSDate           *today           = [NSDate date];
    NSCalendar       *currentCalendar = [NSCalendar currentCalendar];
    
    NSDateComponents *monthComponents = [currentCalendar components:NSMonthCalendarUnit fromDate:today];
    int currentMonth = [monthComponents month];
    
    NSDateComponents *yearComponents  = [currentCalendar components:NSYearCalendarUnit  fromDate:today];
    int currentYear  = [yearComponents year];
    [self showTotalsForMonth:currentMonth andYear:currentYear];
}

- (void)showTotalsForMonth:(int)month andYear:(int)year
{
    CarbonCalculator *calculator = [[CarbonCalculator alloc] init];
    [calculator calculateForMonth:month andYear:year];
    
    [footprintDescriptionLabel setText:[NSString stringWithFormat:@"Your carbon footprint for %d/%d", month, year]];

    footprintTotal = [NSString stringWithFormat:@"%0.2f pounds of carbon", [calculator getTotalPrint]];
    [footprintTotalLabel setText:footprintTotal];
    [footprintTotalLabel sizeToFit];
    
}



@end
