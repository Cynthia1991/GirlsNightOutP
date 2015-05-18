//
//  EventMainPageViewController.m
//  GurlsNightOut
//
//  Created by calvin on 17/04/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

//    [[NSNotificationCenter defaultCenter]  addObserver:self selector:@selector(reloadPost:) name:@"addPost" object:nil];

#import <QuartzCore/QuartzCore.h>
#import "EventMainPageViewController.h"
#import "AppDelegate.h"
#import "AddTimelineTextViewController.h"
#import "Drinks.h"
#import "EventMainPageTableCell.h"
#import "EventMainPageHTableCell.h"
#import "EventMainPagePTableCell.h"
#import "CommentDetailsViewController.h"
#import "LikeDetailsViewController.h"

@interface EventMainPageViewController ()

@end

@implementation EventMainPageViewController
@synthesize mySegmentedControl;
@synthesize largeImageView;
@synthesize largeImageBackgroundView;
@synthesize _tableView;
@synthesize eventID,addPost,moreButtonClickTime,HUD,friendsArray;

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
//    appDelegate.timelineManager=[[TimelineManager alloc] initByEventID:eventID function:1 loadingTimes:moreButtonClickTime+1];///////////////reload data from server
    [appDelegate.timelineManager reloadPostByEventID:[self eventID]];
    [self.navigationController setNavigationBarHidden:YES];
}
-(void)viewDidAppear:(BOOL)animated
{
    appDelegate.eventID=[self eventID];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self._tableView.backgroundColor = [UIColor clearColor];

	// Do any additional setup after loading the view.
    iconDic=[[NSMutableDictionary alloc] init];
    photosDic=[[NSMutableDictionary alloc] init];
    
    _timeScroller = [[TimeScroller alloc] initWithDelegate:self];

    appDelegate=(AppDelegate*)[[UIApplication sharedApplication] delegate];
    NSMutableArray *dic=[[appDelegate.eventsManager getEventDictionaryByEventID:self.eventID] objectForKey:@"eventFriends"];
    friendsArray=[[NSMutableArray alloc] init];
    for (int i=0; i<[dic count]; i++) {
        [friendsArray addObject:[[dic objectAtIndex:i] objectForKey:@"userID"]];
    }
    
    [[NSNotificationCenter defaultCenter]  addObserver:self selector:@selector(reloadData:) name:@"GetAllPost" object:nil]; 
    [[NSNotificationCenter defaultCenter]  addObserver:self selector:@selector(reloadFromAppleNotification:) name:@"reloadFromAppleNotification" object:nil]; 
    [[NSNotificationCenter defaultCenter]  addObserver:self selector:@selector(reloadPost:) name:@"addPost" object:nil];
    [[NSNotificationCenter defaultCenter]  addObserver:self selector:@selector(reloadByLike:) name:@"reloadByLike" object:nil];
    [[NSNotificationCenter defaultCenter]  addObserver:self selector:@selector(reloadTableView:) name:@"reloadTimelineTableView" object:nil];
    [[NSNotificationCenter defaultCenter]  addObserver:self selector:@selector(viewCommentDetails:) name:@"view comment detail" object:nil];
    [[NSNotificationCenter defaultCenter]  addObserver:self selector:@selector(viewLikeDetails:) name:@"view like detail" object:nil];
    [[NSNotificationCenter defaultCenter]  addObserver:self selector:@selector(imageViewPopup:) name:@"pop timeline image" object:nil];
    //////////////////////////////////////////////////////////////////


    

//    UIView *footView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 100)];
//    [_tableView setTableFooterView:footView];
    
    ////////////////////////////////////////////////////For EGORefreshTableHeaderView
    if (refreshHeaderView == nil) {
        
        EGORefreshTableHeaderView *view = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - self._tableView.bounds.size.height, self.view.frame.size.width, self._tableView.bounds.size.height)];
        view.delegate = self;
        [self._tableView addSubview:view];
        refreshHeaderView = view;        
    }
    
    //  update the last update date
    [refreshHeaderView refreshLastUpdatedDate];
    
    [self getPostByFunction:0];
    
    
    UITapGestureRecognizer *popPostStatusTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(contentViewClicked:)];
    popPostStatusTapRecognizer.numberOfTapsRequired=2;
    [self._tableView addGestureRecognizer:popPostStatusTapRecognizer];
    
    
    overlayWindow = [[ACStatusBarOverlayWindow alloc] initWithFrame:CGRectZero];
    overlayWindow.hidden = NO;
    [overlayWindow setDelegate:self];
//    overlay = [MTStatusBarOverlay sharedInstance];
//    
//    
//    overlay.animation = MTStatusBarOverlayAnimationShrink;  // MTStatusBarOverlayAnimationShrink
//    overlay.detailViewMode = MTDetailViewModeCustom;         // enable automatic history-tracking and show in detail-view
//    overlay.delegate = self;
//    overlay.historyEnabled = YES;
////    UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 20)];
////    view.backgroundColor=[UIColor clearColor];
////    [overlay.finishedLabel setHidden:YES];
////    [overlay addSubviewToBackgroundView:view];
////    overlay.progress = 0.0;
//    [overlay postMessage:@"Following @myell0w on Twitter…"];
//    overlay.progress = 0.1;
//    // ...
//    [overlay postMessage:@"Following @myell0w" animated:NO];
//    overlay.progress = 0.5;
//    // ...
////    [overlay postImmediateFinishMessage:@"Following was a good idea!" duration:2.0 animated:YES];
////    overlay.progress = 1.0;
}
- (void)contentViewClicked:(UITapGestureRecognizer *)gestureRecognizer {
	if (gestureRecognizer.state == UIGestureRecognizerStateEnded) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"popup add status view" object:nil];

	}
}
- (void)viewWillDisappear:(BOOL)animated
{
//    [overlay postImmediateFinishMessage:@"Finish timeline!" duration:1.0 animated:YES];
//    overlay.progress = 1.0;
    [overlayWindow setHide];
}
- (void)statusBarOverlayDidRecognizeGesture:(UIGestureRecognizer *)gestureRecognizer{
    NSLog(@"gestureRecognizer");
    NSIndexPath *indexTableView=[NSIndexPath indexPathForRow:0 inSection:0];
    if ([_tableView numberOfRowsInSection:0] > 0) {
        
        [_tableView scrollToRowAtIndexPath:indexTableView atScrollPosition:UITableViewScrollPositionTop animated:YES];

    }
}

