//
//  AddEventsViewController.m
//  GurlsNightOut
//
//  Created by Calvin on 7/04/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AddEventsViewController.h"
#import "FriendsListViewController.h"
#import "PlaceListViewController.h"
#import "TimelineScrollViewController.h"
#import "FriendsListTableCell.h"

@interface AddEventsViewController ()

@end

@implementation AddEventsViewController
@synthesize mySegumentedControll;
@synthesize footerView;
@synthesize headerView;
@synthesize myMapView;
@synthesize lbEventName;
@synthesize lbEventTime;
@synthesize lbEventDetails;
@synthesize btEventIcon;
@synthesize btTimeline;
@synthesize btCancel;
@synthesize btDone;
@synthesize btEdit;
@synthesize btBack;
@synthesize lbEventStartTime;
@synthesize lbInvitedBy;
@synthesize ivBackground;
@synthesize _tableView;
@synthesize eventListController,friendsArray,locationName,locationAddress,locationLatitude,locationLongitude,eventIconDBID,currentLocation,function,eventName,eventDate,eventDBID,eventDetails,HUD,friendsArrayInEventDetails,addFriendsInEventDetailsFunction,isActivity;

#pragma mark - View life cycle
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void)viewWillAppear:(BOOL)animated
{
    ////////////////////////////////////////////////////////////////////////////////////////////////////init design
    [self.navigationController setNavigationBarHidden:YES];
    [self._tableView setBackgroundColor:[UIColor clearColor]];
    [self._tableView setFrame:CGRectMake(0,44, 320, 416)];

    if (isActivity) {
        btEdit.hidden=YES;
    }
    
    ////////////////////////////////////////////////////////////////////////////////////////////////////friends handle
    //friendsArrayInEventDetails is from previous friendlist view
    if (addFriendsInEventDetailsFunction==1) {
        //add friends
        NSMutableArray *arr=[[NSMutableArray alloc] init];
        for (int i=[self.friendsArrayInEventDetails count]-1; i<[self.friendsArrayInEventDetails count]; i--) {
            if ([[[self.friendsArrayInEventDetails objectAtIndex:i] objectForKey:@"userID"] objectForKey:@"userDBID"]!=nil) {//ID not nil
                if (![self isIncludingInEventDetailByNewArrayID:[[[self.friendsArrayInEventDetails objectAtIndex:i] objectForKey:@"userID"] objectForKey:@"userDBID"]]) {//not in friendArray
                    if ([[[[self.friendsArrayInEventDetails objectAtIndex:i] objectForKey:@"userID"] objectForKey:@"userDBID"] intValue]!=[[[[appDelegate myDetailsManager] userInfoDic]objectForKey:@"userDBID"] intValue]) {//not user themselves
                        /////////////////
                        NSMutableDictionary *dic=[[NSMutableDictionary alloc] init];
                        [dic setObject:[[self.friendsArrayInEventDetails objectAtIndex:i] objectForKey:@"userID"] forKey:@"userID"];
                        [dic setObject:[[NSNumber alloc] initWithInteger:1] forKey:@"isConfirm"];
                        [dic setObject:[NSString stringWithFormat:@"Member"] forKey:@"role"];
                        [arr addObject:dic];
                    }
                    
                }
            }
        }
        [self.friendsArrayInEventDetails removeAllObjects];
        [self.friendsArrayInEventDetails addObjectsFromArray:arr];
        //insert added friends into friends array
        [self reloadTableView:nil];
    }
    
    NSMutableArray *arr=[[NSMutableArray alloc] initWithArray:friendsArray];
    [newEventDic setObject:arr forKey:@"eventFriends"];

    ////////////////////////////////////////////////////////////////////////////////////////////////////init map
    if ([self locationLatitude]==0&&[self locationLongitude]==0) {
        [self._tableView setTableFooterView:nil];
    }
    else {
        [self._tableView setTableFooterView:footerView];
        NSArray *annotationArray=[myMapView annotations];
        for (int i=0; i<[annotationArray count]; i++) {
            if ([[annotationArray objectAtIndex:i] isKindOfClass:[PlaceAnnotation class]]) {
                [myMapView removeAnnotation:[annotationArray objectAtIndex:i]];
            }
        }
        
        PlaceAnnotation *pin=[[PlaceAnnotation alloc] init];
        pin.ID=9;
        pin.title=locationName;
        pin.subtitle=locationAddress;
        pin.latitude=[self locationLatitude];
        pin.longitude=[self locationLongitude];
        [pin getRegion];

        [myMapView setScrollEnabled:NO];
        [myMapView addAnnotation:pin];
        [myMapView setDelegate:self];
        [myMapView setRegion:[pin theRegion] animated:YES];
        [myMapView showsUserLocation];
    }
    ////////////////////////////////////////////////////////////////////////////////////////////////////
    if (function==2) {
        [self initHeaderView:nil];
        [self initTableViewArray:0];
    }

    [self._tableView reloadData];

}
-(Boolean) isIncludingInEventDetailByNewArrayID:(NSString *) userDBID
{
    for (int i=0; i<[self.friendsArray count]; i++) {
        if ([[[[self.friendsArray objectAtIndex:i] objectForKey:@"userID"] objectForKey:@"userDBID"] intValue] == [userDBID intValue])
        {
            return true;
        }
    }
    return false;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    bumpConn = [[BumpConnector alloc] init];
    iconDic=[[NSMutableDictionary alloc] init];
    tempFriendsArrayTableView=[[NSMutableArray alloc] init];
    appDelegate=(AppDelegate*)[[UIApplication sharedApplication] delegate];
    titleArray=[[NSMutableArray alloc] initWithObjects:@"Title:", @"Time:", @"Details:", nil];
    if (function==0) {
        [self goToAddEvent];
        
        friendsArray=[[NSMutableArray alloc] init];

        [self setTitle:[NSString stringWithFormat:@"Add Event"]];
        
        [self._tableView setTableHeaderView:nil];
        
        [ivBackground setImage:[UIImage imageNamed:@"AddEventBG.png"]];
    }
    else if(function==1){
        [self goToEditPageAndAddEvent];
        
        [self._tableView setTableHeaderView:nil];
    }
    else if (function==2) {
        [self goToDetailPage];
        [self setTitle:[NSString stringWithFormat:@"Event Details"]];
        
    }
    
    newEventDic=[[NSMutableDictionary alloc] init];
    [newEventDic setObject:[[NSMutableArray alloc] init] forKey:@"eventFriends"];
    
    actionSheetDate = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil];
	[actionSheetDate setActionSheetStyle:UIActionSheetStyleBlackTranslucent];
    pickerViewDate=[[UIDatePicker alloc] initWithFrame:CGRectMake(0, 44, 320, 0)];
    
    currentLocation = [[CLLocationManager alloc] init];//创建位置管理器
    currentLocation.desiredAccuracy=kCLLocationAccuracyBest;//指定需要的精度级别
    currentLocation.distanceFilter=100.0f;//设置距离筛选器
    [currentLocation startUpdatingLocation];//启动位置管理器
    
    mySegumentedControll.tintColor = [UIColor purpleColor];
    
    [[NSNotificationCenter defaultCenter]  addObserver:self selector:@selector(reloadTableView:) name:@"reload modify event friend tableview" object:nil];
    [[NSNotificationCenter defaultCenter]  addObserver:self selector:@selector(initHeaderView:) name:@"initHeaderView" object:nil];

    [self.navigationItem setLeftBarButtonItem:nil];
}
- (void) initHeaderView:(NSNotification*) notification
{
    if (notification!=nil) {
        self.eventIconDBID=[NSString stringWithFormat:@"%@",[notification object]];
        UIImage *eventImg = [appDelegate.photoManager getPhotoByPhotoDBID:self.eventIconDBID];
        [btEventIcon setImage:eventImg forState:UIControlStateNormal];
    }
    else
    {
        if ([self.eventIconDBID intValue]!=0) {
            UIImage *eventImg=[appDelegate.photoManager getPhotoByPhotoDBID:self.eventIconDBID];
            if (eventImg==nil) {
                [self loadPhotoFromServer:[self.eventIconDBID intValue]];
            }
            [btEventIcon setImage:eventImg forState:UIControlStateNormal];
        }
    }
    
    CGSize labelSize = { 228, 20000.0 };
    [lbEventName setBackgroundColor:[UIColor clearColor]];
    [lbEventName setFont:[UIFont boldSystemFontOfSize:20]];
    [lbEventName setTextColor:[UIColor colorWithRed:224/255.0 green:83/255.0 blue:172/255.0 alpha:1.0]];
    [lbEventName setShadowColor:[UIColor whiteColor]];
    [lbEventName setShadowOffset:CGSizeMake(0, 1)];
    [lbEventName setText:[self eventName]];
    [lbEventName setLineBreakMode:UILineBreakModeWordWrap];
    [lbEventName setNumberOfLines:0];
    CGSize textSize = [[lbEventName text] sizeWithFont:[UIFont boldSystemFontOfSize:20] constrainedToSize:labelSize lineBreakMode:UILineBreakModeWordWrap];
    [lbEventName setFrame:CGRectMake(140, 10, 172, textSize.height)];
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"EEE, dd MMM"];
    NSString *theDate = [dateFormat stringFromDate:eventDate];
    NSString *timeStr=[NSString stringWithFormat:@"Date: %@",theDate];
    [lbEventTime setBackgroundColor:[UIColor clearColor]];
    [lbEventTime setFont:[UIFont systemFontOfSize:16]];
    [lbEventTime setTextColor:[UIColor whiteColor]];
    [lbEventTime setShadowColor:[UIColor blackColor]];
    [lbEventTime setShadowOffset:CGSizeMake(0, 1)];
    [lbEventTime setText:timeStr];
    [lbEventTime setLineBreakMode:UILineBreakModeWordWrap];
    [lbEventTime setNumberOfLines:0];
    CGSize textSize1 = [[lbEventTime text] sizeWithFont:[UIFont systemFontOfSize:16] constrainedToSize:labelSize lineBreakMode:UILineBreakModeWordWrap];
    [lbEventTime setFrame:CGRectMake(140, lbEventName.frame.origin.y+lbEventName.frame.size.height+10, 180, textSize1.height)];

    
    NSDateFormatter *dateFormat1 = [[NSDateFormatter alloc] init];
    [dateFormat1 setDateFormat:@"HH:mm"];
    NSString *theDate1 = [dateFormat1 stringFromDate:eventDate];
    NSString *timeStr1=[NSString stringWithFormat:@"Time: %@",theDate1];
    [lbEventStartTime setBackgroundColor:[UIColor clearColor]];
    [lbEventStartTime setFont:[UIFont systemFontOfSize:16]];
    [lbEventStartTime setTextColor:[UIColor whiteColor]];
    [lbEventStartTime setShadowColor:[UIColor blackColor]];
    [lbEventStartTime setShadowOffset:CGSizeMake(0, 1)];
    [lbEventStartTime setText:timeStr1];
    [lbEventStartTime setLineBreakMode:UILineBreakModeWordWrap];
    [lbEventStartTime setNumberOfLines:0];
    CGSize textSize2 = [[lbEventStartTime text] sizeWithFont:[UIFont systemFontOfSize:16] constrainedToSize:labelSize lineBreakMode:UILineBreakModeWordWrap];
    [lbEventStartTime setFrame:CGRectMake(140, lbEventTime.frame.origin.y+lbEventTime.frame.size.height+10, 180, textSize2.height)];
    
    
    
    NSString *invitedBy;
    for (int i=0; i<[friendsArray count]; i++) {
        if ([[[friendsArray objectAtIndex:i] objectForKey:@"role"] isEqualToString:[NSString stringWithFormat:@"Organizer"]]) {
            invitedBy=[NSString stringWithFormat:@"Creator: %@",[[[friendsArray objectAtIndex:i] objectForKey:@"userID"] objectForKey:@"userName"]];
            break;
        }
    }
    
    [lbInvitedBy setBackgroundColor:[UIColor clearColor]];
    [lbInvitedBy setFont:[UIFont systemFontOfSize:16]];
    [lbInvitedBy setTextColor:[UIColor whiteColor]];
    [lbInvitedBy setShadowColor:[UIColor blackColor]];
    [lbInvitedBy setShadowOffset:CGSizeMake(0, 1)];
    [lbInvitedBy setText:invitedBy];
    [lbInvitedBy setLineBreakMode:UILineBreakModeWordWrap];
    [lbInvitedBy setNumberOfLines:0];
    CGSize textSize3 = [[lbInvitedBy text] sizeWithFont:[UIFont systemFontOfSize:17] constrainedToSize:labelSize lineBreakMode:UILineBreakModeWordWrap];
    [lbInvitedBy setFrame:CGRectMake(140, lbEventStartTime.frame.origin.y+lbEventStartTime.frame.size.height+10, 180, textSize3.height)];
    
    [btTimeline setFrame:CGRectMake(140, lbInvitedBy.frame.origin.y+lbInvitedBy.frame.size.height+10, 155, 40)];


    
    [lbEventDetails setBackgroundColor:[UIColor clearColor]];
    [lbEventDetails setFont:[UIFont systemFontOfSize:16]];
    [lbEventDetails setTextColor:[UIColor whiteColor]];
    [lbEventDetails setShadowColor:[UIColor blackColor]];
    [lbEventDetails setShadowOffset:CGSizeMake(0, 1)];
    [lbEventDetails setText:[self eventDetails]];
    [lbEventDetails setLineBreakMode:UILineBreakModeWordWrap];
    [lbEventDetails setNumberOfLines:0];
    CGSize textSize4 = [[lbEventDetails text] sizeWithFont:[UIFont systemFontOfSize:16] constrainedToSize:labelSize lineBreakMode:UILineBreakModeWordWrap];
    if (btTimeline.frame.origin.y+btTimeline.frame.size.height<btEventIcon.frame.origin.y+btEventIcon.frame.size.height) {
        [lbEventDetails setFrame:CGRectMake(10, btEventIcon.frame.origin.y+btEventIcon.frame.size.height+5, 300, textSize4.height)];
    }
    else {
        [lbEventDetails setFrame:CGRectMake(10, btTimeline.frame.origin.y+btTimeline.frame.size.height+5, 300, textSize4.height)];

    }
    
    [headerView setFrame:CGRectMake(0, 0, 320, lbEventDetails.frame.origin.y+lbEventDetails.frame.size.height+10)];

    [self._tableView setTableHeaderView:headerView];
    [self._tableView setFrame:CGRectMake(0,44, 320, 416)];
}
- (void)viewDidUnload
{
    [self setFooterView:nil];
    [self setMyMapView:nil];
    [self setHeaderView:nil];
    [self setLbEventName:nil];
    [self setLbEventTime:nil];
    [self setLbEventDetails:nil];
    [self setBtEventIcon:nil];
    [self setBtTimeline:nil];
    [self set_tableView:nil];
    [self setBtCancel:nil];
    [self setBtDone:nil];
    [self setBtEdit:nil];
    [self setBtBack:nil];
    [self setMySegumentedControll:nil];
    [self setLbEventStartTime:nil];
    [self setLbInvitedBy:nil];
    [self setIvBackground:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}
- (void) reloadTableView:(NSNotification*) notification//after reload, need this notification to recall the function
{
    [friendsArray removeAllObjects];
    [friendsArray addObjectsFromArray:[[[appDelegate eventsManager] getEventDictionaryByEventID:[NSString stringWithFormat:@"%d",[self eventDBID]]] objectForKey:@"eventFriends"]];
    for (int i=0; i<[friendsArrayInEventDetails count]; i++) {
        [friendsArray insertObject:[friendsArrayInEventDetails objectAtIndex:i] atIndex:1];
    }

    [self._tableView reloadData];
}
#pragma mark - Table view data source 

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    if (function==2) {
        return 2;
    }
    else if (function==0||function==1) {
        return 3;
    }
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if (function==2) {
        if (section==0){
            return [tempFriendsArrayTableView count];
        }
        else if (section==1) {
            return 1;
        }
    }
    else if (function==0||function==1) {
        if (section==0){
            return [titleArray count];
        }
        else if (section==1){
            return [friendsArray count]+1;
        }
        else if (section==2) {
            return 1;
        }
    }

    return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (function==0||function==1) {//add event
        if ([indexPath section]==1) {
            if ([indexPath row]!=[friendsArray count]) {
                return 65;
            }
        }
    }
    else if (function==2) {//event detail display
        if ([indexPath section]==0) {
            return 65;
        }
    }
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    static NSString *CellIdentifier1 = @"Cell1";
    static NSString *CellIdentifierLabel = @"CellLabel";
    static NSString *CellIdentifierAddFriends = @"cellAddFriend";
    
    if (function==2) {
        if([indexPath section]==0){
            NSString *content=[NSString stringWithFormat:@""];
            content=[[[tempFriendsArrayTableView objectAtIndex:[indexPath row]] objectForKey:@"userID"]objectForKey:@"userName"];
            FriendsListTableCell *cell=(FriendsListTableCell*)[self friendCell:content IdentifyCell:CellIdentifier1 IndexPath:indexPath];
//            UIImageView *cellBgImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"CellBackground.png"]];
            UIImageView *cellBgImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"abcd.png"]];
            [cell setBackgroundView:cellBgImageView];
            [self setCellSelectedBackgroundImage:nil TableViewCell:cell];
            return cell;
        }
        else if([indexPath section]==1){
            AddFunctionLabelCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifierLabel];
