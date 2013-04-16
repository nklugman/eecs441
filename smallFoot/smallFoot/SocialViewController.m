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
#import "LeaderboardTableViewCell.h"

static NSString *CellIdentifier = @"LeaderboardTableItem";

static NSString *loggedOutMsg = @"Login to Facebook to compete with friends!";
static NSString *loggedInMsg = @"%@ (Rank %@ out of %d)";

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

@synthesize leaderboardTableView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        loginView.publishPermissions = @[@"publish_actions"];
        loginView.defaultAudience = FBSessionDefaultAudienceOnlyMe;
        
        fptotal = 0;
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    [[UITableViewHeaderFooterView appearance] setTintColor:[UIColor darkGrayColor]];
    
    tableData = [NSMutableArray arrayWithObjects:[NSDictionary dictionaryWithObjectsAndKeys:@"Noah Klugman", @"name", [NSNumber numberWithFloat:1500.00], @"footprintTotal", @"1232310304", @"fid", nil], [NSDictionary dictionaryWithObjectsAndKeys:@"Ben Perkins", @"name", [NSNumber numberWithFloat:2500.00], @"footprintTotal", @"605156012", @"fid", nil], nil];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self showCurrentTotals];
    
    
    
    [leaderboardTableView reloadData];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - FBLoginViewDelegate Methods

- (void)loginViewShowingLoggedInUser:(FBLoginView *)loginView {
    NSLog(@"user is logged in");
    
    self.publishButton.enabled = YES;
    
    [self checkSessionDefaultAppID];
}

- (void)loginViewShowingLoggedOutUser:(FBLoginView *)loginView {
    self.profilePic.profileID = nil;
    self.nameLabel.text = loggedOutMsg;
    
    self.publishButton.enabled = NO;
}