#pragma mark - long press gesture detect
-(void)saveImage:(UILongPressGestureRecognizer *)recognizer//long press detect
{
    if(UIGestureRecognizerStateBegan == recognizer.state) {
        UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                      initWithTitle:nil         //Title
                                      delegate:self                  //delegate
                                      cancelButtonTitle:@"Cancel"
                                      destructiveButtonTitle:nil
                                      otherButtonTitles:@"Save", nil];  //button
        //    [actionSheet showInView:self.tabBarController.view];/////////////////////////////////////////////////////////interesting,not in tabbar has somge problem
        [actionSheet setTag:1];
        [actionSheet showInView:largeImageView];/////////////////////////////////////////////////////////interesting,not in tabbar has somge problem
    }
    
    if(UIGestureRecognizerStateChanged == recognizer.state) {
        // Do repeated work here (repeats continuously) while finger is down
        NSLog(@"UIGestureRecognizerStateChanged");
    }
    
    if(UIGestureRecognizerStateEnded == recognizer.state) {
        // Do end work here when finger is lifted
        NSLog(@"UIGestureRecognizerStateEnded");
    }
}
-(void)hideImage:(UITapGestureRecognizer *)recognizer//long press detect
{
    if(UIGestureRecognizerStateBegan == recognizer.state) {
    }
    
    if(UIGestureRecognizerStateChanged == recognizer.state) {
        // Do repeated work here (repeats continuously) while finger is down
        NSLog(@"UIGestureRecognizerStateChanged");
    }
    
    if(UIGestureRecognizerStateEnded == recognizer.state) {
        // Do end work here when finger is lifted
        NSLog(@"UIGestureRecognizerStateEnded");
        [self hideLargeImage];
    }
}
- (void) hideLargeImage
{
    [UIView animateWithDuration:0.5
                     animations:^{
                         [largeImageBackgroundView setAlpha:0.0];
                         [largeImgView setFrame:imageLocation];
                     }
                     completion:^(BOOL finished){
                         largeImageView.hidden=YES;
                         [largeImgView removeFromSuperview];
                     }
     ];
}
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (actionSheet.tag==1) {
        if (buttonIndex==0) {
            NSLog(@"save image");
            HUD = [MBProgressHUD showHUDAddedTo:largeImageView animated:YES];
            HUD.dimBackground = YES;
            HUD.labelText = @"Its saving!";
            
            UIImageWriteToSavedPhotosAlbum(largeImgView.image, self, @selector(imageSavedToPhotosAlbum: didFinishSavingWithError: contextInfo:), nil);
        }
    }
}
- (void)imageSavedToPhotosAlbum:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    HUD.mode = MBProgressHUDModeCustomView;    
    if (!error) {
        HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Checkmark.png"]];
        HUD.labelText = @"Save successful :)";
    }
    else {
        HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"sad_face.png"]];
        HUD.labelText = @"Error! Try saving photo again :p";
    }

    [HUD hide:YES afterDelay:1.5];
    [self hideLargeImage];
}
#pragma mark -
#pragma mark MBProgressHUDDelegate methods

- (void)hudWasHidden:(MBProgressHUD *)hud {
    // Remove HUD from screen when the HUD was hidded
    [HUD removeFromSuperview];
	HUD = nil;
}

- (void)viewDidUnload
{
    [self setMySegmentedControl:nil];
    [self setLargeImageView:nil];
    [self setLargeImageBackgroundView:nil];
    [super viewDidUnload];
}

- (void)imageViewPopup:(NSNotification*) notification{
    UIImageView *imgView=[notification object];
    largeImgView=[[UIImageView alloc] initWithImage:[imgView.image copy]];
    largeImgView.frame=[imgView frame];
    
    [largeImgView setUserInteractionEnabled:YES];
    ///////////////////////////////////////////////////////////////
    UILongPressGestureRecognizer *saveTapRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(saveImage:)];
    saveTapRecognizer.numberOfTouchesRequired = 1;
    saveTapRecognizer.minimumPressDuration = 0.3;
    [largeImgView addGestureRecognizer:saveTapRecognizer];
    ///////////////////////////////////////////////////////////////
    UITapGestureRecognizer *hideTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideImage:)];
    hideTapRecognizer.numberOfTouchesRequired = 1;
    [largeImgView addGestureRecognizer:hideTapRecognizer];
    ///////////////////////////////////////////////////////////////

    
    [largeImageView addSubview:largeImgView];
    imageLocation=CGRectMake(imgView.frame.origin.x, imgView.frame.origin.y, imgView.frame.size.width, imgView.frame.size.height);
    
    largeImageView.hidden=NO;
    
    [UIView beginAnimations:@"describeView" context:nil];
    [UIView setAnimationDuration:0.3];
    [largeImageBackgroundView setAlpha:1.0];
    [UIView commitAnimations];
    
    [UIView beginAnimations:@"describeView1" context:nil];
    [UIView setAnimationDuration:0.7];
    [largeImgView setFrame:CGRectMake(0, 0, 320, 460)];
    [UIView commitAnimations];
    
}
- (void)viewLikeDetails:(NSNotification*) notification{
    NSMutableArray *arr=[notification object];
    LikeDetailsViewController *likeDetailsViewController=[self.storyboard instantiateViewControllerWithIdentifier:@"LikeDetailsViewController"];
    likeDetailsViewController.likesArray=[[NSMutableArray alloc] initWithArray:arr];
    [self.navigationController pushViewController:likeDetailsViewController animated:YES];
}

- (void)viewCommentDetails:(NSNotification*) notification{
    NSMutableArray *arr=[notification object];
    CommentDetailsViewController *commentDetailsViewController=[self.storyboard instantiateViewControllerWithIdentifier:@"CommentDetailsViewController"];
    commentDetailsViewController.commentsArray=[[NSMutableArray alloc] initWithArray:arr];
    [self.navigationController pushViewController:commentDetailsViewController animated:YES];
}
- (void)reloadTableView:(NSNotification*) notification{
    //  should be calling your tableviews data source model to reload
    //  put here just for demo
    
//    appDelegate.timelineManager=[[TimelineManager alloc] initByEventID:eventID function:1 loadingTimes:moreButtonClickTime+1];
    [appDelegate.timelineManager reloadPostByEventID:eventID];///////////////reload data from server
    
    NSMutableArray *arr=[[NSMutableArray alloc] init];
    for (int i=0; i<[self.friendsArray count]; i++) {
        NSMutableDictionary *dic=[[NSMutableDictionary alloc] init];
        [dic setObject:[self.friendsArray objectAtIndex:i] forKey:@"userID"];
        [arr addObject:dic];
    }
    
    NSString *massege=[notification object];
    [appDelegate sendNotificationWithFriendsList:arr Content:massege UserID:[appDelegate.myDetailsManager.userInfoDic objectForKey:@"userName"] EventID:self.eventID function:0];
    _reloading = YES;
    
}
- (void)reloadFromAppleNotification:(NSNotification*) notification
{
    NSLog(@"reload from notification");
//    appDelegate.timelineManager=[[TimelineManager alloc] initByEventID:[self eventID] function:0 loadingTimes:0];
}

- (void)reloadByLike:(NSNotification*) notification
{
    [self._tableView reloadData];
}
- (void)reloadData:(NSNotification*) notification
{
    [self getPostByFunction:0];
    
    
    
    [self doneLoadingTableViewData];
//    NSIndexPath *indexTableView=[NSIndexPath indexPathForRow:[_datasource count]-1 inSection:0];
//    [_tableView scrollToRowAtIndexPath:indexTableView atScrollPosition:UITableViewScrollPositionTop animated:NO];
}
- (void)reloadPost:(NSNotification*) notification
{
    appDelegate.timelineManager.eventID=[self eventID];
    [appDelegate.timelineManager reloadPostByEventID:self.eventID];
}