//            cell.lbTitle.text=[NSString stringWithFormat:@"Location:"];
            cell.lbTitle.hidden=YES;

//            cell.lbContent.frame=CGRectMake(183, 22, 280, 40);

            if ([locationName length]!=0) {
                cell.lbContent.frame=CGRectMake(20, 0, 280, 40);
                cell.lbContent.text=locationName;
                cell.lbContent.textColor=[UIColor whiteColor];
            }
            else {
                cell.lbContent.text=[NSString stringWithFormat:@"Press edit above to add"];
                cell.lbContent.textColor=[UIColor grayColor];
            }
            cell.backgroundColor=[UIColor clearColor];
//            UIImageView *cellBgImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"CellBackground.png"]];
            UIImageView *cellBgImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"abcd.png"]];
            [cell setBackgroundView:cellBgImageView];
            [self setCellSelectedBackgroundImage:nil TableViewCell:cell];
            return cell;
        }

    }
    else if (function==0||function==1) {
        if ([indexPath section]==0) {
            if ([indexPath row]==0||[indexPath row]==2) {
                AddFunctionCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                cell.lbTitle.text=[titleArray objectAtIndex:[indexPath row]];
                cell.lbTitle.font=[UIFont boldSystemFontOfSize:17];
                cell.tfContent.tag=[indexPath section]+[indexPath row];
                cell.tfContent.delegate=self;
                if ([indexPath row]==0) {
                    if (eventName!=nil) {
                        cell.tfContent.text=eventName;
                        cell.tfContent.textColor=[UIColor whiteColor];////////////////
                        cell.tfContent.font=[UIFont systemFontOfSize:17];
                    }
                    else {
                        cell.tfContent.text=[NSString stringWithFormat:@"Touch to edit"];
                        cell.tfContent.textColor=[UIColor grayColor];
                        cell.tfContent.font=[UIFont systemFontOfSize:17];
                    }
                }
                else if([indexPath row]==2){
                    if (eventDetails!=nil) {
                        cell.tfContent.text=eventDetails;
                        cell.tfContent.textColor=[UIColor whiteColor];///////////////
                        cell.tfContent.font=[UIFont systemFontOfSize:17];
                    }
                    else {
                        cell.tfContent.text=[NSString stringWithFormat:@"Touch to edit"];
                        cell.tfContent.textColor=[UIColor grayColor];
                        cell.tfContent.font=[UIFont systemFontOfSize:17];
                    }
                }
                
                cell.tfContent.enabled=YES;
                //////////////////////
                cell.backgroundColor=[UIColor clearColor];
                cell.lbTitle.textColor=[UIColor whiteColor];
//                UIImageView *cellBgImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"CellBackground.png"]];
                UIImageView *cellBgImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"abcd.png"]];
                [cell setBackgroundView:cellBgImageView];
                [self setCellSelectedBackgroundImage:nil TableViewCell:cell];

                //////////////////////
                return cell;
            }
            else if([indexPath row]==1)
            {
                AddFunctionLabelCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifierLabel];
                if (cell==nil) {
                    cell=[[AddFunctionLabelCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifierLabel];
                }
                cell.lbTitle.text=[titleArray objectAtIndex:[indexPath row]];
                cell.lbTitle.font=[UIFont boldSystemFontOfSize:17];
                cell.lbTitle.hidden=NO;
                cell.lbContent.frame=CGRectMake(85, 0, 280, 40);
                
                if (eventDate==nil) {
                    cell.lbContent.text=[NSString stringWithFormat:@"Touch to edit"];
                    cell.lbContent.textColor=[UIColor grayColor];/////////////////////
                }
                else {
                    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
                    [dateFormat setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
                    NSString *theDate = [dateFormat stringFromDate:eventDate];
                    cell.lbContent.text=theDate;
                    cell.lbContent.textColor=[UIColor whiteColor];////////////////////
                }
                
                ///////////////////////////////////////
                cell.lbTitle.textColor=[UIColor whiteColor];
                cell.backgroundColor=[UIColor clearColor];
//                UIImageView *cellBgImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"CellBackground.png"]];
                UIImageView *cellBgImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"abcd.png"]];

                [cell setBackgroundView:cellBgImageView];
                [self setCellSelectedBackgroundImage:nil TableViewCell:cell];

                /////////////////////////////////////
                return cell;
            }
            
        }
        else if([indexPath section]==1){
            if ([friendsArray count]!=0) {
                if ([indexPath row]!=[friendsArray count]) {
                    NSString *content=[NSString stringWithFormat:@""];
                    
                    content=[[[friendsArray objectAtIndex:[indexPath row]] objectForKey:@"userID"]objectForKey:@"userName"];
                    FriendsListTableCell *cell=(FriendsListTableCell*)[self friendCell:content IdentifyCell:CellIdentifier1 IndexPath:indexPath];
                    cell.lbSubTitle.hidden=NO;
                    
                    ////////////////////////////
                    //                UIImageView *cellBgImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"CellBackground.png"]];
                    UIImageView *cellBgImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"abcd.png"]];
                    
                    [cell setBackgroundView:cellBgImageView];
                    cell.backgroundColor=[UIColor clearColor];
                    ////////////////////////////
                    return cell;
                }
                else {//////////add friends
                    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifierAddFriends];
                    //                cell.textLabel.text=[[friendsArray objectAtIndex:[indexPath row]] objectForKey:@"userName"];
                    cell.textLabel.textAlignment=UITextAlignmentCenter;
                    
                    ////////////////////////////
                    //                UIImageView *cellBgImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"CellBackground.png"]];
                    UIImageView *cellBgImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"abcd.png"]];
                    
                    [cell setBackgroundView:cellBgImageView];
                    cell.textLabel.textColor=[UIColor whiteColor];
                    cell.backgroundColor=[UIColor clearColor];
                    ////////////////////////////
                    [self setCellSelectedBackgroundImage:nil TableViewCell:cell];

                    return cell;
                }
            }
            else
            {
                UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifierAddFriends];
                //                cell.textLabel.text=[[friendsArray objectAtIndex:[indexPath row]] objectForKey:@"userName"];
                cell.textLabel.textAlignment=UITextAlignmentCenter;
                
                ////////////////////////////
                //                UIImageView *cellBgImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"CellBackground.png"]];
                UIImageView *cellBgImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"abcd.png"]];
                
                [cell setBackgroundView:cellBgImageView];
                cell.textLabel.textColor=[UIColor whiteColor];
                cell.backgroundColor=[UIColor clearColor];
                
                [self setCellSelectedBackgroundImage:nil TableViewCell:cell];

                ////////////////////////////

                return cell;
            }
            
        }
        else if([indexPath section]==2){
            AddFunctionLabelCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifierLabel];
            cell.lbTitle.hidden=YES;
            if ([locationName length]!=0) {
                cell.lbContent.frame=CGRectMake(20, 0, 280, 40);
                cell.lbContent.text=locationName;
                cell.lbContent.textColor=[UIColor whiteColor];
            }
            else {
                cell.lbContent.text=[NSString stringWithFormat:@"Touch to edit"];
                cell.lbContent.textColor=[UIColor grayColor];
            }
            cell.backgroundColor=[UIColor clearColor];
