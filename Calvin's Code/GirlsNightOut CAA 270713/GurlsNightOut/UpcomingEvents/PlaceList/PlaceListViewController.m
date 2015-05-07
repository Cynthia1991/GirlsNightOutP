//
//  PlaceListViewController.m
//  FoursquarePlace
//
//  Created by calvin on 3/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PlaceListViewController.h"
#import "PlaceDetailsViewController.h"

@interface PlaceListViewController ()

@end

@implementation PlaceListViewController
@synthesize currentLocation,searchBarDisplayController,addEventsViewController,function,eventDBID;

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
    [self setTitle:[NSString stringWithFormat:@"Location"]];

    data4TableView=[[NSMutableArray alloc] init];
    data4SearchingTableView=[[NSMutableArray alloc] init];

    
    NSString *urlStr=[NSString stringWithFormat:@"https://api.foursquare.com/v2/venues/search?ll=%.6f,%.6f&client_id=%@&client_secret=%@",currentLocation.location.coordinate.latitude,currentLocation.location.coordinate.longitude,kFourSquareClientID,kFourSquareClientSecret];
    NSURL *url=[NSURL URLWithString:urlStr];
    
    // Create the request.
    NSURLRequest *theRequest=[NSURLRequest requestWithURL:url
                                              cachePolicy:NSURLRequestUseProtocolCachePolicy
                                          timeoutInterval:20.0];
    NSURLConnection *theConnection=[[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
    funtionFSQ=0;
    [theConnection start];
    
    if (theConnection) {
        receivedData = [NSMutableData data];
    } else {
        [self quickAlert:@"Connection failed." msgText:@"Connection failed."];
    }

}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

#pragma mark - NSURLConnection delegate
-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
	[receivedData setLength: 0];
    NSLog(@"connection: didReceiveResponse:1");
}
-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
	[receivedData appendData:data];
    NSLog(@"connection: didReceiveData:2");
	
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{ 
    NSLog(@"ERROR with theConenction");
}
-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSLog(@"3 DONE. Received Bytes: %d", [receivedData length]);
    NSString *result = [[NSString alloc] initWithBytes: [receivedData mutableBytes] length:[receivedData length] encoding:NSUTF8StringEncoding];
    
    if (result!=nil) {     
        NSMutableDictionary *dic=[result JSONValue];        
        if (funtionFSQ==0) {
            if ([[[dic objectForKey:@"meta"] objectForKey:@"code"] intValue]==200) {
                [data4TableView addObjectsFromArray:[[[[dic objectForKey:@"response"] objectForKey:@"groups"] objectAtIndex:0] objectForKey:@"items"]];
            }
            else {
                [self quickAlert:@"Web server failed." msgText:@"Web server failed."];
            }
            [self.tableView reloadData];
        }
        else if (funtionFSQ==1) {
            if ([[[dic objectForKey:@"meta"] objectForKey:@"code"] intValue]==200) {
                [data4SearchingTableView addObjectsFromArray:[[[[dic objectForKey:@"response"] objectForKey:@"groups"] objectAtIndex:0] objectForKey:@"items"]];
            }
            else {
                [self quickAlert:@"Web server failed." msgText:@"Web server failed."];
            }
            [self.searchBarDisplayController.searchResultsTableView reloadData];
        }
    }
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
    if ([tableView isEqual:self.searchDisplayController.searchResultsTableView]) {
        return [data4SearchingTableView count];
    }
    else {
        return [data4TableView count];
    }
    return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    return 75;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        
        UILabel *placeName=[[UILabel alloc] initWithFrame:CGRectMake(20, 6, 280, 29)];
        [placeName setTag:1];
        [placeName setBackgroundColor:[UIColor clearColor]];
//        [placeName setLineBreakMode:UILineBreakModeTailTruncation];
        [placeName setNumberOfLines:1];
        [placeName setFont:[UIFont boldSystemFontOfSize:18]];
        [placeName setTextColor:[UIColor blackColor]];
        [placeName setHighlightedTextColor:[UIColor whiteColor]];
        [placeName setShadowColor:[UIColor whiteColor]];
        [placeName setShadowOffset:CGSizeMake(0, 1)];
        [[cell contentView] addSubview:placeName];
        
        UILabel *placeAddress=[[UILabel alloc] initWithFrame:CGRectMake(20, 32, 280, 21)];
        [placeAddress setTag:2];
        [placeAddress setBackgroundColor:[UIColor clearColor]];
//        [placeAddress setLineBreakMode:UILineBreakModeTailTruncation];
        [placeAddress setNumberOfLines:1];
        [placeAddress setFont:[UIFont systemFontOfSize:16]];
        [placeAddress setTextColor:[UIColor blackColor]];
        [placeAddress setHighlightedTextColor:[UIColor whiteColor]];
        [placeAddress setShadowColor:[UIColor whiteColor]];
        [placeAddress setShadowOffset:CGSizeMake(0, 1)];
        [[cell contentView] addSubview:placeAddress];
        
        UILabel *placeDistance=[[UILabel alloc] initWithFrame:CGRectMake(20, 52, 280, 21)];
        [placeDistance setTag:3];
        [placeDistance setBackgroundColor:[UIColor clearColor]];