- (UITableView *)tableViewForTimeScroller:(TimeScroller *)timeScroller {
    
    return _tableView;
    
}

//You should return an NSDate related to the UITableViewCell given. This will be
//the date displayed when the TimeScroller is above that cell.
- (NSDate *)dateForCell:(UITableViewCell *)cell {
    
    NSIndexPath *indexPath = [_tableView indexPathForCell:cell];
//    if (indexPath.row == 0) {
//        return [NSDate date];
//    }
    NSDictionary *dictionary = [_datasource objectAtIndex:indexPath.row];
    NSDate *date = [dictionary objectForKey:@"date"];
    
    return date;
    
}

#pragma mark -
#pragma mark UIScrollViewDelegate Methods
//The TimeScroller needs to know what's happening with the UITableView (UIScrollView)
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    //NSLog(@"%f",scrollView.contentOffset.y);
    [_timeScroller scrollViewDidScroll];
    [refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    [_timeScroller scrollViewDidEndDecelerating];
    
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if ([_datasource count]>9) {
        [_timeScroller scrollViewWillBeginDragging];

    }
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    [refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];

    if (!decelerate) {
        
        [_timeScroller scrollViewDidEndDecelerating];
        
    }
    
}

#pragma mark UITableViewDelegate Methods


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dictionary = [_datasource objectAtIndex:indexPath.row];
    if ([[dictionary objectForKey:@"function"] intValue]==2) {
        if ([[[[[appDelegate photoManager] photoDic] objectForKey:[NSString stringWithFormat:@"id%@",[dictionary objectForKey:@"photoDBID"]]] objectForKey:@"text"] intValue]==1) 
        {
            return 504;
        }
        else if ([[[[[appDelegate photoManager] photoDic] objectForKey:[NSString stringWithFormat:@"id%@",[dictionary objectForKey:@"photoDBID"]]] objectForKey:@"text"] intValue]==2)
        {
            return 329;
        }
        else {
            return 504;
        }
    }
    else if ([[dictionary objectForKey:@"function"] intValue]==1)
    {
        NSDictionary *dictionary = [_datasource objectAtIndex:indexPath.row];       
        
        UILabel *titleLabel=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        CGSize labelSize = { 300, 20000.0 };
        NSString *title = [NSString stringWithFormat:@"%@",[dictionary objectForKey:@"chat"]];
        [titleLabel setFont:[UIFont systemFontOfSize:17]];
        [titleLabel setText:title];
        [titleLabel setLineBreakMode:UILineBreakModeWordWrap];
        [titleLabel setNumberOfLines:0];
        CGSize textSize = [[titleLabel text] sizeWithFont:[UIFont systemFontOfSize:18] constrainedToSize:labelSize lineBreakMode:UILineBreakModeWordWrap];
        [titleLabel setFrame:CGRectMake(75, 10, 235, textSize.height)];
        return 129-21+textSize.height;
        
    }
    else if ([[dictionary objectForKey:@"function"] intValue]==3)
    {    
        NSMutableData *data = [dictionary objectForKey:@"drinksID"];
        NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
        NSMutableDictionary *myDictionary = [unarchiver decodeObjectForKey:@"DrinkDetail"];
        [unarchiver finishDecoding];
                
        Drinks *drink=[appDelegate.addDrinkManager selectADrinkID:[myDictionary objectForKey:@"drinksID"]];
        NSString *title = [NSString stringWithFormat:@"Drinks a %@",drink.drinkName ];
        
                
        UILabel *titleLabel=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        CGSize labelSize = { 300, 20000.0 };
//        NSString *title = [NSString stringWithFormat:@"%@",[dictionary objectForKey:@"chat"]];
        [titleLabel setFont:[UIFont systemFontOfSize:17]];
        [titleLabel setText:title];
        [titleLabel setLineBreakMode:UILineBreakModeWordWrap];
        [titleLabel setNumberOfLines:0];
        CGSize textSize = [[titleLabel text] sizeWithFont:[UIFont systemFontOfSize:17] constrainedToSize:labelSize lineBreakMode:UILineBreakModeWordWrap];
        [titleLabel setFrame:CGRectMake(75, 10, 235, textSize.height)];
        return 129-21+textSize.height;
    }
    return 129;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [_datasource count];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dictionary = [_datasource objectAtIndex:indexPath.row];

    NSString *identifier1 = [NSString stringWithFormat:@"Cell"];//], [indexPath section],[indexPath row]];
    NSString *identifierH = [NSString stringWithFormat:@"CellH"];//], [indexPath section],[indexPath row]];
    NSString *identifierP = [NSString stringWithFormat:@"CellP"];//], [indexPath section],[indexPath row]];   
    
    NSLog(@"%@",[dictionary objectForKey:@"eventPostDBID"]);
    NSLog(@"function: %@",[dictionary objectForKey:@"function"]);
    if ([[dictionary objectForKey:@"function"] intValue]==1||[[dictionary objectForKey:@"function"] intValue]==4) {//chat
        EventMainPageTableCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier1];
        

        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"userDBID == %@", [dictionary objectForKey:@"userDBID"]];
        NSArray *abc = [self.friendsArray filteredArrayUsingPredicate:predicate];
        
        
        if ([[[abc objectAtIndex:0] objectForKey:@"photosDBID"] intValue]!=0) {
            if ([[[[appDelegate photoManager] photoDic] objectForKey:[NSString stringWithFormat:@"id%@",[[abc objectAtIndex:0] objectForKey:@"photosDBID"]]] objectForKey:@"path"]!=0) {
                if ([iconDic objectForKey:[NSString stringWithFormat:@"id%@",[[abc objectAtIndex:0] objectForKey:@"photosDBID"]]]!=nil) {
                    UIImage *img=[iconDic objectForKey:[NSString stringWithFormat:@"id%@",[[abc objectAtIndex:0] objectForKey:@"photosDBID"]]];
                    cell.ivIcon.image=img;
                }
                else {
                    UIImage *img=[[appDelegate photoManager] getPhotoByPhotoDBID:[[abc objectAtIndex:0] objectForKey:@"photosDBID"]];
                    if(img!=NULL){
                    [iconDic setObject:img forKey:[NSString stringWithFormat:@"id%@",[[abc objectAtIndex:0] objectForKey:@"photosDBID"]]];
                        cell.ivIcon.image=img;
                    }
                }
                
            }
            else {
                //load icon
                if ([[[appDelegate photoManager] photoDic] objectForKey:[NSString stringWithFormat:@"id%@", [[abc objectAtIndex:0] objectForKey:@"photosDBID"]]]==nil) {
                    [self loadPhotoFromServer:[[[abc objectAtIndex:0] objectForKey:@"photosDBID"] intValue]];
                }
            }
        }
        else {
            UIImage *img=[UIImage imageNamed:@"Persondot.png"];
            cell.ivIcon.image=img;
        }
        
        
        
        