//            UIImageView *cellBgImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"CellBackground.png"]];
            UIImageView *cellBgImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"abcd.png"]];

            [cell setBackgroundView:cellBgImageView];
            [self setCellSelectedBackgroundImage:nil TableViewCell:cell];
            return cell;
        }

    }
    
    
    
    
    return nil;
}
-(UITableViewCell *) friendCell:(NSString *) content IdentifyCell:(NSString *) CellIdentifierLabel IndexPath:(NSIndexPath*)indexPath
{
    if (function==2) {
        FriendsListTableCell *cell = [self._tableView dequeueReusableCellWithIdentifier:CellIdentifierLabel];
        cell.lbTitle.text=[[[tempFriendsArrayTableView objectAtIndex:[indexPath row]] objectForKey:@"userID"]objectForKey:@"userName"];
        UIImage *checkImg;
        if ([[[tempFriendsArrayTableView objectAtIndex:[indexPath row]] objectForKey:@"isConfirm"] intValue]==0) {
            checkImg=[UIImage imageNamed:@"tick.png"];
        }
        else if ([[[tempFriendsArrayTableView objectAtIndex:[indexPath row]] objectForKey:@"isConfirm"] intValue]==2){
            checkImg=[UIImage imageNamed:@"cross.png"];
        }
        else if ([[[tempFriendsArrayTableView objectAtIndex:[indexPath row]] objectForKey:@"isConfirm"] intValue]==1)
        {
            checkImg=[UIImage imageNamed:@"question.png"];
        }
        cell.checkIcon.image=checkImg;
        cell.checkIcon.hidden=NO;

        cell.lbTitle.font=[UIFont boldSystemFontOfSize:18];
        cell.lbTitle.textColor=[UIColor whiteColor];
        cell.lbTitle.frame=CGRectMake(83, 21, 189, 21);
        
        cell.accessoryType=UITableViewCellAccessoryNone;
        cell.lbSubTitle.text=[NSString stringWithFormat:@""];
        cell.lbSubTitle.textColor=[UIColor grayColor];
        cell.lbSubTitle.hidden=YES;

        NSLog(@"%@",[tempFriendsArrayTableView objectAtIndex:[indexPath row]]);
        if ([[[[tempFriendsArrayTableView objectAtIndex:[indexPath row]] objectForKey:@"userID"]objectForKey:@"photosDBID"] intValue]!=0) {
            if ([[[[appDelegate photoManager] photoDic] objectForKey:[NSString stringWithFormat:@"id%@",[[[tempFriendsArrayTableView objectAtIndex:[indexPath row]] objectForKey:@"userID"]objectForKey:@"photosDBID"]]] objectForKey:@"path"]!=0) {
                if ([iconDic objectForKey:[NSString stringWithFormat:@"id%@",[[[tempFriendsArrayTableView objectAtIndex:[indexPath row]] objectForKey:@"userID"]objectForKey:@"photosDBID"]]]!=nil) {
                    UIImage *img=[iconDic objectForKey:[NSString stringWithFormat:@"id%@",[[[tempFriendsArrayTableView objectAtIndex:[indexPath row]] objectForKey:@"userID"]objectForKey:@"photosDBID"]]];
                    cell.ivIcon.image=img;
                }
                else {
                    UIImage *img=[[appDelegate photoManager] getPhotoByPhotoDBID:[[[tempFriendsArrayTableView objectAtIndex:[indexPath row]] objectForKey:@"userID"]objectForKey:@"photosDBID"]];
                    [iconDic setObject:img forKey:[NSString stringWithFormat:@"id%@",[[[tempFriendsArrayTableView objectAtIndex:[indexPath row]] objectForKey:@"userID"]objectForKey:@"photosDBID"]]];
                    cell.ivIcon.image=img;
                }
                
            }
            else {
                //load icon
                if ([[[appDelegate photoManager] photoDic] objectForKey:[NSString stringWithFormat:@"id%@", [[[tempFriendsArrayTableView objectAtIndex:[indexPath row]] objectForKey:@"userID"]objectForKey:@"photosDBID"]]]==nil) {
                    [self loadPhotoFromServer:[[[[tempFriendsArrayTableView objectAtIndex:[indexPath row]] objectForKey:@"userID"]objectForKey:@"photosDBID"] intValue]];
                }
            }
        }
        else {
            UIImage *img=[UIImage imageNamed:@"Persondot.png"];
            cell.ivIcon.image=img;
        }
        cell.ivIcon.layer.masksToBounds = YES; //没这句话它圆不起来
        cell.ivIcon.layer.cornerRadius = 5.0; //设置图片圆角的尺度。
        cell.backgroundColor=[UIColor clearColor];

        [self setCellSelectedBackgroundImage:nil TableViewCell:cell];
        return cell;
    }
    else
    {
        FriendsListTableCell *cell = [self._tableView dequeueReusableCellWithIdentifier:CellIdentifierLabel];
        cell.lbTitle.text=[[[friendsArray objectAtIndex:[indexPath row]] objectForKey:@"userID"]objectForKey:@"userName"];
        cell.lbTitle.textColor=[UIColor whiteColor];
        cell.lbTitle.font=[UIFont boldSystemFontOfSize:18];
        cell.lbTitle.frame=CGRectMake(83, 6, 189, 21);

        cell.accessoryType=UITableViewCellAccessoryNone;
        cell.lbSubTitle.text=[NSString stringWithFormat:@""];
        cell.lbSubTitle.textColor=[UIColor grayColor];
        cell.checkIcon.hidden=YES;
        
        NSLog(@"%@",[friendsArray objectAtIndex:[indexPath row]]);
        if ([[[[friendsArray objectAtIndex:[indexPath row]] objectForKey:@"userID"]objectForKey:@"photosDBID"] intValue]!=0) {
            if ([[[[appDelegate photoManager] photoDic] objectForKey:[NSString stringWithFormat:@"id%@",[[[friendsArray objectAtIndex:[indexPath row]] objectForKey:@"userID"]objectForKey:@"photosDBID"]]] objectForKey:@"path"]!=0) {
                if ([iconDic objectForKey:[NSString stringWithFormat:@"id%@",[[[friendsArray objectAtIndex:[indexPath row]] objectForKey:@"userID"]objectForKey:@"photosDBID"]]]!=nil) {
                    UIImage *img=[iconDic objectForKey:[NSString stringWithFormat:@"id%@",[[[friendsArray objectAtIndex:[indexPath row]] objectForKey:@"userID"]objectForKey:@"photosDBID"]]];
                    cell.ivIcon.image=img;
                }
                else {
                    UIImage *img=[[appDelegate photoManager] getPhotoByPhotoDBID:[[[friendsArray objectAtIndex:[indexPath row]] objectForKey:@"userID"]objectForKey:@"photosDBID"]];
                    [iconDic setObject:img forKey:[NSString stringWithFormat:@"id%@",[[[friendsArray objectAtIndex:[indexPath row]] objectForKey:@"userID"]objectForKey:@"photosDBID"]]];
                    cell.ivIcon.image=img;
                }
                
            }
            else {
                //load icon
                if ([[[appDelegate photoManager] photoDic] objectForKey:[NSString stringWithFormat:@"id%@", [[[friendsArray objectAtIndex:[indexPath row]] objectForKey:@"userID"]objectForKey:@"photosDBID"]]]==nil) {
                    [self loadPhotoFromServer:[[[[friendsArray objectAtIndex:[indexPath row]] objectForKey:@"userID"]objectForKey:@"photosDBID"] intValue]];
                }
            }
        }
        else {
            UIImage *img=[UIImage imageNamed:@"Persondot.png"];
            cell.ivIcon.image=img;
        } 
        cell.backgroundColor=[UIColor clearColor];
        [self setCellSelectedBackgroundImage:nil TableViewCell:cell];

        return cell;
    }
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *sectionHeaderView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 30)];
    UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 30)];
    [view setBackgroundColor:[UIColor colorWithRed:126/255.0 green:34/255.0 blue:132/255.0 alpha:1.0]];
    
    UILabel *title=[[UILabel alloc] initWithFrame:CGRectMake(20, 0, 280, 30)];
    [title setFont:[UIFont boldSystemFontOfSize:18]];
    title.textColor=[UIColor whiteColor];
    title.backgroundColor=[UIColor clearColor];
    
    [view addSubview:title];
    if (function==2) {
        if(section==0)
        {
            title.text=[NSString stringWithFormat:@"Guests"];
            [mySegumentedControll setFrame:CGRectMake(20, 40, 280, 40)];
            [sectionHeaderView addSubview:mySegumentedControll];
            [sectionHeaderView setFrame:CGRectMake(0, 0, 320, 70)];
            
            UIButton *bt=[UIButton buttonWithType:UIButtonTypeCustom];
            [bt setFrame:CGRectMake(270, 0, 30, 30)];
            [bt setImage:[UIImage imageNamed:@"add friend button.png"] forState:UIControlStateNormal];
            [bt addTarget:self action:@selector(bumpAction) forControlEvents:UIControlEventTouchDown];

            [view addSubview:bt];

        }
        else if(section==1)
        {
            title.text = [NSString stringWithFormat:@"Location"];
        }
    }
    else if (function==0||function==1) {
        if (section==0) {
            title.text = [NSString stringWithFormat:@"Event Details"];
        }
        else if(section==1)
        {
            title.text = [NSString stringWithFormat:@"Guests"];
        }
        else if(section==2)
        {
            title.text = [NSString stringWithFormat:@"Location"];
        }
    }
    [sectionHeaderView addSubview:view];
    return sectionHeaderView;
}
- (void)setCellSelectedBackgroundImage:(NSString*)imageName TableViewCell:(UITableViewCell*) tableViewCell
{   
    UIView *imageView= [[UIView alloc] initWithFrame:tableViewCell.frame];
    imageView.backgroundColor = [UIColor purpleColor];
    tableViewCell.selectedBackgroundView = imageView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (function==2) {
        if(section==0)
        {
            return 90;
        }
    }
    return 40;
}

