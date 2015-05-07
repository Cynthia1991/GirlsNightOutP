//
//  EventAddFriendsViewController.m
//  gno
//
//  Created by calvin on 5/06/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////not use now, add friends in timeline by selecting friendList
#import "EventAddFriendsViewController.h"
#import "FriendsListViewController.h"

@interface EventAddFriendsViewController ()

@end

@implementation EventAddFriendsViewController
@synthesize eventID,oldFriendsList,nowFriendsList;

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
    [self.tableView reloadData];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:NO];
    
    appDelegate=(AppDelegate*)[[UIApplication sharedApplication] delegate];

    self.oldFriendsList=[[[appDelegate eventsManager] getEventDictionaryByEventID:eventID] objectForKey:@"eventFriends"];
    [self.tableView reloadData];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
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
    return [[[[appDelegate eventsManager] getEventDictionaryByEventID:eventID] objectForKey:@"eventFriends"] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    cell.textLabel.text=[[[[[[appDelegate eventsManager] getEventDictionaryByEventID:eventID] objectForKey:@"eventFriends"] objectAtIndex:[indexPath row]] objectForKey:@"userID"] objectForKey:@"userName"];
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

#pragma mark - button action
- (IBAction)addFriendsAction:(id)sender {
    FriendsListViewController *friendsListViewController=[self.storyboard instantiateViewControllerWithIdentifier:@"FriendsListController"];
    friendsListViewController.title=@"Invite Friends";
    [friendsListViewController setEventAddFriendsViewController:self];
    [friendsListViewController setFriendFunction:2];
    NSMutableArray *arr=[[NSMutableArray alloc] initWithArray:oldFriendsList];
    [friendsListViewController setEventFriends:arr];
    [friendsListViewController setEvetnIDForAddFriends:[self eventID]];
    
    [self.navigationController pushViewController:friendsListViewController animated:YES];
}

- (IBAction)CancelAction:(id)sender {
    [self dismissModalViewControllerAnimated:YES];
}

#pragma mark - Update Server
-(void) updateServer:(NSMutableArray*) nowFriendsList1
{
    nowFriendsList=[[NSMutableArray alloc] initWithArray:nowFriendsList1];
    for (int i=0; i<[nowFriendsList count]; i++) {
		NSPredicate *predicate = [NSPredicate predicateWithFormat:@"userDBID == %@", [[nowFriendsList objectAtIndex:i] objectForKey:@"userDBID"]];
		NSArray *abc = [self.oldFriendsList filteredArrayUsingPredicate:predicate];        
        
        if ([abc count]==0) //false = no this record in oldFriendList, so add it
        {
            //add friends event here
            Kumulos *k=[[Kumulos alloc] init];
            [k setDelegate:self];
            [k inviteFriendsWithRole:@"Member" andIsConfirm:1 andIsHome:0 andEventID:[[self eventID] intValue] andUserID:[[[[nowFriendsList objectAtIndex:i] objectForKey:@"userID"] objectForKey:@"userDBID"]intValue]];
//            [[[[appDelegate eventsManager] getEventDictionaryByEventID:[self eventID]] objectForKey:@"eventFriends"] addObject:[nowFriendsList objectAtIndex:i]];
        }
    }

    //////////////////////////////////////////////////////////////////////////////
    for (int i=0; i<[oldFriendsList count]; i++) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"userDBID == %@", [[oldFriendsList objectAtIndex:i] objectForKey:@"userDBID"]];
		NSArray *abc = [self.nowFriendsList filteredArrayUsingPredicate:predicate]; 
        
        if ([abc count]==0) //false = no this record in nowFriendList, so delete it
        {
            //delete friends event here
            Kumulos *k=[[Kumulos alloc] init];
            [k setDelegate:self];
//            [k delectPeopleInEventWithEventID:[[self eventID] intValue] andUserID:[[[oldFriendsList objectAtIndex:i] objectForKey:@"userDBID"]intValue]];
            [k delectPeopleInEventWithEventID:[[self eventID] intValue] andUserID:[[[[oldFriendsList objectAtIndex:i] objectForKey:@"userID"] objectForKey:@"userDBID"]intValue]];
        }
    }
    
    
    //////////////////////////////////////////////////////////////////////////////
//    [[[[appDelegate eventsManager] getEventDictionaryByEventID:[self eventID]] objectForKey:@"eventFriends"] removeAllObjects];
//    [[[[appDelegate eventsManager] getEventDictionaryByEventID:[self eventID]] objectForKey:@"eventFriends"] addObjectsFromArray:nowFriendsList];
    [[appDelegate eventsManager] updateFriendsListByEventDBID:[self eventID] function:0];
}

#pragma mark - Kumulos delegate
-(void) kumulosAPI:(Kumulos *)kumulos apiOperation:(KSAPIOperation *)operation inviteFriendsDidCompleteWithResult:(NSNumber *)newRecordID
{
    NSLog(@"invite friend successful");
}
-(void) kumulosAPI:(Kumulos *)kumulos apiOperation:(KSAPIOperation *)operation delectPeopleInEventDidCompleteWithResult:(NSNumber *)affectedRows
{
    NSLog(@"delete friend successful");

}
@end