//        if (![[NSString stringWithFormat:@"%@",[dictionary objectForKey:@"iconPhotoDBID"]] isEqualToString:@"noIcon"]) {
//            if ([[[[appDelegate photoManager] photoDic] objectForKey:[NSString stringWithFormat:@"id%@",[dictionary objectForKey:@"iconPhotoDBID"]]] objectForKey:@"path"]!=nil) {
//                if ([iconDic objectForKey:[NSString stringWithFormat:@"id%@",[dictionary objectForKey:@"iconPhotoDBID"]]]!=nil) {
//                    UIImage *img=[iconDic objectForKey:[NSString stringWithFormat:@"id%@",[dictionary objectForKey:@"iconPhotoDBID"]]];
//                    cell.ivIcon.image=img;
//                }
//                else {
//                    UIImage *img=[[appDelegate photoManager] getPhotoByPhotoDBID:[dictionary objectForKey:@"iconPhotoDBID"]];
//                    [iconDic setObject:img forKey:[NSString stringWithFormat:@"id%@",[dictionary objectForKey:@"iconPhotoDBID"]]];
//                    cell.ivIcon.image=img;
//                }
//                
//            }
//            else {
//                //load icon
//                if ([[[appDelegate photoManager] photoDic] objectForKey:[NSString stringWithFormat:@"id%@", [dictionary objectForKey:@"iconPhotoDBID"]]]==nil) {
//                    [self loadPhotoFromServer:[[dictionary objectForKey:@"iconPhotoDBID"] intValue]];
//                }
//            }
//        }
//        else {
//            UIImage *img=[UIImage imageNamed:@"Persondot.png"];
//            cell.ivIcon.image=img;
//        }
        
        NSDate *date = [dictionary objectForKey:@"date"];
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"EEE, dd MMM HH:mm"];
        NSString *theDate = [dateFormat stringFromDate:date];
        NSString *timeStr=[NSString stringWithFormat:@"%@",theDate];
        cell.lbPostTime.text = timeStr;
        
        cell.lbName.text=[NSString stringWithFormat:@"%@",[dictionary objectForKey:@"userName"]];
        
        
        
        NSString *title = [NSString stringWithFormat:@"%@",[dictionary objectForKey:@"chat"]];
