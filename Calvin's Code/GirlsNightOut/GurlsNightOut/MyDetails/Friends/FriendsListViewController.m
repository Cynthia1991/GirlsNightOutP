//
//  FriendsListViewController.m
//  GurlsNightOut
//
//  Created by Calvin on 11/04/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "FriendsListViewController.h"
#import "FriendsListTableCell.h"
#import "MyDetailsDisplayViewController.h"

@interface FriendsListViewController ()

@end

@implementation FriendsListViewController
@synthesize _tableView;
@synthesize rightButton;
@synthesize footerView;
@synthesize inviteFriendEventID,friendFunction,addEventsViewController,eventAddFriendsViewController,eventFriends,evetnIDForAddFriends;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    iconDic=[[NSMutableDictionary alloc] init];
	bumpConn = [[BumpConnector alloc] init];	
    appDelegate=(AppDelegate*)[[UIApplication sharedApplication] delegate];

    [[NSNotificationCenter defaultCenter]  addObserver:self selector:@selector(reloadTableView:) name:@"reloadTableView" object:nil]; //////////
    [[NSNotificationCenter defaultCenter]  addObserver:self selector:@selector(reloadDataFromServer:) name:@"reload Friends List Data" object:nil]; //////////

    if (refreshHeaderView == nil) {
        
        EGORefreshTableHeaderView *view = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - self._tableView.bounds.size.height, self.view.frame.size.width, self._tableView.bounds.size.height)];
        view.delegate = self;
        [self._tableView addSubview:view];
        refreshHeaderView = view;        
    }
    //  update the last update date
    [refreshHeaderView refreshLastUpdatedDate];

    friendsArrayTableView=[[NSMutableArray alloc] init];
    if (friendFunction==3) {
        [self.navigationItem setRightBarButtonItem:nil];

        for (int i=0; i<[[[appDelegate friendsManager] friendsList] count]; i++) {
            if (![self isIncludingInEventDetailByOldArrayID:[[[[appDelegate friendsManager] friendsList] objectAtIndex:i] objectForKey:@"userDBID"]]) {
                [friendsArrayTableView addObject:[[[[appDelegate friendsManager] friendsList] objectAtIndex:i] copy]];
            }
        }
    }
    [self._tableView setBackgroundColor:[UIColor clearColor]];
    
    if (friendFunction!=0) {
        [rightButton setImage:[UIImage imageNamed:@"DoneButton.png"] forState:UIControlStateNormal];

    }
}
- (void) viewWillAppear:(BOOL)animated
{
    if (friendFunction!=0) {
        [self._tableView setTableFooterView:self.footerView];
    }
    else
    {
        [self._tableView setTableFooterView:nil];
    }
    
    [self.navigationController setNavigationBarHidden:YES];
}
- (void)viewDidUnload
{
    [self set_tableView:nil];
    [self setRightButton:nil];
    [self setRightButton:nil];
    [self setFooterView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

-(Boolean) isIncludingInEventDetailByOldArrayID:(NSString *) userDBID
{
    for (int i=0; i<[self.eventFriends count]; i++) {
        if ([[[[self.eventFriends objectAtIndex:i] objectForKey:@"userID"] objectForKey:@"userDBID"] intValue] == [userDBID intValue]) 
        {
            return true;
        }
    }
    return false;
}
-(Boolean) isIncludingInEventDetailByNewArrayID:(NSString *) userDBID
{
    for (int i=0; i<[addEventsViewController.friendsArray count]; i++) {
        if ([[[[addEventsViewController.friendsArray objectAtIndex:i] objectForKey:@"userID"] objectForKey:@"userDBID"] intValue] == [userDBID intValue]) 
        {
            return true;
        }
    }
    return false;
}
#pragma mark - Kumulos delegate
-(void) kumulosAPI:(Kumulos *)kumulos apiOperation:(KSAPIOperation *)operation inviteFriendsDidCompleteWithResult:(NSNumber *)newRecordID
{
//    Kumulos *k=[[Kumulos alloc] init];
//    [k setDelegate:self];
//    [k getOneEventWithEventPeopleDBID:[newRecordID intValue]];
}
-(void) kumulosAPI:(Kumulos *)kumulos apiOperation:(KSAPIOperation *)operation delectPeopleInEventDidCompleteWithResult:(NSNumber *)affectedRows
{

}
-(void) kumulosAPI:(Kumulos *)kumulos apiOperation:(KSAPIOperation *)operation getOneEventDidCompleteWithResult:(NSArray *)theResults
{
//    NSString *eventDBID=[[[theResults objectAtIndex:0] objectForKey:@"eventID"] objectForKey:@"eventDBID"];
//    [[[[appDelegate eventsManager] getEventDictionaryByEventID:eventDBID] objectForKey:@"eventFriends"] addObject:[theResults objectAtIndex:0]];
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
    if (friendFunction==3) {
        return [friendsArrayTableView count];
    }
    else
    {
        return [[[appDelegate friendsManager] friendsList] count];
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    FriendsListTableCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
//    cell.backgroundView=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Cellbg.png"]];

//    cell.ivIcon.layer.masksToBounds = YES; //没这句话它圆不起来
//    cell.ivIcon.layer.cornerRadius = 10.0; //设置图片圆角的尺度。
    // Configure the cell...
//    cell.lbSubTitle.textColor=[UIColor grayColor];

    ////////////////////////////////////////////////////////tick the user to invite friends
    if(friendFunction==2)
    {
        if ([self isIncludingInEventAddFriends:[[[[appDelegate friendsManager] friendsList] objectAtIndex:[indexPath row]] objectForKey:@"userDBID"]]) {
            cell.accessoryType=UITableViewCellAccessoryCheckmark;
        }
        else{
            cell.accessoryType=UITableViewCellAccessoryNone;
        }
    }
    else if(friendFunction==1) {
        if ([self isIncludingInAddEvent:[[[[appDelegate friendsManager] friendsList] objectAtIndex:[indexPath row]] objectForKey:@"userDBID"]]) {
            cell.accessoryType=UITableViewCellAccessoryCheckmark;
        }
        else{
            cell.accessoryType=UITableViewCellAccessoryNone;
        }
    }
    else if (friendFunction==3)
    {
        if ([self isIncludingInAddEvent:[[friendsArrayTableView objectAtIndex:[indexPath row]] objectForKey:@"userDBID"]]) {
            cell.accessoryType=UITableViewCellAccessoryCheckmark;
        }
        else{
            cell.lbSubTitle.text=[NSString stringWithFormat:@"Tick me to invite"];
            cell.accessoryType=UITableViewCellAccessoryNone;
        }
    }
    ////////////////////////////////////////////////////////tick the user to invite friends

    
    
    if (friendFunction==3) {
        cell.lbTitle.text=[[friendsArrayTableView objectAtIndex:[indexPath row]] objectForKey:@"userName"];
        if ([[[friendsArrayTableView objectAtIndex:[indexPath row]] objectForKey:@"photosDBID"] intValue]!=0) {
            if ([[[[appDelegate photoManager] photoDic] objectForKey:[NSString stringWithFormat:@"id%@",[[friendsArrayTableView objectAtIndex:[indexPath row]] objectForKey:@"photosDBID"]]] objectForKey:@"path"]!=0) {
                if ([iconDic objectForKey:[NSString stringWithFormat:@"id%@",[[friendsArrayTableView objectAtIndex:[indexPath row]] objectForKey:@"photosDBID"]]]!=nil) {
                    UIImage *img=[iconDic objectForKey:[NSString stringWithFormat:@"id%@",[[friendsArrayTableView objectAtIndex:[indexPath row]] objectForKey:@"photosDBID"]]];
                    cell.ivIcon.image=img;
                }
                else {
                    UIImage *img=[[appDelegate photoManager] getPhotoByPhotoDBID:[[friendsArrayTableView objectAtIndex:[indexPath row]] objectForKey:@"photosDBID"]];
                    [iconDic setObject:img forKey:[NSString stringWithFormat:@"id%@",[[friendsArrayTableView objectAtIndex:[indexPath row]] objectForKey:@"photosDBID"]]];
                    cell.ivIcon.image=img;
                }
                
            }
            else {
                //load icon
                if ([[[appDelegate photoManager] photoDic] objectForKey:[NSString stringWithFormat:@"id%@", [[friendsArrayTableView objectAtIndex:[indexPath row]] objectForKey:@"photosDBID"]]]==nil) {
                    [self loadPhotoFromServer:[[[friendsArrayTableView objectAtIndex:[indexPath row]] objectForKey:@"photosDBID"] intValue]];
                }
            }
        }
        else {
            UIImage *img=[UIImage imageNamed:@"Persondot.png"];
            cell.ivIcon.image=img;
        }
    }
    else {
        if (friendFunction==0) {
            cell.ivArrow.hidden=NO;
        }
        cell.lbTitle.text=[[[[appDelegate friendsManager] friendsList] objectAtIndex:[indexPath row]] objectForKey:@"userName"];
        if ([[[[[appDelegate friendsManager] friendsList] objectAtIndex:[indexPath row]] objectForKey:@"photosDBID"] intValue]!=0) {
            if ([[[[appDelegate photoManager] photoDic] objectForKey:[NSString stringWithFormat:@"id%@",[[[[appDelegate friendsManager] friendsList] objectAtIndex:[indexPath row]] objectForKey:@"photosDBID"]]] objectForKey:@"path"]!=0) {
                if ([iconDic objectForKey:[NSString stringWithFormat:@"id%@",[[[[appDelegate friendsManager] friendsList] objectAtIndex:[indexPath row]] objectForKey:@"photosDBID"]]]!=nil) {
                    UIImage *img=[iconDic objectForKey:[NSString stringWithFormat:@"id%@",[[[[appDelegate friendsManager] friendsList] objectAtIndex:[indexPath row]] objectForKey:@"photosDBID"]]];
                    cell.ivIcon.image=img;
                }
                else {
                    UIImage *img=[[appDelegate photoManager] getPhotoByPhotoDBID:[[[[appDelegate friendsManager] friendsList] objectAtIndex:[indexPath row]] objectForKey:@"photosDBID"]];
                    [iconDic setObject:img forKey:[NSString stringWithFormat:@"id%@",[[[[appDelegate friendsManager] friendsList] objectAtIndex:[indexPath row]] objectForKey:@"photosDBID"]]];
                    cell.ivIcon.image=img;
                }
                
            }
            else {
                //load icon
                if ([[[appDelegate photoManager] photoDic] objectForKey:[NSString stringWithFormat:@"id%@", [[[[appDelegate friendsManager] friendsList] objectAtIndex:[indexPath row]] objectForKey:@"photosDBID"]]]==nil) {
                    [self loadPhotoFromServer:[[[[[appDelegate friendsManager] friendsList] objectAtIndex:[indexPath row]] objectForKey:@"photosDBID"] intValue]];
                }
            }
        }
        else {
            UIImage *img=[UIImage imageNamed:@"Persondot.png"];
            cell.ivIcon.image=img;
        }
    }
    [self setCellSelectedBackgroundImage:nil TableViewCell:cell];

    
    return cell;
}

- (void)setCellSelectedBackgroundImage:(NSString*)imageName TableViewCell:(UITableViewCell*) tableViewCell
{
    UIView *imageView= [[UIView alloc] initWithFrame:tableViewCell.frame];
    imageView.backgroundColor = [UIColor purpleColor];
    tableViewCell.selectedBackgroundView = imageView;
}
#pragma mark - Function for Table view data source
- (Boolean) isIncludingInEventAddFriends:(NSString *) userDBID
{
    for (int i=0; i<[[[[appDelegate eventsManager] getEventDictionaryByEventID:[self evetnIDForAddFriends]] objectForKey:@"eventFriends"] count]; i++) {
        if ([[[[[[[appDelegate eventsManager] getEventDictionaryByEventID:[self evetnIDForAddFriends]] objectForKey:@"eventFriends"] objectAtIndex:i] objectForKey:@"userID"] objectForKey:@"userDBID"] intValue] == [userDBID intValue]) 
        {
            return true;
        }
    }
    return false;
}

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (friendFunction==0) 
    {
        MyDetailsDisplayViewController *myDetailsDisplayViewController=[self.storyboard instantiateViewControllerWithIdentifier:@"MyDetailsDisplayViewController"];
        myDetailsDisplayViewController.function=1;
        myDetailsDisplayViewController.friendsDetialDic=[[NSMutableDictionary alloc] initWithDictionary:[[[appDelegate friendsManager] friendsList] objectAtIndex:[indexPath row]]];
        [self.navigationController pushViewController:myDetailsDisplayViewController animated:YES];
    }
    else if(friendFunction==1)//add friends when create a new event
    {
        if ([self isIncludingInAddEvent:[[[[appDelegate friendsManager] friendsList] objectAtIndex:[indexPath row]] objectForKey:@"userDBID"]]) {
            [self removeFriendsInAddEvent:[[[[appDelegate friendsManager] friendsList] objectAtIndex:[indexPath row]] objectForKey:@"userDBID"]];
            FriendsListTableCell *cell=(FriendsListTableCell*)[self._tableView cellForRowAtIndexPath:indexPath];
            cell.accessoryType=UITableViewCellAccessoryNone;
        }
        else {
            NSMutableDictionary *dic=[[NSMutableDictionary alloc] init];
            [dic setObject:[[[appDelegate friendsManager] friendsList] objectAtIndex:[indexPath row]] forKey:@"userID"];
            
            [eventFriends insertObject:dic atIndex:0];

            FriendsListTableCell *cell=(FriendsListTableCell*)[self._tableView cellForRowAtIndexPath:indexPath];
            cell.accessoryType=UITableViewCellAccessoryCheckmark;
        }
    }
    else if (friendFunction==2)///////////add friends in event manage
    {
//        if ([self isIncludingInEventAddFriends:[[[[[appDelegate friendsManager] friendsList] objectAtIndex:[indexPath row]] objectForKey:@"userID"] objectForKey:@"userDBID"]]) {
//            [self removeFriendsInAddEvent:[[[[[appDelegate friendsManager] friendsList] objectAtIndex:[indexPath row]] objectForKey:@"userID"] objectForKey:@"userDBID"]];
//            UITableViewCell *cell=[self.tableView cellForRowAtIndexPath:indexPath];
//            cell.accessoryType=UITableViewCellAccessoryNone;
//        }
//        else {
//            [eventFriends addObject:[[[appDelegate friendsManager] friendsList] objectAtIndex:[indexPath row]]];
//
//            UITableViewCell *cell=[self.tableView cellForRowAtIndexPath:indexPath];
//            cell.accessoryType=UITableViewCellAccessoryCheckmark;
//        }
    }
    else if (friendFunction==3) {/////////add friends in event details edit        
        if ([self isIncludingInAddEvent:[[friendsArrayTableView objectAtIndex:[indexPath row]] objectForKey:@"userDBID"]]) {
            [self removeFriendsInAddEvent:[[friendsArrayTableView objectAtIndex:[indexPath row]]objectForKey:@"userDBID"]];
            FriendsListTableCell *cell=(FriendsListTableCell*)[self._tableView cellForRowAtIndexPath:indexPath];
            cell.lbSubTitle.text=[NSString stringWithFormat:@"Tick me to invite"];
            cell.accessoryType=UITableViewCellAccessoryNone;
        }
        else {
            NSMutableDictionary *dic=[[NSMutableDictionary alloc] init];
            [dic setObject:[friendsArrayTableView objectAtIndex:[indexPath row]] forKey:@"userID"];
            [eventFriends addObject:dic];
            
            FriendsListTableCell *cell=(FriendsListTableCell*)[self._tableView cellForRowAtIndexPath:indexPath];
            cell.lbSubTitle.text=[NSString stringWithFormat:@"Untick me to invite"];
            cell.accessoryType=UITableViewCellAccessoryCheckmark;
        }
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    return 86;
}
#pragma mark - Function for Table view delegate
- (Boolean) isIncludingInAddEvent:(NSString *) userDBID
{
    for (int i=0; i<[eventFriends count]; i++) {
//        if (friendFunction==1) {
//            if ([[[eventFriends objectAtIndex:i] objectForKey:@"userDBID"] intValue]==[userDBID intValue]) {
//                return true;
//            }
//        }
//        else if (friendFunction==3) {
            if ([[[[eventFriends objectAtIndex:i] objectForKey:@"userID"] objectForKey:@"userDBID"] intValue]==[userDBID intValue]) {
                return true;
            }
//        }

    }
    return false;
}
-(void) removeFriendsInAddEvent:(NSString *) userDBID
{
    for (int i=0; i<[eventFriends count]; i++) {
        if (friendFunction==1) {
            if ([[[[eventFriends objectAtIndex:i] objectForKey:@"userID"] objectForKey:@"userDBID"] intValue] == [userDBID intValue]) {
                [eventFriends removeObjectAtIndex:i];
                break;
            }
        }
        else if (friendFunction==3) {
            if ([[[[eventFriends objectAtIndex:i] objectForKey:@"userID"] objectForKey:@"userDBID"] intValue] == [userDBID intValue]) {
                [eventFriends removeObjectAtIndex:i];
                break;
            }
        }
    }
}
#pragma mark - load photo from server
- (void) loadPhotoFromServer:(int) photoDBID
{            
    Kumulos *k=[[Kumulos alloc] init];
    [k setDelegate:self];
    [k getPhotoWithPhotosDBID:photoDBID];
}
- (void) kumulosAPI:(Kumulos *)kumulos apiOperation:(KSAPIOperation *)operation getPhotoDidCompleteWithResult:(NSArray *)theResults
{
    [[appDelegate photoManager] addPhoto:[[theResults objectAtIndex:0] objectForKey:@"photoValue"] text:[[theResults objectAtIndex:0] objectForKey:@"textValue"] PhotoDBID:[[theResults objectAtIndex:0] objectForKey:@"photosDBID"]];
    [self._tableView reloadData];
}

#pragma mark - actionSheet configuration
-(void)applicationWillTerminate:(UIApplication *)application{
	[bumpConn stopBump];
}

- (IBAction)doneAction:(id)sender {
    if (friendFunction==0) {
        UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                      initWithTitle:@"Add Friends Method"         //Title
                                      delegate:self                  //delegate
                                      cancelButtonTitle:@"Cancel"
                                      destructiveButtonTitle:nil
                                      otherButtonTitles:@"Bump", @"Manually", nil];  //button
        [actionSheet showInView:self._tableView];/////////////////////////////////////////////////////////interesting,not in tabbar has somge problem
        
    }
    else if (friendFunction==1) {//add friend in add event
        //add friends
        NSLog(@"%@",addEventsViewController.friendsArray);
        [self.navigationController popViewControllerAnimated:YES];
    }
    else if (friendFunction==3) {//add friend in event detail
        addEventsViewController.addFriendsInEventDetailsFunction=1;
        addEventsViewController.friendsArrayInEventDetails=self.eventFriends;
        [self.navigationController popViewControllerAnimated:YES];
    }
    else if (friendFunction==2)//add friend in timeline
    {
        [eventAddFriendsViewController updateServer:eventFriends];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (IBAction)backAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)addFriendsAction:(id)sender {
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:@"Add Friends Method"         //Title
                                  delegate:self                  //delegate
                                  cancelButtonTitle:@"Cancel"
                                  destructiveButtonTitle:nil
                                  otherButtonTitles:@"Bump", @"Manually", nil];  //button
    [actionSheet showInView:self._tableView];/////////////////////////////////////////////////////////interesting,not in tabbar has somge problem
}

#pragma mark - actionSheet delegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==0) {             
        [bumpConn setFriendsListViewController:self];
        [bumpConn startBump];
        [bumpConn sendDetails];
    }
    else if(buttonIndex==1){
        [self presentModalViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"FindFriendsViewControllerNav"] animated:YES];
    }
}

#pragma mark - Update Header View
///////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - UIScrollViewDelegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    [refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    
    [refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
    
}

#pragma mark -
#pragma mark EGORefreshTableHeaderDelegate Methods

- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view{
    
    [self reloadTableViewDataSource];
    
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view{
    
    return _reloading; // should return if data source model is reloading
    
}

- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)view{
    
    return [NSDate date]; // should return date data source was last changed
    
}


#pragma mark -
#pragma mark Data Source Loading / Reloading Methods

- (void)reloadTableViewDataSource{
    
    //  should be calling your tableviews data source model to reload
    //  put here just for demo
    
    [self reloadDataFromServer:nil];//reload the data from server
    _reloading = YES;
    
}

- (void)doneLoadingTableViewData{
    
    //  model should call this when its done loading
    [self._tableView reloadData];
    _reloading = NO;
    [refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self._tableView];
}

#pragma mark - reload data
-(void) reloadDataFromServer:(NSNotification*) notification
{
    [[appDelegate friendsManager] getAllFriendsByFunction:1];
}

- (void) reloadTableView:(NSNotification*) notification///////////////////////////////////////////////get
{
    [self doneLoadingTableViewData];
}
///////////////////////////////////////////////////////////////////////////////////////////////////////



@end
