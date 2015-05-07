//
//  EventListController.m
//  GurlsNightOut
//
//  Created by Calvin on 7/04/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//



//reflesh all things in this page by function - (void) reloadAllevents:(NSNotification*) notification
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadFromAddFriends" object:nil];

#import "EventListController.h"
#import "AddEventsViewController.h"
#import "EventMainPageViewController.h"
#import "TimelineScrollViewController.h"

@interface EventListController ()

@end

@implementation EventListController
@synthesize function;
@synthesize _tableView;
@synthesize mySegmentControl;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void) viewWillAppear:(BOOL)animated
{
    if (function==1) {
        [self reloadAllevents:nil];
        function=0;
    }
    [self._tableView reloadData];
    [self.navigationController setNavigationBarHidden:YES];

}
- (void)viewDidLoad
{
    [super viewDidLoad];
    ////////////////////////////////////////////////////////////////////////////////////////////////////////init all objects
    eventImageDic=[[NSMutableDictionary alloc] init];
    [mySegmentControl setFrame:CGRectMake(20, 50, 280, 45)];
    self._tableView.backgroundColor = [UIColor clearColor];
    bumpConn = [[BumpConnector alloc] init];
    appDelegate=(AppDelegate*)[[UIApplication sharedApplication] delegate];
    
    [[NSNotificationCenter defaultCenter]  addObserver:self selector:@selector(reloadTableView:) name:@"reloadEventsTableView" object:nil];
    [[NSNotificationCenter defaultCenter]  addObserver:self selector:@selector(reloadAllevents:) name:@"reloadFromAddFriends" object:nil];
    [[NSNotificationCenter defaultCenter]  addObserver:self selector:@selector(hideHUD:) name:@"hideEventListHUD" object:nil];
    
    ////////////////////////////////////////////////////////////////////////////////////////////////////////For EGORefreshTableHeaderView
    if (refreshHeaderView == nil) {
        
        EGORefreshTableHeaderView *view = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - self._tableView.bounds.size.height, self.view.frame.size.width, self._tableView.bounds.size.height)];
        view.delegate = self;
        [self._tableView addSubview:view];
        refreshHeaderView = view;        
    }
    
    //  update the last update date
    [refreshHeaderView refreshLastUpdatedDate];
    
    //////////////////////////////////////////////////////////////////////////////////////////////////////////reload event list
    [[appDelegate eventsManager] getAllEventsByFunction:0];//////////reload data from local file
    if ([appDelegate internetChecker]) {
        [self reloadAllevents:nil];//reload event list by web
    }
    
    
    
    ///////instruction
    if ([[appDelegate.instructionManager.instructionDic objectForKey:@"eventList"] boolValue]) {
        [self.scvEventListInstruction setHidden:YES];
    }
    else
    {
        [self.scvEventListInstruction setHidden:NO];
    }
	// Do any additional setup after loading the view.
    self.scvEventListInstruction.contentSize=CGSizeMake(320*8, 460);
    [self.scvEventListInstruction setContentOffset:CGPointMake(0, 0)];
}

- (void)viewDidUnload
{
    [self set_tableView:nil];
    [self setMySegmentControl:nil];
    [self setScvEventListInstruction:nil];
    [super viewDidUnload];
}

#pragma mark - Buttons action
- (IBAction)btBackButton:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)segmentAction:(id)sender {
    [self._tableView reloadData];
}

- (IBAction)addEventsAction:(id)sender {
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:@""         //Title
                                  delegate:self                  //delegate
                                  cancelButtonTitle:@"Cancel"
                                  destructiveButtonTitle:nil
                                  otherButtonTitles:@"Create new", @"Join by bumping", nil];  //button
    [actionSheet setTag:1];
    [actionSheet showInView:self._tableView];/////////////////////////////////////////////////////////interesting,not in tabbar has somge problem
}