//        [placeAddress setLineBreakMode:UILineBreakModeTailTruncation];
        [placeDistance setNumberOfLines:1];
        [placeDistance setFont:[UIFont systemFontOfSize:16]];
        [placeDistance setTextColor:[UIColor blackColor]];
        [placeDistance setHighlightedTextColor:[UIColor whiteColor]];
        [placeDistance setShadowColor:[UIColor whiteColor]];
        [placeDistance setShadowOffset:CGSizeMake(0, 1)];
        [[cell contentView] addSubview:placeDistance];
    }
    
    // Configure the cell...
    NSMutableDictionary *dic=[[NSMutableDictionary alloc] init];
    if ([tableView isEqual:self.searchDisplayController.searchResultsTableView]) {        
        dic=[data4SearchingTableView objectAtIndex:[indexPath row]];
    }
    else {
        dic=[data4TableView objectAtIndex:[indexPath row]];
    }
    
    UILabel *placeName = (UILabel *)[cell viewWithTag:1];
    UILabel *placeAddress = (UILabel *)[cell viewWithTag:2];
    UILabel *placeDistance = (UILabel *)[cell viewWithTag:3];

    
    placeName.text=[NSString stringWithFormat:@"%@", [dic objectForKey:@"name"]];
    if ([[dic objectForKey:@"location"] objectForKey:@"address"]==nil) {
        placeAddress.text=[NSString stringWithFormat:@"No Address."];

    }
    else {
        placeAddress.text=[NSString stringWithFormat:@"%@", [[dic objectForKey:@"location"] objectForKey:@"address"]];

    }
    placeDistance.text=[NSString stringWithFormat:@"%@ m", [[dic objectForKey:@"location"] objectForKey:@"distance"]];
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSMutableDictionary *dic=[[NSMutableDictionary alloc] init];
    if ([tableView isEqual:self.searchDisplayController.searchResultsTableView]) {        
        dic=[data4SearchingTableView objectAtIndex:[indexPath row]];
    }
    else {
        dic=[data4TableView objectAtIndex:[indexPath row]];
    }
    PlaceDetailsViewController *placeDetailsViewController=[self.storyboard instantiateViewControllerWithIdentifier:@"PlaceDetailsViewController"];
    [placeDetailsViewController setLatitude:[[[dic objectForKey:@"location"] objectForKey:@"lat"] floatValue]];
    [placeDetailsViewController setLongitude:[[[dic objectForKey:@"location"] objectForKey:@"lng"] floatValue]];
    [placeDetailsViewController setPName:[dic objectForKey:@"name"]];
    [placeDetailsViewController setPAddress:[[dic objectForKey:@"location"] objectForKey:@"address"]];
    [placeDetailsViewController setPDictance:[[dic objectForKey:@"location"] objectForKey:@"distance"]];
    
    [placeDetailsViewController setFunction:[self function]];
    [placeDetailsViewController setAddEventsViewController:[self addEventsViewController]];
    [self.navigationController pushViewController:placeDetailsViewController animated:YES];
    
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
    [data4SearchingTableView removeAllObjects];
    
    if ([searchText length]!=0) {
        NSString *query=[searchText stringByReplacingOccurrencesOfString:@" " withString:@"+"];
        NSLog(@"%@",query);
        
        NSString *urlStr=[NSString stringWithFormat:@"https://api.foursquare.com/v2/venues/search?ll=%.6f,%.6f&query=%@&client_id=%@&client_secret=%@",currentLocation.location.coordinate.latitude,currentLocation.location.coordinate.longitude,query,kFourSquareClientID,kFourSquareClientSecret];
        NSURL *url=[NSURL URLWithString:urlStr];
        
        // Create the request.
        NSURLRequest *theRequest=[NSURLRequest requestWithURL:url
                                                  cachePolicy:NSURLRequestUseProtocolCachePolicy
                                              timeoutInterval:20.0];
        NSURLConnection *theConnection=[[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
        funtionFSQ=1;
        [theConnection start];
        
        if (theConnection) {
            receivedData = [NSMutableData data];
        } else {
            //        NSLog(@"Connection failed.");    
            [self quickAlert:@"Connection failed." msgText:@"Connection failed."];

        }
    }
}

-(void) quickAlert:(NSString *)titleText msgText:(NSString *)msgText{
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:titleText message:msgText delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
	[alert show];
}
- (IBAction)cancelButtonAction:(id)sender {
    [self dismissModalViewControllerAnimated:YES];
}
@end