- (void)tableView:(UITableView *)tableViewa commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
	//remove friend
    if ([indexPath section]==1&&[indexPath row]!=[friendsArray count]) {
        [friendsArray removeObject:[friendsArray objectAtIndex:[indexPath row]]];
        [self._tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }

}
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([indexPath section]==1&&[indexPath row]!=[friendsArray count]) {
        return UITableViewCellEditingStyleDelete;
    }
    else {
        return UITableViewCellEditingStyleNone;
    }
    return 0;
}
#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (function==1|| function==0) {
        if ([indexPath section]==0) {
            if ([indexPath row]==1) {
                actionSheetFunction=0;
                [self popPicker];
            }
        }
        else if ([indexPath section]==1) {
            if ([friendsArray count]!=0) {
                if ([indexPath row]==[friendsArray count]) {
                    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                                  initWithTitle:@"Add Friends by"         //Title
                                                  delegate:self                  //delegate
                                                  cancelButtonTitle:@"Cancel"
                                                  destructiveButtonTitle:nil
                                                  otherButtonTitles:@"Bump", @"Friends List", nil];  //button
                    //    [actionSheet showInView:self.tabBarController.view];/////////////////////////////////////////////////////////interesting,not in tabbar has somge problem
                    [actionSheet setTag:1];
                    [actionSheet showInView:self._tableView];/////////////////////////////////////////////////////////interesting,not in tabbar has somge problem
                }
            }
            else
            {
                UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                              initWithTitle:@"Add Friends by"         //Title
                                              delegate:self                  //delegate
                                              cancelButtonTitle:@"Cancel"
                                              destructiveButtonTitle:nil
                                              otherButtonTitles:@"Bump", @"Friends List", nil];  //button
                //    [actionSheet showInView:self.tabBarController.view];/////////////////////////////////////////////////////////interesting,not in tabbar has somge problem
                [actionSheet setTag:1];
                [actionSheet showInView:self._tableView];/////////////////////////////////////////////////////////interesting,not in tabbar has somge problem
            }

        }
        else if ([indexPath section]==2) {
            if ([indexPath row]==0) {

                
                UINavigationController *nav=[self.storyboard instantiateViewControllerWithIdentifier:@"PlaceListViewControllerNav"];
                
                PlaceListViewController *placeListViewController=(PlaceListViewController*)[nav topViewController];
                [placeListViewController setCurrentLocation:currentLocation];
                [placeListViewController setAddEventsViewController:self];
                [placeListViewController setFunction:0];
                
                [self.navigationController presentModalViewController:nav animated:YES];
            }
        }
    }
    else{
        if ([indexPath section]==0) {
            if ([indexPath row]==0) {
                if (!isActivity)
                {
                    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                                  initWithTitle:@"Join or not"         //Title
                                                  delegate:self                  //delegate
                                                  cancelButtonTitle:@"Cancel"
                                                  destructiveButtonTitle:nil
                                                  otherButtonTitles:@"Join", @"Maybe",@"Declined", nil];  //button
                    //    [actionSheet showInView:self.tabBarController.view];/////////////////////////////////////////////////////////interesting,not in tabbar has somge problem
                    [actionSheet setTag:0];
                    [actionSheet showInView:self._tableView];/////////////////////////////////////////////////////////interesting,not in tabbar has somge problem
                }

            }
        }
    }

    [self._tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

#pragma mark - transfer between display and edit function
-(void) goToDetailPage
{
    [btDone setEnabled:NO];
    [btEdit setEnabled:YES];
    [btDone setHidden:YES];
    [btEdit setHidden:NO];
    
    [btCancel setEnabled:NO];
    [btBack setEnabled:YES];
    [btCancel setHidden:YES];
    [btBack setHidden:NO];
}
-(void) goToEditPageAndAddEvent
{
    [btDone setEnabled:YES];
    [btEdit setEnabled:NO];
    [btDone setHidden:NO];
    [btEdit setHidden:YES];
    
    [btCancel setEnabled:YES];
    [btBack setEnabled:NO];
    [btCancel setHidden:NO];
    [btBack setHidden:YES];
}
-(void) goToAddEvent
{
    [btDone setEnabled:YES];
    [btEdit setEnabled:NO];
    [btDone setHidden:NO];
    [btEdit setHidden:YES];
    
    [btCancel setEnabled:NO];
    [btBack setEnabled:YES];
    [btCancel setHidden:YES];
    [btBack setHidden:NO]; 
}


#pragma mark - reload friend table view according to the segment control
-(void) initTableViewArray:(NSInteger) sortFunction
{
    //sortFunction 0=all, 1=accept, 2=maybe, 3=declined
    //1=maybe,0=join,2=declined
    if (sortFunction==0) {
        [tempFriendsArrayTableView removeAllObjects];
        [tempFriendsArrayTableView addObjectsFromArray:friendsArray];
    }
    else if (sortFunction==1)
    {
        [tempFriendsArrayTableView removeAllObjects];
        for (int i=0; i<[friendsArray count]; i++) {
            if ([[[friendsArray objectAtIndex:i] objectForKey:@"isConfirm"] intValue]==0) {
                [tempFriendsArrayTableView addObject:[friendsArray objectAtIndex:i]];
            }
        }
    }
    else if (sortFunction==2)
    {
        [tempFriendsArrayTableView removeAllObjects];
        for (int i=0; i<[friendsArray count]; i++) {
            if ([[[friendsArray objectAtIndex:i] objectForKey:@"isConfirm"] intValue]==1) {
                [tempFriendsArrayTableView addObject:[friendsArray objectAtIndex:i]];
            }
        }
    }
    else if(sortFunction==3)
    {
        [tempFriendsArrayTableView removeAllObjects];
        for (int i=0; i<[friendsArray count]; i++) {
            if ([[[friendsArray objectAtIndex:i] objectForKey:@"isConfirm"] intValue]==2) {
                [tempFriendsArrayTableView addObject:[friendsArray objectAtIndex:i]];
            }
        }
    }
    
    NSSortDescriptor *sd=[NSSortDescriptor sortDescriptorWithKey:@"isConfirm" ascending:YES];
    [tempFriendsArrayTableView sortUsingDescriptors:[NSArray arrayWithObject:sd]];
    
    NSMutableDictionary *dic=[[NSMutableDictionary alloc] init];
    NSString *index=[NSString stringWithFormat:@"NoUser"];
    for (int i=0; i<[tempFriendsArrayTableView count]; i++) {
        if ([[[[tempFriendsArrayTableView objectAtIndex:i] objectForKey:@"userID"] objectForKey:@"userDBID"] intValue]==[[[[appDelegate myDetailsManager] userInfoDic]objectForKey:@"userDBID"] intValue]) {
            dic=[[tempFriendsArrayTableView objectAtIndex:i] copy];
            index=[NSString stringWithFormat:@"%d",i];
        }
    }
    if (![index isEqualToString:[NSString stringWithFormat:@"NoUser"]]) {
        [tempFriendsArrayTableView removeObjectAtIndex:[index intValue]];
        [tempFriendsArrayTableView insertObject:dic atIndex:0];
    }

}

#pragma mark - actionSheet delegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (actionSheet.tag==0) {//////////////////////table View first row, select whether join, declined or maybe
        if (buttonIndex!=3) {
            for (int i=0; i<[friendsArray count]; i++) {
                if ([[[[self.friendsArray objectAtIndex:i] objectForKey:@"userID"] objectForKey:@"userDBID"] intValue]==[[appDelegate.myDetailsManager.userInfoDic objectForKey:@"userDBID"] intValue]) {
                    [[self.friendsArray objectAtIndex:i] setObject:[[NSNumber alloc] initWithInteger:buttonIndex] forKey:@"isConfirm"];
                    
                }
            }
            [self initTableViewArray:0];
            [self._tableView reloadData];
            Kumulos *k=[[Kumulos alloc] init];
            [k setDelegate:self];
            [k isAttentEventWithEventPeopleDBID:[[[tempFriendsArrayTableView objectAtIndex:0] objectForKey:@"eventPeopleDBID"] intValue] andIsConfirm:buttonIndex];
        }
    }
    else
    {/////////////////////////////////////////invite friend by selection, Bump or list
        if (buttonIndex==1) {/////////////////Friend list
            
            FriendsListViewController *friendsListViewController=[self.storyboard instantiateViewControllerWithIdentifier:@"FriendsListController"];
            friendsListViewController.title=@"Invite Friends";
            [friendsListViewController setAddEventsViewController:self];
            if (function==0) {////0=add event,1=event Details edit
                [friendsListViewController setFriendFunction:1];
                //                NSMutableArray *arr=[[NSMutableArray alloc] initWithArray:friendsArray];
                [friendsListViewController setEventFriends:friendsArray];
            }
            else if (function==1) {
                [friendsListViewController setFriendFunction:3];
                NSMutableArray *arr=[[NSMutableArray alloc] initWithArray:friendsArray];
                [friendsListViewController setEventFriends:arr];
            }
            [self.navigationController pushViewController:friendsListViewController animated:YES];
        }
        else if(buttonIndex==0){/////////////////Bump
            [self bumpAction];

        }
    }
    
}
-(void) bumpAction
{
    [bumpConn setAddEventsViewController:self];
    [bumpConn setEventID:[self eventDBID]];
    [bumpConn setFunction:3];
    [bumpConn startBump];
    [bumpConn sendDetails];
}
#pragma mark - button actions
- (IBAction)doneButtonAction:(id)sender {
    if (function==0) {//add event
        //////////////////////////////////////////////////////////////////////////////////////////////create event
        NSIndexPath *indexTableViewTitle=[NSIndexPath indexPathForRow:0 inSection:0];
        AddFunctionCell *addCellTitle=(AddFunctionCell*)[self._tableView cellForRowAtIndexPath:indexTableViewTitle];
        
        NSIndexPath *indexTableViewDetails=[NSIndexPath indexPathForRow:2 inSection:0];
        AddFunctionCell *addCellDetails=(AddFunctionCell*)[self._tableView cellForRowAtIndexPath:indexTableViewDetails];
        
        if (eventDate!=nil) {
            //////////////////////////////////////////////////////////////////////////////////////////////MBProgressHUD
            HUD = [[MBProgressHUD alloc] initWithView:self.view];
            [self.view addSubview:HUD];
            [self.view bringSubviewToFront:HUD];
            HUD.delegate = self;
            HUD.labelText = @"Creating";
            [HUD show:YES];
            [HUD hide:YES afterDelay:30];
            
            Kumulos *k=[[Kumulos alloc] init];
            [k setDelegate:self];
            [k createEventsWithEventName:addCellTitle.tfContent.text andEventTime:eventDate andStartTime:nil andEndTime:nil andIsValid:YES andLocationName:[self locationName] andLocationAddress:[self locationAddress] andLocationLatitude:[self locationLatitude] andLocationLongitude:[self locationLongitude] andEventDetails:addCellDetails.tfContent.text andEventIconDBID:0];
        }
        else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Time Empty" message:@"Please select a time for this event" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        }
    }
    else if (function==1) {//edit
        //////////////////////////////////////////////////////////////////////////////////////////////MBProgressHUD
        HUD = [[MBProgressHUD alloc] initWithView:self.view];
        [self.view addSubview:HUD];
        [self.view bringSubviewToFront:HUD];
        HUD.delegate = self;
        HUD.labelText = @"Editing";
        [HUD show:YES];
        [HUD hide:YES afterDelay:30];

        //////////////////////////////////////////////////////////////////////////////////////////////invite Friends
        if (addFriendsInEventDetailsFunction==1) {
            //add friends
            for (int i=[self.friendsArrayInEventDetails count]-1; i<[self.friendsArrayInEventDetails count]; i--) {
                if ([[[self.friendsArrayInEventDetails objectAtIndex:i] objectForKey:@"userID"] objectForKey:@"userDBID"]!=nil) {
                    if ([[[[self.friendsArrayInEventDetails objectAtIndex:i] objectForKey:@"userID"] objectForKey:@"userDBID"] intValue]!=[[[[appDelegate myDetailsManager] userInfoDic]objectForKey:@"userDBID"] intValue]) {
                        /////////////////
                        Kumulos *k=[[Kumulos alloc] init];
                        [k setDelegate:self];
                        [k inviteFriendsWithRole:@"Menber" andIsConfirm:1 andIsHome:0 andEventID:[self eventDBID] andUserID:[[[[self.friendsArrayInEventDetails objectAtIndex:i] objectForKey:@"userID"] objectForKey:@"userDBID"] intValue]];
                    }
                }
            }
            [self.friendsArrayInEventDetails removeAllObjects];
            addFriendsInEventDetailsFunction=0;
        }
        
        //////////////////////////////////////////////////////////////////////////////////////////////go back to display function
        [self goToDetailPage];
        function=2;
        
        //////////////////////////////////////////////////////////////////////////////////////////////edit event details
        if (eventDate!=nil) {
            NSIndexPath *indexTableViewTitle=[NSIndexPath indexPathForRow:0 inSection:0];
            AddFunctionCell *addCellTitle=(AddFunctionCell*)[self._tableView cellForRowAtIndexPath:indexTableViewTitle];
            
            NSIndexPath *indexTableViewDetails=[NSIndexPath indexPathForRow:2 inSection:0];
            AddFunctionCell *addCellDetails=(AddFunctionCell*)[self._tableView cellForRowAtIndexPath:indexTableViewDetails];
            
            eventName=[NSString stringWithFormat:@"%@",addCellTitle.tfContent.text];
            eventDetails=[NSString stringWithFormat:@"%@",addCellDetails.tfContent.text];
            
            Kumulos *k=[[Kumulos alloc] init];
            [k setDelegate:self];
            [k editEventWithEventName:[[NSString alloc] initWithFormat:@"%@", addCellTitle.tfContent.text] andEventTime:eventDate andLocationName:[self locationName] andLocationAddress:[self locationAddress] andLocationLatitude:[self locationLatitude] andLocationLongitude:[self locationLongitude] andEventDetails:[[NSString alloc] initWithFormat:@"%@",addCellDetails.tfContent.text] andEventDBID:[self eventDBID]];
            
            
        }
        else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Time Empty" message:@"Please select a time for this event" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        }
        
        //////////////////////////////////////////////////////////////////////////////////////////////init in display view, such as reload tableview data and table
        self.eventListController.function=1;
        [self initHeaderView:nil];
        [self._tableView setTableHeaderView:headerView];
        [self initTableViewArray:0];
        [self._tableView reloadData];
        
    }
    
}