- (void)loginViewFetchedUserInfo:(FBLoginView *)loginView
                            user:(id<FBGraphUser>)user {
    NSLog(@"fetched user info");
    [self checkSessionDefaultAppID];
    
    userData = user;
    
    int rank = -1;
    if(fptotal != 0) {
        if(fptotal < 1500) rank = 1;
        else if(fptotal < 2500) rank = 2;
        else rank = 3;
    }
    NSString *rankStr;
    if(rank == -1) rankStr = @"NA";
    else rankStr = [NSString stringWithFormat:@"%d", rank];
    
    self.profilePic.profileID = user.id;
    self.nameLabel.text = [NSString stringWithFormat:loggedInMsg, user.name, rankStr, [tableData count]+1];
    
    self.publishButton.enabled = YES;
    
    
    /*
    NSLog(@"Facebook id is: %@", user.id);
    NSLog(@"Facebook access token: %@", [[[FBSession activeSession] accessTokenData] accessToken]);
    */
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
             /*
             alertText = [NSString stringWithFormat:
                          @"Posted Open Graph action, id: %@",
                          [result objectForKey:@"id"]];
            */
            alertText = [NSString stringWithFormat:@"Successfully published your carbon footprint of %0.2f lbs", fptotal];
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

- (IBAction)refreshButtonPressed:(id)sender {
    [self showCurrentTotals];
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

    fptotal = [calculator getTotalPrint];
    footprintTotal = [NSString stringWithFormat:@"%0.2f pounds of carbon", fptotal];
    [footprintTotalLabel setText:footprintTotal];
    
    
    [_busLabel setText:[NSString stringWithFormat:@"No award - 0.00 miles"]];
    [_smallfootLabel setText:[NSString stringWithFormat:@"No award - 0.00 miles"]];
    
    if([calculator getBikeAward] == 1){
        [_bikeAward setImage:[UIImage imageNamed:@"award_bike_bronze.png"]];
        [_bikeLabel setText:[NSString stringWithFormat:@"Bronze - %0.2f miles", [calculator getBikeMiles]]];
    }else if([calculator getBikeAward] == 2){
        [_bikeAward setImage:[UIImage imageNamed:@"award_bike_silver.png"]];
        [_bikeLabel setText:[NSString stringWithFormat:@"Silver - %0.2f miles", [calculator getBikeMiles]]];
    }else if([calculator getBikeAward] == 3){
        [_bikeAward setImage:[UIImage imageNamed:@"award_bike_gold.png"]];
        [_bikeLabel setText:[NSString stringWithFormat:@"Gold - %0.2f miles", [calculator getBikeMiles]]];
    }else{
        [_bikeAward setImage:[UIImage imageNamed:@"award_bike_empty.png"]];
        [_bikeLabel setText:[NSString stringWithFormat:@"No award - %0.2f miles", [calculator getBikeMiles]]];
    }
    
    if([calculator getBusAward] == 1){
        [_busAward setImage:[UIImage imageNamed:@"award_bus_bronze.png"]];
        [_busLabel setText:[NSString stringWithFormat:@"Bronze - %0.2f miles", [calculator getBusMiles]]];
    }else if([calculator getBusAward] == 2){
        [_busAward setImage:[UIImage imageNamed:@"award_bus_silver.png"]];
        [_busLabel setText:[NSString stringWithFormat:@"Silver - %0.2f miles", [calculator getBusMiles]]];
    }else if([calculator getBusAward] == 3){
        [_busAward setImage:[UIImage imageNamed:@"award_bus_gold.png"]];
        [_busLabel setText:[NSString stringWithFormat:@"Gold - %0.2f miles", [calculator getBusMiles]]];
    }else{
        [_busAward setImage:[UIImage imageNamed:@"award_bus_empty.png"]];
        [_busLabel setText:[NSString stringWithFormat:@"No award - %0.2f miles", [calculator getBusMiles]]];
    }
    
    if([calculator getFootprintAward] == 1){
        [_smallfootAward setImage:[UIImage imageNamed:@"award_leaf_bronze.png"]];
        [_smallfootLabel setText:[NSString stringWithFormat:@"Bronze - %0.2f pounds", [calculator getTotalPrint]]];
    }else if([calculator getFootprintAward] == 2){
        [_smallfootAward setImage:[UIImage imageNamed:@"award_leaf_silver.png"]];
        [_smallfootLabel setText:[NSString stringWithFormat:@"Silver - %0.2f pounds", [calculator getTotalPrint]]];
    }else if([calculator getFootprintAward] == 3){
        [_smallfootAward setImage:[UIImage imageNamed:@"award_leaf_gold.png"]];
        [_smallfootLabel setText:[NSString stringWithFormat:@"Gold - %0.2f pounds", [calculator getTotalPrint]]];
    }else{
        [_smallfootAward setImage:[UIImage imageNamed:@"award_leaf_empty.png"]];
        [_smallfootLabel setText:[NSString stringWithFormat:@"No award - %0.2f pounds", [calculator getTotalPrint]]];
    }
    
}

- (void)checkSessionDefaultAppID
{
    if (![FBSession defaultAppID]) {
        NSLog(@"Need to set defaultAppID");
        [FBSession setDefaultAppID:@"158795857619338"];
    }
    else {
        NSLog(@"FBSession defaultAppID: %@", [FBSession defaultAppID]);
    }
}


#pragma mark - UITableViewDelegate and DataSource Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [tableData count];
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LeaderboardTableViewCell *cell = (LeaderboardTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if(cell == nil) {
        cell = [[LeaderboardTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // Configure Cell    
    [cell.name setText:[[tableData objectAtIndex:[indexPath row]] objectForKey:@"name"]];
    [cell.footprintTotal setText:[NSString stringWithFormat:@"%@", [[tableData objectAtIndex:[indexPath row]] objectForKey:@"footprintTotal"]]];
    [cell.rankLabel setText:[NSString stringWithFormat:@"%d", [indexPath row]+1]];
    
    cell.profPic.profileID = [[tableData objectAtIndex:[indexPath row]] objectForKey:@"fid"];
    
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if(section == 0) {
        return @"Leaderboard for April";
    }
    else {
        return @"";
    }
}

@end