-(void)applicationWillTerminate:(UIApplication *)application{
	[bumpConn stopBump];
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
    if ([[[appDelegate eventsManager] eventsArray] count]!=0) {
        if ([[[[appDelegate eventsManager] eventsArray] objectAtIndex:mySegmentControl.selectedSegmentIndex] count]==0) {
            return 1;
        }
        else
        {
            return [[[[appDelegate eventsManager] eventsArray] objectAtIndex:mySegmentControl.selectedSegmentIndex] count];
        }
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    static NSString *CellIdentifierNothing = @"CellNothing";
    
    if ([[[[appDelegate eventsManager] eventsArray] objectAtIndex:mySegmentControl.selectedSegmentIndex] count]!=0) {
        EventListCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
//        [cell initCell];
        
        // Configure the cell...
        
        cell.title.text=[[[[[appDelegate eventsManager] eventsArray] objectAtIndex:mySegmentControl.selectedSegmentIndex] objectAtIndex:[indexPath row]] objectForKey:@"eventName"];
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
        NSDate *date=[[[[[appDelegate eventsManager] eventsArray] objectAtIndex:mySegmentControl.selectedSegmentIndex] objectAtIndex:[indexPath row]] objectForKey:@"eventTime"];
        
        cell.time.text=[NSString stringWithFormat:@"Time: %@",[dateFormatter stringFromDate:date]];
        cell.location.text=[NSString stringWithFormat:@"Location: %@", [[[[[appDelegate eventsManager] eventsArray] objectAtIndex:mySegmentControl.selectedSegmentIndex]objectAtIndex:[indexPath row]] objectForKey:@"locationName"]];
        [self setCellSelectedBackgroundImage:nil TableViewCell:cell];
        
        
        ///////////////////////////////////////////
        NSString *eventIconDBID=[[[[[appDelegate eventsManager] eventsArray] objectAtIndex:mySegmentControl.selectedSegmentIndex] objectAtIndex:[indexPath row]] objectForKey:@"eventIconDBID"];
        if ([eventIconDBID intValue]!=0) {
            if ([[[[appDelegate photoManager] photoDic] objectForKey:[NSString stringWithFormat:@"id%@",eventIconDBID]] objectForKey:@"path"]!=0) {
                if ([eventImageDic objectForKey:[NSString stringWithFormat:@"id%@",eventIconDBID]]!=nil) {
                    UIImage *img=[eventImageDic objectForKey:[NSString stringWithFormat:@"id%@",eventIconDBID]];
                    cell.ivEventPhoto.image=img;
                }
                else {
                    UIImage *img=[[appDelegate photoManager] getPhotoByPhotoDBID:eventIconDBID];
                    [eventImageDic setObject:img forKey:[NSString stringWithFormat:@"id%@",eventIconDBID]];
                    cell.ivEventPhoto.image=img;
                }
                
            }
            else {
                //load icon
                if ([[[appDelegate photoManager] photoDic] objectForKey:[NSString stringWithFormat:@"id%@", eventIconDBID]]==nil) {
                    [self loadPhotoFromServer:[eventIconDBID intValue]];
                }
            }
        }
        else {
            UIImage *img=[UIImage imageNamed:@"EventIcon.png"];
            cell.ivEventPhoto.image=img;
        }
        
        
        
        return cell;
    }
    else
    {
        UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:CellIdentifierNothing];
        return cell;
    }
    return nil;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 85;
}

//- (void)tableView:(UITableView *)tableViewa commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
//	//remove Event
//    if ([[[[appDelegate eventsManager] eventsArray] objectAtIndex:mySegmentControl.selectedSegmentIndex] count]!=0) {
//        delectEventDic=[[NSMutableDictionary alloc] init];
//        [delectEventDic setObject:[NSString stringWithFormat:@"%d",mySegmentControl.selectedSegmentIndex] forKey:@"section"];
//        [delectEventDic setObject:[NSString stringWithFormat:@"%d",[indexPath row]] forKey:@"row"];
//        
//        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Are you sure want to delete this event?" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"Delete" otherButtonTitles:nil];
//        [actionSheet setTag:0];
//        [actionSheet showInView:self._tableView];/////////////////////////////////////////////////////////interesting,not in tabbar has somge problem
//    }
//
//}
- (void)setCellSelectedBackgroundImage:(NSString*)imageName TableViewCell:(UITableViewCell*) tableViewCell
{
    UIView *imageView= [[UIView alloc] initWithFrame:tableViewCell.frame];
    imageView.backgroundColor = [UIColor purpleColor];
    imageView.alpha=0.7;
    tableViewCell.selectedBackgroundView = imageView;
}
#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([[[[appDelegate eventsManager] eventsArray] objectAtIndex:mySegmentControl.selectedSegmentIndex] count]!=0) {
        AddEventsViewController *addEventsViewController=[self.storyboard instantiateViewControllerWithIdentifier:@"AddEvent"];
        [addEventsViewController setFunction:2];
        [addEventsViewController setEventName:[[[[[appDelegate eventsManager] eventsArray] objectAtIndex:mySegmentControl.selectedSegmentIndex] objectAtIndex:[indexPath row]] objectForKey:@"eventName"]];
        [addEventsViewController setEventDetails:[[[[[appDelegate eventsManager] eventsArray] objectAtIndex:mySegmentControl.selectedSegmentIndex] objectAtIndex:[indexPath row]] objectForKey:@"eventDetails"]];
        [addEventsViewController setEventDBID:[[[[[[appDelegate eventsManager] eventsArray] objectAtIndex:mySegmentControl.selectedSegmentIndex] objectAtIndex:[indexPath row]] objectForKey:@"eventID"] intValue]];
        [addEventsViewController setEventDate:[[[[[appDelegate eventsManager] eventsArray] objectAtIndex:mySegmentControl.selectedSegmentIndex] objectAtIndex:[indexPath row]] objectForKey:@"eventTime"]];
        [addEventsViewController setLocationName:[[[[[appDelegate eventsManager] eventsArray] objectAtIndex:mySegmentControl.selectedSegmentIndex] objectAtIndex:[indexPath row]] objectForKey:@"locationName"]];
        [addEventsViewController setLocationAddress:[[[[[appDelegate eventsManager] eventsArray] objectAtIndex:mySegmentControl.selectedSegmentIndex] objectAtIndex:[indexPath row]] objectForKey:@"locationAddress"]];
        [addEventsViewController setLocationLatitude:[[[[[[appDelegate eventsManager] eventsArray] objectAtIndex:mySegmentControl.selectedSegmentIndex] objectAtIndex:[indexPath row]] objectForKey:@"locationLatitude"] floatValue]];
        [addEventsViewController setLocationLongitude:[[[[[[appDelegate eventsManager] eventsArray] objectAtIndex:mySegmentControl.selectedSegmentIndex] objectAtIndex:[indexPath row]] objectForKey:@"locationLongitude"] floatValue]];
        [addEventsViewController setEventIconDBID:[[[[[appDelegate eventsManager] eventsArray] objectAtIndex:mySegmentControl.selectedSegmentIndex] objectAtIndex:[indexPath row]] objectForKey:@"eventIconDBID"]];
        
        [addEventsViewController setEventListController:self];
        
        NSMutableArray *array=[[NSMutableArray alloc] initWithArray:[[[[[appDelegate eventsManager] eventsArray] objectAtIndex:mySegmentControl.selectedSegmentIndex] objectAtIndex:[indexPath row]] objectForKey:@"eventFriends"]];
        [addEventsViewController setFriendsArray:array];
        
        if (mySegmentControl.selectedSegmentIndex==1) {
            addEventsViewController.isActivity=1;
        }
        else
        {
            addEventsViewController.isActivity=0;
        }
        [self.navigationController pushViewController:addEventsViewController animated:YES];
    }
}