//        cell.lbPostContent=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        CGSize labelSize = { 300, 20000.0 };
        [cell.lbPostContent setFont:[UIFont systemFontOfSize:17]];
        [cell.lbPostContent setText:title];
        [cell.lbPostContent setLineBreakMode:UILineBreakModeWordWrap];
        [cell.lbPostContent setNumberOfLines:0];
        CGSize textSize = [[cell.lbPostContent text] sizeWithFont:[UIFont systemFontOfSize:18] constrainedToSize:labelSize lineBreakMode:UILineBreakModeWordWrap];
        [cell.lbPostContent setFrame:CGRectMake(20, 62, 280, textSize.height)];
        [cell.vBottom setFrame:CGRectMake(10, textSize.height+62, 300, 30)];
        [cell.ivBackground1 setFrame:CGRectMake(10, 5, 300, textSize.height+62)];
        
        cell.ivBackground1.layer.masksToBounds = YES; //没这句话它圆不起来
        cell.ivBackground1.layer.cornerRadius = 5.0; //设置图片圆角的尺度。
        
        /////////////////////////

        NSArray *abcComment;
        NSLog(@"post count:%d",[[appDelegate.timelineManager.commentPostDic objectForKey:self.eventID] count]);

        if ([appDelegate.timelineManager.commentPostDic count]!=0) {
            NSMutableArray *arr=[appDelegate.timelineManager.commentPostDic objectForKey:self.eventID];
            
            if ([arr count]!=0) {
                NSPredicate *predicate = [NSPredicate predicateWithFormat:@"postID like %@", [dictionary objectForKey:@"eventPostDBID"]];
                abcComment = [arr filteredArrayUsingPredicate:predicate];
                if ([abcComment count]!=0) {
                    cell.lbCommentDisplay.text=[NSString stringWithFormat:@"%d",[abcComment count]];
                    cell.commentArray=[[NSMutableArray alloc] initWithArray:abcComment];
                    cell.vCommentDisplay.hidden=NO;
                    
                }
                else
                {
                    cell.vCommentDisplay.hidden=YES;
                }
            }
            else
            {
                cell.vCommentDisplay.hidden=YES;
            }

        }
        else
        {
            cell.vCommentDisplay.hidden=YES;
        }
        /////////////////////////
        
        
        if ([appDelegate.timelineManager.likePostDic count]!=0) {
            NSMutableArray *arr=[appDelegate.timelineManager.likePostDic objectForKey:self.eventID];
            
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"likeID == %@", [dictionary objectForKey:@"eventPostDBID"]];
            NSArray *abc = [arr filteredArrayUsingPredicate:predicate];
            
            if ([abc count]!=0) {
                cell.likeArray=[[NSMutableArray alloc] initWithArray:abc];
                cell.lbLikeDisplay.text=[NSString stringWithFormat:@"%d",[abc count]];
                
                if ([self isIncludedUserDBIDWithPostID:[dictionary objectForKey:@"eventPostDBID"]]) {
                    cell.btLike.hidden=YES;
                    cell.btLike.enabled=NO;
                    [cell.btComment setFrame:CGRectMake(2, 5, 72, 20)];
                }
                else
                {
                    cell.btLike.hidden=NO;
                    cell.btLike.enabled=YES;
                    [cell.btComment setFrame:CGRectMake(44, 5, 72, 20)];
                }
                
                [cell.vLikeDisplay setHidden:NO];
                if ([abcComment count]==0) {
                    [cell.vLikeDisplay setFrame:CGRectMake(250, 0, 64, 30)];
                }
                else
                {
                    [cell.vLikeDisplay setFrame:CGRectMake(195, 0, 64, 30)];

                }
            }
            else
            {
                [cell.vLikeDisplay setHidden:YES];

                cell.btLike.hidden=NO;
                cell.btLike.enabled=YES;
                [cell.btComment setFrame:CGRectMake(44, 5, 72, 20)];
            }
            
        }
        else
        {
            [cell.vLikeDisplay setHidden:YES];

            cell.btLike.hidden=NO;
            cell.btLike.enabled=YES;
            [cell.btComment setFrame:CGRectMake(44, 5, 72, 20)];
        }

        [cell setUserID:[appDelegate.myDetailsManager.userInfoDic objectForKey:@"userDBID"]];
        cell.postID=[dictionary objectForKey:@"eventPostDBID"];
        cell.eventID=[self eventID];
        [cell initKumulos];
        return cell;
    }
    else if([[dictionary objectForKey:@"function"] intValue]==2)//photo
    {      
        NSData *data = [dictionary objectForKey:@"photoDetail"];            
        NSDictionary *myPhotoDetailDictionary = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        
//        NSLog(@"%@",myPhotoDetailDictionary);

//        float width,heigh;
        if ([[myPhotoDetailDictionary objectForKey:@"text"] intValue]==1)
        {
            EventMainPageHTableCell *cell = [tableView dequeueReusableCellWithIdentifier:identifierH];

            
            if (![[NSString stringWithFormat:@"%@",[dictionary objectForKey:@"iconPhotoDBID"]] isEqualToString:@"noIcon"]) {
                if ([[[[appDelegate photoManager] photoDic] objectForKey:[NSString stringWithFormat:@"id%@",[dictionary objectForKey:@"iconPhotoDBID"]]] objectForKey:@"path"]!=0) {
                    if ([iconDic objectForKey:[NSString stringWithFormat:@"id%@",[dictionary objectForKey:@"iconPhotoDBID"]]]!=nil) {
                        UIImage *img=[iconDic objectForKey:[NSString stringWithFormat:@"id%@",[dictionary objectForKey:@"iconPhotoDBID"]]];
                        cell.ivIcon.image=img;
                    }
                    else {
                        UIImage *img=[[appDelegate photoManager] getPhotoByPhotoDBID:[dictionary objectForKey:@"iconPhotoDBID"]];
                        if(img!=NULL){
                        [iconDic setObject:img forKey:[NSString stringWithFormat:@"id%@",[dictionary objectForKey:@"iconPhotoDBID"]]];
                            cell.ivIcon.image=img;
                        }
                    }
                    
                }
                else {
                    //load icon
                    if ([[[appDelegate photoManager] photoDic] objectForKey:[NSString stringWithFormat:@"id%@", [dictionary objectForKey:@"iconPhotoDBID"]]]==nil) {
                        [self loadPhotoFromServer:[[dictionary objectForKey:@"iconPhotoDBID"] intValue]];
                    }
                }
            }
            else {
                UIImage *img=[UIImage imageNamed:@"Persondot.png"];
                cell.ivIcon.image=img;
            }
            
            NSDate *date = [dictionary objectForKey:@"date"];
            NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
            [dateFormat setDateFormat:@"EEE, dd MMM HH:mm"];
            NSString *theDate = [dateFormat stringFromDate:date];
            NSString *timeStr=[NSString stringWithFormat:@"%@",theDate];
            cell.lbPostTime.text = timeStr;
            
            cell.lbName.text=[NSString stringWithFormat:@"%@",[dictionary objectForKey:@"userName"]];
            ////////////////////////////////////////////////////////////////
//            width=200;
//            heigh=266;
            cell.lbPostContent.text=[NSString stringWithFormat:@""];
            
            
            if ([photosDic objectForKey:[myPhotoDetailDictionary objectForKey:@"photoDBID"]]!=nil) {
                cell.ivPhoto.image=[photosDic objectForKey:[myPhotoDetailDictionary objectForKey:@"photoDBID"]];
                [UIView beginAnimations:@"describeView" context:nil];
                [UIView setAnimationDuration:0.5];
                [cell.ivPhoto setAlpha:1.0];
                [UIView commitAnimations];
            }
            else
            {
                cell.ivPhoto.alpha=0.0f;
                UIImage *img=[[appDelegate photoManager] getPhotoByPhotoDBID:[myPhotoDetailDictionary objectForKey:@"photoDBID"]];
                if (img!=nil) {
                    cell.ivPhoto.image=img;
                    [photosDic setObject:img forKey:[myPhotoDetailDictionary objectForKey:@"photoDBID"]];
                    
                    [UIView beginAnimations:@"describeView" context:nil];
                    [UIView setAnimationDuration:0.5];
                    [cell.ivPhoto setAlpha:1.0];
                    [UIView commitAnimations];
                }
            }
            cell.ivBackground1.layer.masksToBounds = YES; //没这句话它圆不起来
            cell.ivBackground1.layer.cornerRadius = 5.0; //设置图片圆角的尺度。
            
            


            NSArray *abcComment;
            if ([appDelegate.timelineManager.commentPostDic count]!=0) {
                NSMutableArray *arr=[appDelegate.timelineManager.commentPostDic objectForKey:self.eventID];
                
                NSPredicate *predicate = [NSPredicate predicateWithFormat:@"postID == %@", [dictionary objectForKey:@"eventPostDBID"]];
                abcComment = [arr filteredArrayUsingPredicate:predicate];
                
                if ([abcComment count]!=0) {
                    cell.lbCommentDisplay.text=[NSString stringWithFormat:@"%d",[abcComment count]];
                    cell.commentArray=[[NSMutableArray alloc] initWithArray:abcComment];
                    cell.vCommentDisplay.hidden=NO;
                    
                }
                else
                {
                    cell.vCommentDisplay.hidden=YES;
                }
                
            }
            else
            {
                cell.vCommentDisplay.hidden=YES;
            }
            
            if ([appDelegate.timelineManager.likePostDic count]!=0) {
                NSMutableArray *arr=[appDelegate.timelineManager.likePostDic objectForKey:self.eventID];
                
                NSPredicate *predicate = [NSPredicate predicateWithFormat:@"likeID == %@", [dictionary objectForKey:@"eventPostDBID"]];
                NSArray *abc = [arr filteredArrayUsingPredicate:predicate];
                
                if ([abc count]!=0) {
                    cell.lbLikeDisplay.text=[NSString stringWithFormat:@"%d",[abc count]];
                    cell.likeArray=[[NSMutableArray alloc] initWithArray:abc];

                    if ([self isIncludedUserDBIDWithPostID:[dictionary objectForKey:@"eventPostDBID"]]) {
                        cell.btLike.hidden=YES;
                        cell.btLike.enabled=NO;
                        [cell.btComment setFrame:CGRectMake(12, 464, 72, 20)];
                    }
                    else
                    {
                        cell.btLike.hidden=NO;
                        cell.btLike.enabled=YES;
                        [cell.btComment setFrame:CGRectMake(54, 464, 72, 20)];
                    }
                    
                    [cell.vLikeDisplay setHidden:NO];
                    if ([abcComment count]==0) {
                        [cell.vLikeDisplay setFrame:CGRectMake(260, 459, 64, 30)];
                    }
                    else
                    {
                        [cell.vLikeDisplay setFrame:CGRectMake(205, 459, 64, 30)];
                        
                    }
                }
                else
                {
                    [cell.vLikeDisplay setHidden:YES];

                    cell.btLike.hidden=NO;
                    cell.btLike.enabled=YES;
                    [cell.btComment setFrame:CGRectMake(54, 464, 72, 20)];
                }
                
            }
            else
            {
                [cell.vLikeDisplay setHidden:YES];

            
                cell.btLike.hidden=NO;
                cell.btLike.enabled=YES;
                [cell.btComment setFrame:CGRectMake(54, 464, 72, 20)];
            }
            
            [cell setUserID:[appDelegate.myDetailsManager.userInfoDic objectForKey:@"userDBID"]];
            cell.postID=[dictionary objectForKey:@"eventPostDBID"];
            cell.eventID=[self eventID];
            [cell initKumulos];
            return cell;
        }
        else if ([[myPhotoDetailDictionary objectForKey:@"text"] intValue]==2)
        {
            EventMainPagePTableCell *cell = [tableView dequeueReusableCellWithIdentifier:identifierP];

            if (![[NSString stringWithFormat:@"%@",[dictionary objectForKey:@"iconPhotoDBID"]] isEqualToString:@"noIcon"]) {
                if ([[[[appDelegate photoManager] photoDic] objectForKey:[NSString stringWithFormat:@"id%@",[dictionary objectForKey:@"iconPhotoDBID"]]] objectForKey:@"path"]!=0) {
                    if ([iconDic objectForKey:[NSString stringWithFormat:@"id%@",[dictionary objectForKey:@"iconPhotoDBID"]]]!=nil) {
                        UIImage *img=[iconDic objectForKey:[NSString stringWithFormat:@"id%@",[dictionary objectForKey:@"iconPhotoDBID"]]];
                        cell.ivIcon.image=img;
                    }
                    else {
                        UIImage *img=[[appDelegate photoManager] getPhotoByPhotoDBID:[dictionary objectForKey:@"iconPhotoDBID"]];
                        [iconDic setObject:img forKey:[NSString stringWithFormat:@"id%@",[dictionary objectForKey:@"iconPhotoDBID"]]];
                        cell.ivIcon.image=img;
                    }
                    
                }
                else {
                    //load icon
                    if ([[[appDelegate photoManager] photoDic] objectForKey:[NSString stringWithFormat:@"id%@", [dictionary objectForKey:@"iconPhotoDBID"]]]==nil) {
                        [self loadPhotoFromServer:[[dictionary objectForKey:@"iconPhotoDBID"] intValue]];
                    }
                }
            }
            else {
                UIImage *img=[UIImage imageNamed:@"Persondot.png"];
                cell.ivIcon.image=img;
            }
            
            NSDate *date = [dictionary objectForKey:@"date"];
            NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
            [dateFormat setDateFormat:@"EEE, dd MMM HH:mm"];
            NSString *theDate = [dateFormat stringFromDate:date];
            NSString *timeStr=[NSString stringWithFormat:@"%@",theDate];
            cell.lbPostTime.text = timeStr;
            
            cell.lbName.text=[NSString stringWithFormat:@"%@",[dictionary objectForKey:@"userName"]];
            ///////////////////////////////////////////////////////////
//            width = 200;
//            heigh = 150;
            cell.lbPostContent.text=[NSString stringWithFormat:@""];

            if ([photosDic objectForKey:[myPhotoDetailDictionary objectForKey:@"photoDBID"]]!=nil) {
                cell.ivPhoto.image=[photosDic objectForKey:[myPhotoDetailDictionary objectForKey:@"photoDBID"]];
                [UIView beginAnimations:@"describeView" context:nil];
                [UIView setAnimationDuration:0.5];
                [cell.ivPhoto setAlpha:1.0];
                [UIView commitAnimations];
            }
            else
            {
                cell.ivPhoto.alpha=0.0f;
                UIImage *img=[[appDelegate photoManager] getPhotoByPhotoDBID:[myPhotoDetailDictionary objectForKey:@"photoDBID"]];
                if (img!=nil) {
                    cell.ivPhoto.image=img;
                    [photosDic setObject:img forKey:[myPhotoDetailDictionary objectForKey:@"photoDBID"]];
                    
                    [UIView beginAnimations:@"describeView" context:nil];
                    [UIView setAnimationDuration:0.5];
                    [cell.ivPhoto setAlpha:1.0];
                    [UIView commitAnimations];
                }
            }
            cell.ivBackground1.layer.masksToBounds = YES; //没这句话它圆不起来
            cell.ivBackground1.layer.cornerRadius = 5.0; //设置图片圆角的尺度。
            
            NSArray *abcComment;
            if ([appDelegate.timelineManager.commentPostDic count]!=0) {
                NSMutableArray *arr=[appDelegate.timelineManager.commentPostDic objectForKey:self.eventID];
                
                NSPredicate *predicate = [NSPredicate predicateWithFormat:@"postID == %@", [dictionary objectForKey:@"eventPostDBID"]];
                abcComment = [arr filteredArrayUsingPredicate:predicate];
                
                if ([abcComment count]!=0) {
                    cell.lbCommentDisplay.text=[NSString stringWithFormat:@"%d",[abcComment count]];
                    cell.commentArray=[[NSMutableArray alloc] initWithArray:abcComment];
                    cell.vCommentDisplay.hidden=NO;
                    
                }
                else
                {
                    cell.vCommentDisplay.hidden=YES;
                }
                
            }
            else
            {
                cell.vCommentDisplay.hidden=YES;
            }
            
            if ([appDelegate.timelineManager.likePostDic count]!=0) {
                NSMutableArray *arr=[appDelegate.timelineManager.likePostDic objectForKey:self.eventID];
                
                NSPredicate *predicate = [NSPredicate predicateWithFormat:@"likeID == %@", [dictionary objectForKey:@"eventPostDBID"]];
                NSArray *abc = [arr filteredArrayUsingPredicate:predicate];
                
                if ([abc count]!=0) {
                    cell.lbLikeDisplay.text=[NSString stringWithFormat:@"%d",[abc count]];
                    cell.likeArray=[[NSMutableArray alloc] initWithArray:abc];

                    if ([self isIncludedUserDBIDWithPostID:[dictionary objectForKey:@"eventPostDBID"]]) {
                        cell.btLike.hidden=YES;
                        cell.btLike.enabled=NO;
                        [cell.btComment setFrame:CGRectMake(12, 297, 72, 20)];
                    }
                    else
                    {
                        cell.btLike.hidden=NO;
                        cell.btLike.enabled=YES;
                        [cell.btComment setFrame:CGRectMake(54, 297, 72, 20)];
                    }
                    
                    [cell.vLikeDisplay setHidden:NO];
                    if ([abcComment count]==0) {
                        [cell.vLikeDisplay setFrame:CGRectMake(260, 292, 64, 30)];
                    }
                    else
                    {
                        [cell.vLikeDisplay setFrame:CGRectMake(205, 292, 64, 30)];
                        
                    }
                }
                else
                {
                    [cell.vLikeDisplay setHidden:YES];

                    cell.btLike.hidden=NO;
                    cell.btLike.enabled=YES;
                    [cell.btComment setFrame:CGRectMake(54, 297, 72, 20)];
                }
                
            }
            else
            {
                [cell.vLikeDisplay setHidden:YES];

                cell.btLike.hidden=NO;
                cell.btLike.enabled=YES;
                [cell.btComment setFrame:CGRectMake(54, 297, 72, 20)];
            }
            
            [cell setUserID:[appDelegate.myDetailsManager.userInfoDic objectForKey:@"userDBID"]];
            cell.postID=[dictionary objectForKey:@"eventPostDBID"];
            cell.eventID=[self eventID];
            [cell initKumulos];
            return cell;
        }
    }
    else if ([[dictionary objectForKey:@"function"] intValue]==3) {//drinks
        EventMainPageTableCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier1];
        
        if (![[NSString stringWithFormat:@"%@",[dictionary objectForKey:@"iconPhotoDBID"]] isEqualToString:@"noIcon"]) {
            if ([[[[appDelegate photoManager] photoDic] objectForKey:[NSString stringWithFormat:@"id%@",[dictionary objectForKey:@"iconPhotoDBID"]]] objectForKey:@"path"]!=0) {
                if ([iconDic objectForKey:[NSString stringWithFormat:@"id%@",[dictionary objectForKey:@"iconPhotoDBID"]]]!=nil) {
                    UIImage *img=[iconDic objectForKey:[NSString stringWithFormat:@"id%@",[dictionary objectForKey:@"iconPhotoDBID"]]];
                    cell.ivIcon.image=img;
                }
                else {
                    UIImage *img=[[appDelegate photoManager] getPhotoByPhotoDBID:[dictionary objectForKey:@"iconPhotoDBID"]];
                    if(img!= NULL){
                    [iconDic setObject:img forKey:[NSString stringWithFormat:@"id%@",[dictionary objectForKey:@"iconPhotoDBID"]]];
                        cell.ivIcon.image=img;
                    }
                }
                
            }
            else {
                //load icon
                if ([[[appDelegate photoManager] photoDic] objectForKey:[NSString stringWithFormat:@"id%@", [dictionary objectForKey:@"iconPhotoDBID"]]]==nil) {
                    [self loadPhotoFromServer:[[dictionary objectForKey:@"iconPhotoDBID"] intValue]];
                }
            }
        }
        else {
            UIImage *img=[UIImage imageNamed:@"Persondot.png"];
            cell.ivIcon.image=img;
        }
        
        NSDate *date = [dictionary objectForKey:@"date"];
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"EEE, dd MMM HH:mm"];
        NSString *theDate = [dateFormat stringFromDate:date];
        NSString *timeStr=[NSString stringWithFormat:@"%@",theDate];
        cell.lbPostTime.text = timeStr;
        
        cell.lbName.text=[NSString stringWithFormat:@"%@",[dictionary objectForKey:@"userName"]];
        
        NSMutableData *data = [dictionary objectForKey:@"drinksID"];
        NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
        NSMutableDictionary *myDictionary = [unarchiver decodeObjectForKey:@"DrinkDetail"];
        [unarchiver finishDecoding];
        
