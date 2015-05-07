//
//  MyDetailsDisplayViewController.m
//  GurlsNightOut
//
//  Created by calvin on 3/05/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MyDetailsDisplayViewController.h"
#import "MyDetailsCell.h"
#import "LeaderboardCell.h"

//@interface MyDetailsDisplayViewController ()
//
//@end

@implementation MyDetailsDisplayViewController
@synthesize btPhoto;
 
- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO];
}
- (void)viewDidLoad
{
    [super viewDidLoad];

    appDelegate = [[UIApplication sharedApplication] delegate];
    [appDelegate initMyDetailsManager];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidUnload
{
    [self setBtPhoto:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if (section==0) {
        return [[[appDelegate myDetailsManager] userInfoDic] count];
    }
    else if(section==1)
    {
        return 1;
    }
    else if(section==2)
    {
        return 1;
    }
    else if(section==3)
    {
        
    }
    else if(section==4)
    {
        
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    static NSString *CellIdentifierFriends = @"CellFriends";
    static NSString *CellIdentifierLeaderboard = @"CellLeaderboard";

    
    // Configure the cell...
    if ([indexPath section]==0) {
        MyDetailsCell *cellMyDetails = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        cellMyDetails.lbTitle.text=[[[[appDelegate myDetailsManager] userInfoDic] allKeys] objectAtIndex:[indexPath row]];
        cellMyDetails.tfInput.text=[NSString stringWithFormat:@"%@",[[[appDelegate myDetailsManager] userInfoDic] objectForKey:[[[[appDelegate myDetailsManager] userInfoDic] allKeys] objectAtIndex:[indexPath row]]]];
        UIImage *img;
        if ([[[[appDelegate myDetailsManager] isShareDic] objectForKey:[[[[appDelegate myDetailsManager] userInfoDic] allKeys] objectAtIndex:[indexPath row]]] boolValue]) {
            img=[UIImage imageNamed:@"tick.png"];
        }
        else {
            img=[UIImage imageNamed:@"cross.png"];
        }
        cellMyDetails.ivShare.image=img;    
        return cellMyDetails;
    }
    else if([indexPath section]==1)
    {
        LeaderboardCell *cellLeaderboard = [tableView dequeueReusableCellWithIdentifier:CellIdentifierLeaderboard];
        cellLeaderboard.lbFirst.text=[NSString stringWithFormat:@"#1 Alice"];
        cellLeaderboard.lbSecond.text=[NSString stringWithFormat:@"#2 Queenie"];
        cellLeaderboard.lbThird.text=[NSString stringWithFormat:@"#3 Alice"];
        
        cellLeaderboard.lbFirstPoint.text=[NSString stringWithFormat:@"6435"];
        cellLeaderboard.lbSecondPoint.text=[NSString stringWithFormat:@"4678"];
        cellLeaderboard.lbThirdPoint.text=[NSString stringWithFormat:@"2467"];
        return cellLeaderboard;
    }
    else if([indexPath section]==2)
    {
        UITableViewCell *cellFriends = [tableView dequeueReusableCellWithIdentifier:CellIdentifierFriends];
        cellFriends.textLabel.text=@"Manage Friends";
        return cellFriends;
    }
    else if([indexPath section]==3)
    {
        
    }
    else if([indexPath section]==4)
    {
        
    }
    
    return nil;
}

- (NSString* ) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *titleSection;
    if (section==0) {
        titleSection=[NSString stringWithFormat:@"My details"];
    }
    else if (section==1) {
        titleSection=[NSString stringWithFormat:@"Leaderboard"];
    }
    else if (section==2) {
        titleSection=[NSString stringWithFormat:@"My friends"];
    }
    else if (section==3) {
        titleSection=[NSString stringWithFormat:@"Faverite drinks"];
    }
    else if (section==4) {
        titleSection=[NSString stringWithFormat:@"Faverite places"];
    }
    
    return titleSection;
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
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
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
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([indexPath section]==1) {
        return 98;
    }
    return 44;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([indexPath section]==0) {
        if ([[[[appDelegate myDetailsManager] isShareDic] objectForKey:[[[[appDelegate myDetailsManager] userInfoDic] allKeys] objectAtIndex:[indexPath row]]] boolValue]) {
            [[appDelegate myDetailsManager] changeIsShareDicInFile:[NSString stringWithFormat:@"0"] KeyInDic:[[[[appDelegate myDetailsManager] userInfoDic] allKeys] objectAtIndex:[indexPath row]]];
        }
        else {
            [[appDelegate myDetailsManager] changeIsShareDicInFile:[NSString stringWithFormat:@"1"] KeyInDic:[[[[appDelegate myDetailsManager] userInfoDic] allKeys] objectAtIndex:[indexPath row]]];
        }
        [[appDelegate myDetailsManager] initShareDic];
        
        [self.tableView reloadData];
    }
}

- (IBAction)btPhotoAction:(id)sender {
}
@end