- (IBAction)sgmAction:(id)sender {
    UISegmentedControl *segumentControl=(UISegmentedControl*)sender;
    [self initTableViewArray:segumentControl.selectedSegmentIndex];
    [self._tableView reloadData];
    
}
- (IBAction)editButtonAction:(id)sender {
    
    [self goToEditPageAndAddEvent];
    [self._tableView setTableHeaderView:nil];
    function=1;
    
    [self._tableView reloadData];
}

- (IBAction)backButtonAction:(id)sender {
    if (function==0) {//add event
        [self.navigationController popViewControllerAnimated:YES];
    }
    else if (function==2) {
        function=1;
        [self.navigationController popViewControllerAnimated:YES];
    }
}
- (IBAction)cancelButtonAction:(id)sender {
    [self goToDetailPage];
    
    function=2;
    [self initHeaderView:nil];
    
    [self._tableView reloadData];
    
}

- (IBAction)btTimelineAction:(id)sender {
    TimelineScrollViewController *timelineScrollViewController=[self.storyboard instantiateViewControllerWithIdentifier:@"TimelineScrollViewController"];
    timelineScrollViewController.eventID=[NSString stringWithFormat:@"%d",[self eventDBID]];
    timelineScrollViewController.friendsList=[self friendsArray];
    timelineScrollViewController.isActivity=self.isActivity;
    [self.navigationController presentModalViewController:timelineScrollViewController animated:YES];

}
- (IBAction)btEventIconAction:(id)sender {
    
}
- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"addPhotoSegueForEvent"]) {
        NSUserDefaults *userPreferences = [NSUserDefaults standardUserDefaults];
        [userPreferences setObject:[NSString stringWithFormat:@"2"] forKey:@"addPhotosFunction"];
        [userPreferences setObject:[NSNumber numberWithInteger:[self eventDBID]] forKey:@"addPhotoByEventDBID"];
        [userPreferences synchronize];
    }
}
#pragma mark - load photo from server
- (void) loadPhotoFromServer:(int) photoDBID
{            
    Kumulos *k=[[Kumulos alloc] init];
    [k setDelegate:self];
    [k getPhotoWithPhotosDBID:photoDBID];
}