//        NSLog(@"%@",myDictionary);
        
        Drinks *drink=[appDelegate.addDrinkManager selectADrinkID:[myDictionary objectForKey:@"drinksID"]];
        NSString *title = [NSString stringWithFormat:@"Drinks a %@",drink.drinkName ];
//        cell.lbPostContent.text = title;
        CGSize labelSize = { 300, 20000.0 };
        [cell.lbPostContent setFont:[UIFont systemFontOfSize:17]];
        [cell.lbPostContent setText:title];
        [cell.lbPostContent setLineBreakMode:UILineBreakModeWordWrap];
        [cell.lbPostContent setNumberOfLines:0];
        CGSize textSize = [[cell.lbPostContent text] sizeWithFont:[UIFont systemFontOfSize:17] constrainedToSize:labelSize lineBreakMode:UILineBreakModeWordWrap];
        [cell.lbPostContent setFrame:CGRectMake(20, 62, 280, textSize.height)];
        [cell.vBottom setFrame:CGRectMake(10, textSize.height+62, 300, 30)];
        [cell.ivBackground1 setFrame:CGRectMake(10, 5, 300, textSize.height+62)];
        cell.ivBackground1.layer.masksToBounds = YES; //没这句话它圆不起来
        cell.ivBackground1.layer.cornerRadius = 5.0; //设置图片圆角的尺度。
        
        
        
        
        
        
        NSArray *abcComment;
        if ([appDelegate.timelineManager.commentPostDic count]!=0) {
            NSMutableArray *arr=[appDelegate.timelineManager.commentPostDic objectForKey:self.eventID];
            
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"postID == %@", [dictionary objectForKey:@"eventPostDBID"]];
            abcComment = [arr filteredArrayUsingPredicate:predicate];
            
            if ([abcComment count]!=0) {
                cell.lbCommentDisplay.text=[NSString stringWithFormat:@"%d",[abcComment count]];
                cell.commentArray=[[NSMutableArray alloc] initWithArray:abcComment];
                cell.vCommentDisplay.hidden=NO;
                
            }
            else
            {
                cell.vCommentDisplay.hidden=YES;
            }
            
        }
        else
        {
            cell.vCommentDisplay.hidden=YES;
        }
        
        if ([appDelegate.timelineManager.likePostDic count]!=0) {
            NSMutableArray *arr=[appDelegate.timelineManager.likePostDic objectForKey:self.eventID];
            
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"likeID == %@", [dictionary objectForKey:@"eventPostDBID"]];
            NSArray *abc = [arr filteredArrayUsingPredicate:predicate];
            
            if ([abc count]!=0) {
                cell.lbLikeDisplay.text=[NSString stringWithFormat:@"%d",[abc count]];
                cell.likeArray=[[NSMutableArray alloc] initWithArray:abc];

                if ([self isIncludedUserDBIDWithPostID:[dictionary objectForKey:@"eventPostDBID"]]) {
                    cell.btLike.hidden=YES;
                    cell.btLike.enabled=NO;
                    [cell.btComment setFrame:CGRectMake(2, 5, 72, 20)];
                }
                else
                {
                    cell.btLike.hidden=NO;
                    cell.btLike.enabled=YES;
                    [cell.btComment setFrame:CGRectMake(44, 5, 72, 20)];
                }
                [cell.vLikeDisplay setHidden:NO];
                if ([abcComment count]==0) {
                    [cell.vLikeDisplay setFrame:CGRectMake(250, 0, 64, 30)];
                }
                else
                {
                    [cell.vLikeDisplay setFrame:CGRectMake(195, 0, 64, 30)];
                    
                }
            }
            else
            {
                [cell.vLikeDisplay setHidden:YES];

                cell.btLike.hidden=NO;
                cell.btLike.enabled=YES;
                [cell.btComment setFrame:CGRectMake(44, 5, 72, 20)];
            }
            
        }
        else
        {
            [cell.vLikeDisplay setHidden:YES];

            cell.btLike.hidden=NO;
            cell.btLike.enabled=YES;
            [cell.btComment setFrame:CGRectMake(44, 5, 72, 20)];
        }
        
        
        [cell setUserID:[appDelegate.myDetailsManager.userInfoDic objectForKey:@"userDBID"]];
        cell.postID=[dictionary objectForKey:@"eventPostDBID"];
        cell.eventID=[self eventID];
        [cell initKumulos];

        return cell;
    }
    
    return nil;
}

