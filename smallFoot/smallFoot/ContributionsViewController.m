//
//  ContributionsViewController.m
//  smallFoot
//
//  Created by Ben Perkins on 3/7/13.
//  Copyright (c) 2013 Klugman, Tsai & Perkins. All rights reserved.
//

#import "ContributionsViewController.h"

@interface ContributionsViewController ()

@end

@implementation ContributionsViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self populateDictionaries];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadTable) name:@"reloadContributionsTable" object: nil];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)reloadTable
{
    [self populateDictionaries];
    [_contributionsTableView reloadData];
}

- (void)populateDictionaries
{
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *gasPath = [path stringByAppendingPathComponent:@"gasLog.plist"];
    NSString *electricPath = [path stringByAppendingPathComponent:@"electricLog.plist"];
    NSString *offsetPath = [path stringByAppendingPathComponent:@"offsetLog.plist"];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if (![fileManager fileExistsAtPath:gasPath])
    {
        NSLog(@"Gas file does not exist");
    }
    if (![fileManager fileExistsAtPath:electricPath])
    {
        NSLog(@"Electric file does not exist");
    }
    if (![fileManager fileExistsAtPath:offsetPath])
    {
        NSLog(@"Offset file does not exist");
    }
    
    // Read plist files to NSMutableDictionaries
    gasLog = [[NSMutableDictionary alloc] initWithContentsOfFile:gasPath];
    electricLog = [[NSMutableDictionary alloc] initWithContentsOfFile:electricPath];
    offsetLog = [[NSMutableDictionary alloc] initWithContentsOfFile:offsetPath];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	if(section == 0 && [[gasLog objectForKey:@"gallons"] count] > 0) return [[gasLog objectForKey:@"gallons"] count];
    else if(section == 1 && [[electricLog objectForKey:@"kwh"] count] > 0) return [[electricLog objectForKey:@"kwh"] count];
    else if(section == 2 && [[offsetLog objectForKey:@"count"] count] > 0) return [[offsetLog objectForKey:@"count"] count];
    
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *CellIdentifier = @"Cell";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"Cell"];
        
        // Uncomment this line to add the blue arrow for editing these. It's hidden because there's no code to edit them right now
        //[cell setAccessoryType:UITableViewCellAccessoryDetailDisclosureButton];
	}
    
    if(indexPath.section == 0)
    {
        if([[gasLog objectForKey:@"gallons"] count] == 0)
        {
            cell.textLabel.text = @"";
            cell.detailTextLabel.text = @"None";
        }
        else
        {
            NSDateFormatter *format = [[NSDateFormatter alloc] init];
            //[format setDateFormat:@"EEEE MMMM d, yyyy 'at' h:mma"]; // Includes "at *time*
            [format setDateFormat:@"EEEE MMMM d, yyyy"]; // Just the date
            NSDate *date = [[gasLog objectForKey:@"date"] objectAtIndex:indexPath.row];
            NSString *formattedDate = [format stringFromDate:date];
            cell.textLabel.text = [NSString stringWithFormat:@"Gas: %.2f gallons", [[[gasLog objectForKey:@"gallons"] objectAtIndex:indexPath.row] doubleValue]];
            cell.detailTextLabel.text = formattedDate;
        }
    }
    else if(indexPath.section == 1)
    {
        if([[electricLog objectForKey:@"kwh"] count] == 0)
        {
            cell.textLabel.text = @"";
            cell.detailTextLabel.text = @"None";
        }
        else
        {
            NSDateFormatter *format = [[NSDateFormatter alloc] init];
            [format setDateFormat:@"MMMM, yyyy"];
            NSDate *date = [[electricLog objectForKey:@"date"] objectAtIndex:indexPath.row];
            NSString *formattedDate = [format stringFromDate:date];
            cell.textLabel.text = [NSString stringWithFormat:@"Electricity: %.4f kWh", [[[electricLog objectForKey:@"kwh"] objectAtIndex:indexPath.row] doubleValue]];
            cell.detailTextLabel.text = formattedDate;
        }
    }
    else if(indexPath.section == 2)
    {
        if([[offsetLog objectForKey:@"count"] count] == 0)
        {
            cell.textLabel.text = @"";
            cell.detailTextLabel.text = @"None";
        }
        else
        {
            NSDateFormatter *format = [[NSDateFormatter alloc] init];
            [format setDateFormat:@"EEEE MMMM d, yyyy 'at' h:mma"];
            NSDate *date = [[offsetLog objectForKey:@"date"] objectAtIndex:indexPath.row];
            NSString *formattedDate = [format stringFromDate:date];
            cell.textLabel.text = [NSString stringWithFormat:@"Offset: %d trees", [[[offsetLog objectForKey:@"count"] objectAtIndex:indexPath.row] intValue]];
            cell.detailTextLabel.text = formattedDate;
        }
    }
    
	return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return YES if you want the specified item to be editable.
    if(indexPath.section == 0)
    {
        return [[gasLog objectForKey:@"date"] count] > 0;
    }
    else if(indexPath.section == 1)
    {
        return [[electricLog objectForKey:@"date"] count] > 0;
    }
    else if(indexPath.section == 2)
    {
        return [[offsetLog objectForKey:@"date"] count] > 0;
    }
    return YES;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        if(indexPath.section == 0)
        {
            NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
            path = [path stringByAppendingPathComponent:@"gasLog.plist"];
            [[gasLog objectForKey:@"gallons"] removeObjectAtIndex:indexPath.row];
            [[gasLog objectForKey:@"type"] removeObjectAtIndex:indexPath.row];
            [[gasLog objectForKey:@"date"] removeObjectAtIndex:indexPath.row];
            [gasLog writeToFile:path atomically:YES];
            [self reloadTable];
        }
        else if(indexPath.section == 1)
        {
            NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
            path = [path stringByAppendingPathComponent:@"electricLog.plist"];
            [[electricLog objectForKey:@"kwh"] removeObjectAtIndex:indexPath.row];
            [[electricLog objectForKey:@"type"] removeObjectAtIndex:indexPath.row];
            [[electricLog objectForKey:@"date"] removeObjectAtIndex:indexPath.row];
            [electricLog writeToFile:path atomically:YES];
            [self reloadTable];
        }
        else if(indexPath.section == 2)
        {
            NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
            path = [path stringByAppendingPathComponent:@"offsetLog.plist"];
            [[offsetLog objectForKey:@"count"] removeObjectAtIndex:indexPath.row];
            [[offsetLog objectForKey:@"date"] removeObjectAtIndex:indexPath.row];
            [offsetLog writeToFile:path atomically:YES];
            [self reloadTable];
        }
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    
    if(section == 0) return @"Gasoline";
    else if(section == 1) return @"Electricty";
    else if(section == 2) return @"Offset";
    
    return @"";
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

@end