#pragma mark - Kumulos delegate
- (void) kumulosAPI:(kumulosProxy *)kumulos apiOperation:(KSAPIOperation *)operation didFailWithError:(NSString *)theError
{
    NSLog(@"Kumulos error: %@", theError);
    if (HUD)
    {
        [HUD removeFromSuperview];
        HUD = nil;
    }
}

- (void) kumulosAPI:(Kumulos *)kumulos apiOperation:(KSAPIOperation *)operation editEventDidCompleteWithResult:(NSNumber *)affectedRows
{
    if (HUD)
    {
        [HUD removeFromSuperview];
        HUD = nil;
    }
}
- (void) kumulosAPI:(Kumulos *)kumulos apiOperation:(KSAPIOperation *)operation getPhotoDidCompleteWithResult:(NSArray *)theResults
{
    [[appDelegate photoManager] addPhoto:[[theResults objectAtIndex:0] objectForKey:@"photoValue"] text:[[theResults objectAtIndex:0] objectForKey:@"textValue"] PhotoDBID:[[theResults objectAtIndex:0] objectForKey:@"photosDBID"]];
    
    [self initHeaderView:nil];
    [self._tableView reloadData];
}

- (void) kumulosAPI:(Kumulos *)kumulos apiOperation:(KSAPIOperation *)operation createEventsDidCompleteWithResult:(NSNumber *)newRecordID
{
    Kumulos *k=[[Kumulos alloc] init];  
    [k setDelegate:self];
    
    for (int i=0; i<[friendsArray count]; i++) {
        [k inviteFriendsWithRole:[NSString stringWithFormat:@"Member"] andIsConfirm:1 andIsHome:0 andEventID:[newRecordID intValue] andUserID:[[[[friendsArray objectAtIndex:i] objectForKey:@"userID"] objectForKey:@"userDBID"] intValue]];
    }
    [k creatEventOrganizerWithRole:[NSString stringWithFormat:@"Organizer"] andIsConfirm:0 andIsHome:0 andEventID:[newRecordID intValue] andUserID:[[[[appDelegate myDetailsManager] userInfoDic] objectForKey:@"userDBID"] intValue]];


}
- (void) kumulosAPI:(Kumulos *)kumulos apiOperation:(KSAPIOperation *)operation inviteFriendsDidCompleteWithResult:(NSNumber *)newRecordID
{
}