-(Boolean) isIncludedUserDBIDWithPostID:(NSString *)postID
{
    Boolean isIncluded=NO;
    for (int i=0; i<[[appDelegate.timelineManager.likePostDic objectForKey:self.eventID] count]; i++) {
        if ([[[[[appDelegate.timelineManager.likePostDic objectForKey:self.eventID] objectAtIndex:i] objectForKey:@"userID"] objectForKey:@"userDBID"] intValue]==[[appDelegate.myDetailsManager.userInfoDic objectForKey:@"userDBID"] intValue]&&[[[[appDelegate.timelineManager.likePostDic objectForKey:self.eventID] objectAtIndex:i] objectForKey:@"likeID"] intValue]==[postID intValue]) {
            return YES;
        }
    }
    return isIncluded;
}
#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([indexPath row]==[_datasource count]-20) {
        if ([_datasource count]>=5*(moreButtonClickTime+1)+addPost) {
            [appDelegate.timelineManager reloadPostByEventID:self.eventID];
            moreButtonClickTime++;
        }
    }
    
    ////load photo from server
    NSDictionary *dictionary = [_datasource objectAtIndex:indexPath.row];
    
    //load event photo
    if([[dictionary objectForKey:@"function"] intValue]==2)
    {
        NSData *data = [dictionary objectForKey:@"photoDetail"];            
        NSDictionary *myPhotoDetailDictionary = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        
        NSLog(@"%@",myPhotoDetailDictionary);
        
        if ([[[[[appDelegate photoManager] photoDic] objectForKey:[NSString stringWithFormat:@"id%@", [myPhotoDetailDictionary objectForKey:@"photoDBID"]]] objectForKey:@"path"] length]==0) {
            [self loadPhotoFromServer:[[myPhotoDetailDictionary objectForKey:@"photoDBID"] intValue]];
        }
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
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
    if ([theResults count]!=0) {
        [[appDelegate photoManager] addPhoto:[[theResults objectAtIndex:0] objectForKey:@"photoValue"] text:[[theResults objectAtIndex:0] objectForKey:@"textValue"] PhotoDBID:[[theResults objectAtIndex:0] objectForKey:@"photosDBID"]];
        UIImage *img=[[appDelegate photoManager] getPhotoByPhotoDBID:[[theResults objectAtIndex:0] objectForKey:@"photosDBID"]];
        
        [photosDic setObject:img forKey:[[theResults objectAtIndex:0] objectForKey:@"photosDBID"]];
        [self._tableView reloadData];
    }
    else
    {
        
    }
}

