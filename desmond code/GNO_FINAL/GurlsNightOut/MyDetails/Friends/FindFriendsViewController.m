//
//  FindFriendsViewController.m
//  gno
//
//  Created by Calvin on 31/08/12.
//
//

#import "FindFriendsViewController.h"
#import "FindFriendDetailsViewController.h"

@interface FindFriendsViewController ()

@end

@implementation FindFriendsViewController
@synthesize mySearchBarController;

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
    data4SearchingTableView=[[NSMutableArray alloc] init];
//    data4TableView=[[NSMutableArray alloc] init];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidUnload
{
    [self setMySearchBarController:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    // Return the number of rows in the section.
//    if ([tableView isEqual:self.mySearchBarController.searchResultsTableView]) {
        return [data4SearchingTableView count];
//    }
//    else {
//        return [data4TableView count];
//    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell==nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    // Configure the cell...
    cell.textLabel.text=[NSString stringWithFormat:@"%@",[[data4SearchingTableView objectAtIndex:[indexPath row]] objectForKey:@"userName"]];
    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;

    return cell;
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
    FindFriendDetailsViewController *findFriendDetailsViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"FindFriendDetailsViewController"];
    findFriendDetailsViewController.friendName=[NSString stringWithFormat:@"%@",[[data4SearchingTableView objectAtIndex:[indexPath row]] objectForKey:@"userName"]];
    findFriendDetailsViewController.friendUserDBID=[NSString stringWithFormat:@"%@",[[data4SearchingTableView objectAtIndex:[indexPath row]] objectForKey:@"userDBID"]];
    findFriendDetailsViewController.friendPhotoDBID=[NSString stringWithFormat:@"%@",[[data4SearchingTableView objectAtIndex:[indexPath row]] objectForKey:@"photosDBID"]];
    findFriendDetailsViewController.friendDic=[[NSMutableDictionary alloc] initWithDictionary:[data4SearchingTableView objectAtIndex:[indexPath row]]];
    [self.navigationController pushViewController:findFriendDetailsViewController animated:YES];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

#pragma mark - searchBar controller delegate
//- (void) searchBarTextDidBeginEditing:(UISearchBar *)theSearchBar {
//    searching=YES;
//}
//
//- (void) searchBarSearchButtonClicked:(UISearchBar *)theSearchBar {
//
//}
//- (void) searchBarCancelButtonClicked:(UISearchBar *)searchBar{
//    searching=NO;
//}

- (void)searchBar:(UISearchBar *)theSearchBar textDidChange:(NSString *)searchText {
    NSLog(@"searchBar2");
    
    if ([searchText length]!=0) {
        Kumulos *k=[[Kumulos alloc] init];
        [k setDelegate:self];
        [k getFriendByNameWithUserName:searchText];
    }
}
- (void) kumulosAPI:(Kumulos *)kumulos apiOperation:(KSAPIOperation *)operation getFriendByNameDidCompleteWithResult:(NSArray *)theResults
{
    [data4SearchingTableView removeAllObjects];
    [data4SearchingTableView addObjectsFromArray:theResults];
    [self.tableView reloadData];
    [self.mySearchBarController.searchResultsTableView reloadData];

}

-(void) quickAlert:(NSString *)titleText msgText:(NSString *)msgText{
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:titleText message:msgText delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
	[alert show];
}
- (IBAction)cancelButton:(id)sender {
    [self dismissModalViewControllerAnimated:YES];
}

@end