- (void) kumulosAPI:(Kumulos *)kumulos apiOperation:(KSAPIOperation *)operation creatEventOrganizerDidCompleteWithResult:(NSNumber *)newRecordID
{

    Kumulos *k=[[Kumulos alloc] init];
    [k setDelegate:self];  
    [k getOneEventWithEventPeopleDBID:[newRecordID intValue]];
}

- (void) kumulosAPI:(Kumulos *)kumulos apiOperation:(KSAPIOperation *)operation getOneEventDidCompleteWithResult:(NSArray *)theResults
{       
    [newEventDic setObject:[[[theResults objectAtIndex:0] objectForKey:@"eventID"] objectForKey:@"eventDBID"] forKey:@"eventID"];
    [newEventDic setObject:[[[theResults objectAtIndex:0] objectForKey:@"eventID"] objectForKey:@"eventName"] forKey:@"eventName"];
    [newEventDic setObject:[[[theResults objectAtIndex:0] objectForKey:@"eventID"] objectForKey:@"eventDetails"] forKey:@"eventDetails"];
    [newEventDic setObject:[[[theResults objectAtIndex:0] objectForKey:@"eventID"] objectForKey:@"eventTime"] forKey:@"eventTime"];
    [newEventDic setObject:[[[theResults objectAtIndex:0] objectForKey:@"eventID"] objectForKey:@"startTime"] forKey:@"startTime"];
    [newEventDic setObject:[[[theResults objectAtIndex:0] objectForKey:@"eventID"] objectForKey:@"endTime"] forKey:@"endTime"];
    [newEventDic setObject:[[[theResults objectAtIndex:0] objectForKey:@"eventID"] objectForKey:@"locationName"] forKey:@"locationName"];
    [newEventDic setObject:[[[theResults objectAtIndex:0] objectForKey:@"eventID"] objectForKey:@"locationAddress"] forKey:@"locationAddress"];
    [newEventDic setObject:[[[theResults objectAtIndex:0] objectForKey:@"eventID"] objectForKey:@"locationLatitude"] forKey:@"locationLatitude"];
    [newEventDic setObject:[[[theResults objectAtIndex:0] objectForKey:@"eventID"] objectForKey:@"locationLongitude"] forKey:@"locationLongitude"];
    [newEventDic setObject:[[[theResults objectAtIndex:0] objectForKey:@"eventID"] objectForKey:@"eventIconDBID"] forKey:@"eventIconDBID"];

    [[[[appDelegate eventsManager] eventsArray] objectAtIndex:0] addObject:newEventDic];
    [[appDelegate eventsManager] updateFriendsListByEventDBID:[newEventDic objectForKey:@"eventID"] function:0];
    [[appDelegate eventsManager] writeToFile];//rewrite the event file

    
    Kumulos *k=[[Kumulos alloc] init];
    [k setDelegate:self];

    [k createPostWithTextValue:[NSString stringWithFormat:@"%@ has created an event.",[[[appDelegate myDetailsManager] userInfoDic] objectForKey:@"userName"]] andFunction:1 andDrinksDetail:nil andPhotoDetail:nil andUserID:[[[[appDelegate myDetailsManager] userInfoDic] objectForKey:@"userDBID"] intValue] andEventID:[[[[theResults objectAtIndex:0] objectForKey:@"eventID"] objectForKey:@"eventDBID"] intValue]];

    for (int i=0; i<[friendsArray count]; i++) {
        [k createPostWithTextValue:[NSString stringWithFormat:@"%@ is invited to this event",[[[friendsArray objectAtIndex:i] objectForKey:@"userID"] objectForKey:@"userName"]] andFunction:1 andDrinksDetail:nil andPhotoDetail:nil andUserID:[[[[friendsArray objectAtIndex:i] objectForKey:@"userID"] objectForKey:@"userDBID"] intValue] andEventID:[[[[theResults objectAtIndex:0] objectForKey:@"eventID"] objectForKey:@"eventDBID"] intValue]];
        
        NSMutableArray *arr=[[NSMutableArray alloc] init];
        [arr addObject:[[friendsArray objectAtIndex:i] copy]];
        [appDelegate sendNotificationWithFriendsList:arr Content:@"Invitation,join event have more fun." UserID:[[[appDelegate myDetailsManager] userInfoDic] objectForKey:@"userDBID"] EventID:[[[theResults objectAtIndex:0] objectForKey:@"eventID"] objectForKey:@"eventDBID"] function:1];

    }    
}