#pragma mark -
#pragma mark EGORefreshTableHeaderDelegate Methods

- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view{
    [self reloadTableViewDataSource];
    //    [self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:3.0];
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
    
    [appDelegate.timelineManager reloadAllPostByEventID:eventID];///////////////reload data from server
    _reloading = YES;
    
}

- (void)doneLoadingTableViewData{
    //  model should call this when its done loading
    _reloading = NO;
    [refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self._tableView];
}

- (IBAction)segmentControlAction:(id)sender {
    UISegmentedControl *segmentedControl = (UISegmentedControl *) sender;

    [self getPostByFunction:segmentedControl.selectedSegmentIndex];     
    [self doneLoadingTableViewData];

}


- (void) getPostByFunction:(int) function
{
    _datasource = [NSMutableArray new];

    for (int i=0; i<[[[appDelegate.timelineManager timelineDic] objectForKey:eventID] count]; i++)
    {        
        if (function==0) {//all
           
//            NSData *data = [[[[timelineManager timelineDic] objectForKey:eventID] objectAtIndex:i] objectForKey:@"photoDetail"];            
//            NSDictionary *myDictionary = [NSKeyedUnarchiver unarchiveObjectWithData:data];
//
//            NSLog(@"%@",myDictionary);
            
            
            NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
            [dictionary setObject:[[[[appDelegate.timelineManager timelineDic] objectForKey:eventID] objectAtIndex:i] objectForKey:@"eventPostDBID"] forKey:@"eventPostDBID"];
            [dictionary setObject:[[[[appDelegate.timelineManager timelineDic] objectForKey:eventID] objectAtIndex:i] objectForKey:@"textValue"] forKey:@"chat"];
            [dictionary setObject:[[[[appDelegate.timelineManager timelineDic] objectForKey:eventID] objectAtIndex:i] objectForKey:@"drinksDetail"] forKey:@"drinksID"];
            [dictionary setObject:[[[[appDelegate.timelineManager timelineDic] objectForKey:eventID] objectAtIndex:i] objectForKey:@"photoDetail"] forKey:@"photoDetail"];
            [dictionary setObject:[[[[appDelegate.timelineManager timelineDic] objectForKey:eventID] objectAtIndex:i] objectForKey:@"function"] forKey:@"function"];
            [dictionary setObject:[[[[[appDelegate.timelineManager timelineDic] objectForKey:eventID] objectAtIndex:i] objectForKey:@"userID"] objectForKey:@"userName"] forKey:@"userName"];
            [dictionary setObject:[[[[[appDelegate.timelineManager timelineDic] objectForKey:eventID] objectAtIndex:i] objectForKey:@"userID"] objectForKey:@"userDBID"] forKey:@"userDBID"];
            
            if ([[[[[[appDelegate.timelineManager timelineDic] objectForKey:eventID] objectAtIndex:i] objectForKey:@"userID"] objectForKey:@"photosDBID"] intValue]!=0) {
                [dictionary setObject:[[[[[appDelegate.timelineManager timelineDic] objectForKey:eventID] objectAtIndex:i] objectForKey:@"userID"] objectForKey:@"photosDBID"] forKey:@"iconPhotoDBID"];
            }
            else {
                [dictionary setObject:[NSString stringWithFormat:@"noIcon"] forKey:@"iconPhotoDBID"];
                
            }
            
            NSDate *date=[[[[appDelegate.timelineManager timelineDic] objectForKey:eventID]objectAtIndex:i] objectForKey:@"timeCreated"];
            [dictionary setObject:date forKey:@"date"];
            
            [_datasource addObject:dictionary];
        }
//        else {//drink,photo
//            if ([[[[[timelineManager timelineDic] objectForKey:eventID] objectAtIndex:i] objectForKey:@"function"] intValue]==function) {
//                NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
//                [dictionary setObject:[[[[timelineManager timelineDic] objectForKey:eventID] objectAtIndex:i] objectForKey:@"textValue"] forKey:@"chat"];
//                [dictionary setObject:[[[[timelineManager timelineDic] objectForKey:eventID] objectAtIndex:i] objectForKey:@"drinksDetail"] forKey:@"drinksID"];
//                [dictionary setObject:[[[[timelineManager timelineDic] objectForKey:eventID] objectAtIndex:i] objectForKey:@"photoDetail"] forKey:@"photoDetail"];
//                [dictionary setObject:[[[[timelineManager timelineDic] objectForKey:eventID] objectAtIndex:i] objectForKey:@"function"] forKey:@"function"];
//                [dictionary setObject:[[[[[timelineManager timelineDic] objectForKey:eventID] objectAtIndex:i] objectForKey:@"userID"] objectForKey:@"userName"] forKey:@"userName"];
//                if ([[[[[[timelineManager timelineDic] objectForKey:eventID] objectAtIndex:i] objectForKey:@"userID"] objectForKey:@"photosDBID"] intValue]!=0) {
//                    [dictionary setObject:[[[[[timelineManager timelineDic] objectForKey:eventID] objectAtIndex:i] objectForKey:@"userID"] objectForKey:@"photosDBID"] forKey:@"iconPhotoDBID"];
//                }
//                else {
//                    [dictionary setObject:[NSString stringWithFormat:@"noIcon"] forKey:@"iconPhotoDBID"];
//                    
//                }
//                
//                NSDate *date=[[[[timelineManager timelineDic] objectForKey:eventID]objectAtIndex:i] objectForKey:@"timeCreated"];
//                [dictionary setObject:date forKey:@"date"];
//                
//                [_datasource addObject:dictionary];
//            }
//        }
    }
    [_tableView reloadData];       
}
/////////////////////////////////////////////////////////////////////////////////////////////


@end