#pragma mark - actionSheet delegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (actionSheet.tag==1) {
        if (buttonIndex==0) {
            AddEventsViewController *addEventsViewController=[self.storyboard instantiateViewControllerWithIdentifier:@"AddEvent"];
            [addEventsViewController setEventListController:self];
            [self.navigationController pushViewController:addEventsViewController animated:YES];
        }
        else if(buttonIndex==1){
            [bumpConn setEventListController:self];
            [bumpConn setFunction:2];
            [bumpConn startBump];
            [bumpConn sendDetails];
        }
    }
    else if(actionSheet.tag==0)
    {
        if (buttonIndex==0) {
            NSIndexPath *indexPath=[NSIndexPath indexPathForRow:[[delectEventDic objectForKey:@"row"] intValue] inSection:[[delectEventDic objectForKey:@"section"] intValue]];
            
            [[appDelegate eventsManager] deleteEventByIndex:mySegmentControl.selectedSegmentIndex Row:[indexPath row]];
            
        }
    }

}

#pragma mark - reflesh the table
#pragma mark -
#pragma mark UIScrollViewDelegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    if (scrollView.tag==0) {
        [refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
    }
    else if (scrollView.tag==1)
    {
        if (scrollView.contentOffset.x>2240) {
            [UIView animateWithDuration:0.5
                             animations:^{
                                 [self.scvEventListInstruction setAlpha:0.0];
                                 
                             }
                             completion:^(BOOL finished){
                                 [self.scvEventListInstruction setHidden:YES];
                                 [appDelegate.instructionManager setInstructionDicWithValue:YES Key:[NSString stringWithFormat:@"eventList"]];
                             }];
        }
    }
}

#pragma mark -
#pragma mark EGORefreshTableHeaderDelegate Methods

- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view{
    [self reloadAllevents:nil];
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view{
    return _reloading; // should return if data source model is reloading
}

- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)view{
    return [NSDate date]; // should return date data source was last changed
}


#pragma mark -
#pragma mark Data Source Loading / Reloading Methods
- (void) reloadTableView:(NSNotification*) notification//after reload, need this notification to recall the function
{
    //  model should call this when its done loading
    [self._tableView reloadData];
    _reloading = NO;
    [refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self._tableView];
    [self hudWasHidden:nil];
}

- (void) reloadAllevents:(NSNotification*) notification//after reload, need this notification to recall the function
{
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:HUD];
    [self.view bringSubviewToFront:HUD];
    HUD.delegate = self;
    HUD.labelText = @"Refreshing";
    [HUD show:YES];
    [HUD hide:YES afterDelay:30];
    
    [[appDelegate eventsManager] getAllEventsByFunction:1];///////////////reload data from server
    _reloading = YES;
}

#pragma mark - hide indicator
- (void) hideHUD:(NSNotification*) notification//after reload, need this notification to recall the function
{
    if (HUD)
    {     
        [HUD removeFromSuperview];
        HUD = nil;
    }
}

- (void)hudWasHidden:(MBProgressHUD *)hud {
    // Remove HUD from screen when the HUD was hidded
    [HUD removeFromSuperview];
	HUD = nil;
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
/////////////////////////////////////////////////////////////////////////////////////////////

@end