-(void) kumulosAPI:(Kumulos *)kumulos apiOperation:(KSAPIOperation *)operation isAttentEventDidCompleteWithResult:(NSNumber *)affectedRows
{
    [self._tableView reloadData];
}
- (void) kumulosAPI:(Kumulos *)kumulos apiOperation:(KSAPIOperation *)operation createPostDidCompleteWithResult:(NSNumber *)newRecordID
{
    postFriendTimes++;
    
    if (postFriendTimes==[friendsArray count]+1) {
        [self.navigationController popViewControllerAnimated:YES];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadFromAddFriends" object:nil];
        if (HUD)
        {
            [HUD removeFromSuperview];
            HUD = nil;
        }
    }
}
#pragma mark -
#pragma mark call Date Picker method
-(void) popPicker 
{
    NSIndexPath *indexTableViewTitle=[NSIndexPath indexPathForRow:0 inSection:0];
    AddFunctionCell *addCellTitle=(AddFunctionCell*)[self._tableView cellForRowAtIndexPath:indexTableViewTitle];
    [addCellTitle.tfContent resignFirstResponder];
    
    NSIndexPath *indexTableViewDetail=[NSIndexPath indexPathForRow:2 inSection:0];
    AddFunctionCell *addCellDetail=(AddFunctionCell*)[self._tableView cellForRowAtIndexPath:indexTableViewDetail];
    [addCellDetail.tfContent resignFirstResponder];
	
	UIToolbar *pickerDateToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
	pickerDateToolbar.barStyle = UIBarStyleBlackOpaque;
	[pickerDateToolbar sizeToFit];
	
	NSMutableArray *barItems = [[NSMutableArray alloc] init];
	
    UIBarButtonItem *cancelBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(pickerCancelClick)];
	[barItems addObject:cancelBtn];
    
    
	UIBarButtonItem *flexSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
	[barItems addObject:flexSpace];
	
	UIBarButtonItem *doneBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(pickerDoneClick)];
	[barItems addObject:doneBtn];
    
    
	
	[pickerDateToolbar setItems:barItems animated:YES];
    
    
    ////////
    UILabel *lbTitle=[[UILabel alloc] initWithFrame:CGRectMake(0, 10, 320, 20)];
    [lbTitle setTextColor:[UIColor whiteColor]];
    [lbTitle setBackgroundColor:[UIColor clearColor]];
    [lbTitle setFont:[UIFont boldSystemFontOfSize:17]];
    [lbTitle setTextAlignment:UITextAlignmentCenter];
    
    if (actionSheetFunction==0) {
        [actionSheetDate addSubview:pickerViewDate];
        [actionSheetDate addSubview:pickerDateToolbar];
        
        
        lbTitle.text=[NSString stringWithFormat:@"Date"];
        [actionSheetDate addSubview:lbTitle];
        
        [actionSheetDate showInView:self.view];
        [actionSheetDate setBounds:CGRectMake(0, 0, 320, 485)];
    }    

}




-(void) pickerDoneClick
{       
    if (actionSheetFunction==0) {
        //code here
        eventDate=[pickerViewDate date];        
        [self._tableView reloadData];
        
        ///////////////////////
        [actionSheetDate dismissWithClickedButtonIndex:0 animated:YES];    
        
        NSIndexPath *indexTableViewTitle=[NSIndexPath indexPathForRow:1 inSection:0];
        AddFunctionLabelCell *addCellTime=(AddFunctionLabelCell*)[self._tableView cellForRowAtIndexPath:indexTableViewTitle];
        addCellTime.lbContent.textColor=[UIColor whiteColor];
    }
}
-(void) pickerCancelClick
{
    [actionSheetDate dismissWithClickedButtonIndex:0 animated:YES];
}

#pragma mark - textField delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	// hide current keyboard
	[textField resignFirstResponder];
    
    self._tableView.frame=CGRectMake(0, 44, 320, 416);
	return YES;
}
- (void)textFieldDidBeginEditing:(UITextField *)textField
{  
    //tag=section+row
    if (textField.tag==0) {
        if ([eventName length]!=0) {
            textField.text=[self eventName];
        }
        else {
            textField.text=[NSString stringWithFormat:@""];
        }
        textField.textColor=[UIColor whiteColor];
        
        [UIView beginAnimations:@"ResizeForKeyBoard" context:nil];
        [UIView setAnimationDuration:0.5f];  
        
        self._tableView.frame=CGRectMake(0, 44, 320, 200);
        [UIView commitAnimations];
        
        indexTableView=[NSIndexPath indexPathForRow:0 inSection:0];
    }
    else if (textField.tag==2) {
        if ([eventDetails length]!=0) {
            textField.text=[self eventDetails];
        }
        else {
            textField.text=[NSString stringWithFormat:@""];
        }
        textField.textColor=[UIColor whiteColor];
        
        [UIView beginAnimations:@"ResizeForKeyBoard" context:nil];
        [UIView setAnimationDuration:0.5f];  
        
        self._tableView.frame=CGRectMake(0, 44, 320, 200);
        [UIView commitAnimations];
        
        indexTableView=[NSIndexPath indexPathForRow:2 inSection:0];
    }
}
-(void) textFieldDidEndEditing:(UITextField *)textField
{
    if (textField.tag==0) {
        if ([[textField text] length]==0) {
            if ([self.eventName length]!=0) {
                textField.text=self.eventName;
                textField.textColor=[UIColor whiteColor];
            }
            else {
                textField.text=[NSString stringWithFormat:@"Touch to edit"];
                textField.textColor=[UIColor grayColor];
            }
        }
        else {
            self.eventName=[[NSString alloc] initWithFormat:@"%@",[textField text]];
        }
    }
    else if (textField.tag==2) {
        if ([[textField text] length]==0) {
            if ([self.eventDetails length]!=0) {
                textField.text=self.eventDetails;
                textField.textColor=[UIColor whiteColor];
            }
            else {
                textField.text=[NSString stringWithFormat:@"Touch to edit"];
                textField.textColor=[UIColor grayColor];
            }
        }
        else {
            self.eventDetails=[textField text];
        }
    }
    self._tableView.frame=CGRectMake(0, 44, 320, 416);
}

#pragma mark - map view delegate
- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{
//    CLLocationCoordinate2D coordinate;
//    coordinate.latitude=[self locationLatitude];
//	coordinate.longitude=[self locationLongitude];
//    
//    MKCoordinateRegion theRegion;
//    theRegion.center=coordinate;
//    
//    [mapView setRegion:theRegion animated:YES];
}
- (MKAnnotationView *)mapView:(MKMapView *)mV viewForAnnotation:(id <MKAnnotation>)annotation
{
	MKPinAnnotationView *pinView = nil;
	if(annotation != myMapView.userLocation)
	{
		static NSString *defaultPinID = @"com.invasivecode.pin";
		pinView = (MKPinAnnotationView *)[myMapView dequeueReusableAnnotationViewWithIdentifier:defaultPinID];
		if ( pinView == nil ) pinView = [[MKPinAnnotationView alloc]
                                         initWithAnnotation:annotation reuseIdentifier:defaultPinID];
		pinView.pinColor = MKPinAnnotationColorRed;
		pinView.animatesDrop = YES;
		///////////////////////////////给大头针加入按钮
		pinView.canShowCallout = YES;
        //		UIButton *button = [UIButton buttonWithType:UIButtonTypeDetailDisclosure]; 
		//[button addTarget:self action:@selector(checkButtonTapped:event:) forControlEvents:UIControlEventTouchUpInside]; 
        //		pinView.rightCalloutAccessoryView=button; 
	}
	else {
		[myMapView.userLocation setTitle:@"You are Here"];
        [myMapView.userLocation setSubtitle:@""];
	}
	return pinView;
}

#pragma mark - stop Bump
-(void)applicationWillTerminate:(UIApplication *)application{
	[bumpConn stopBump];
}

#pragma mark -
#pragma mark MBProgressHUDDelegate methods
- (void)hudWasHidden:(MBProgressHUD *)hud {
    // Remove HUD from screen when the HUD was hidded
    [HUD removeFromSuperview];
	HUD = nil;
}
@end
