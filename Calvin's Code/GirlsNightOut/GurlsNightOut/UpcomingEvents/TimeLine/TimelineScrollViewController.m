//
//  TimelineScrollViewController.m
//  gno
//
//  Created by calvin on 31/05/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

#import "TimelineScrollViewController.h"
#import "EventMainPageViewController.h"
#import "EventAddFriendsViewController.h"
#import "AddTimelineTextViewController.h"
#import "DrinkTableViewController.h"
#import "instructionViewController.h"
#import "QDViewController.h"
#import "EventMainPageTableCell.h"
#import "gameMainViewController.h"
#import "spinViewController.h"


@interface TimelineScrollViewController ()

@end

@implementation TimelineScrollViewController
@synthesize menuButton;
@synthesize myScrollView;
@synthesize myScrollViewRootView;
@synthesize timelineNavigationController,addDrinksNavigationController,quickDialNavigationController,eventID,bumpKumulosHandler,isActivity,friendsList;


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
    [myPageControl setCurrentPage:0];

	// Do any additional setup after loading the view.
    appDelegate=(AppDelegate*)[[UIApplication sharedApplication] delegate];
    appDelegate.addDrinkManager.enteredDrinkList=nil;
    
    timelineNavigationController=[self.storyboard instantiateViewControllerWithIdentifier:@"timelineNavController"];
    timelineNavigationController.view.frame=CGRectMake(640, 0, 320, [[UIScreen mainScreen] bounds].size.height-20);

    
    EventMainPageViewController *rootViewController = (EventMainPageViewController *)[timelineNavigationController topViewController];
    rootViewController.eventID=[self eventID];
    appDelegate.timelineManager=[[TimelineManager alloc] initByEventID:eventID];
//    [appDelegate.timelineManager reloadAllPostByEventID:eventID];///////////////reload data from server

//    rootViewController.timelineManager=appDelegate.timelineManager;
    
    
    addDrinksNavigationController=[self.storyboard instantiateViewControllerWithIdentifier:@"addDrinksNavController"];
    addDrinksNavigationController.view.frame=CGRectMake(960, 0, 320, [[UIScreen mainScreen] bounds].size.height-20);
    DrinkTableViewController *drinkTableViewController=(DrinkTableViewController*)[addDrinksNavigationController topViewController];
    [drinkTableViewController setEventDBID:[[self eventID] intValue]];
    [drinkTableViewController setUserDBID:[[appDelegate.myDetailsManager.userInfoDic objectForKey:@"userDBID"] intValue]];
    [drinkTableViewController setEventMainPageViewController:rootViewController];
    drinkTableViewController.myScrollView=[self myScrollView];
    drinkTableViewController.isActivity=isActivity;
    
    quickDialNavigationController=[self.storyboard instantiateViewControllerWithIdentifier:@"quickDialNavigationController"];
    quickDialNavigationController.view.frame=CGRectMake(320, 0, 320, [[UIScreen mainScreen] bounds].size.height-20);
    QDViewController *quickDialViewController=(QDViewController*)[quickDialNavigationController topViewController];
    quickDialViewController.eventDBID=[NSString stringWithFormat:@"%@",[self eventID]];
    
    self.gameNavigationController = [self.storyboard instantiateViewControllerWithIdentifier:@"gameNavController"];
    self.gameNavigationController.view.frame=CGRectMake(0, 0, 320, [[UIScreen mainScreen] bounds].size.height-20);
    
    gameMainViewController *spinVC=(gameMainViewController*)[self.gameNavigationController topViewController];
    spinVC.eventID = [NSString stringWithFormat:@"%@",[self eventID]];
    spinVC.TLSVC = self;

//    UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 460)];
    
    myScrollView.contentSize=CGSizeMake(320*4, [[UIScreen mainScreen] bounds].size.height-20);
    [myScrollView addSubview:self.gameNavigationController.view];
    [myScrollView addSubview:quickDialNavigationController.view];
    [myScrollView addSubview:timelineNavigationController.view];
    [myScrollView addSubview:addDrinksNavigationController.view];
    [myScrollView setContentOffset:CGPointMake(640, 0)];
    
    [myPageControl setCurrentPage:2];
    
    bumpConn = [[BumpConnector alloc] init];	

    
    [[NSNotificationCenter defaultCenter]  addObserver:self selector:@selector(popupAddCommentView:) name:@"popup add comment view" object:nil];
    [[NSNotificationCenter defaultCenter]  addObserver:self selector:@selector(addTextActionFunction:) name:@"popup add status view" object:nil];

    bumpKumulosHandler=[[BumpKumulosHandler alloc] init];
    bumpKumulosHandler.timelineScrollViewController=self;
    bumpKumulosHandler.eventID=[self.eventID intValue];
    
    
    ///////instruction
    if ([[appDelegate.instructionManager.instructionDic objectForKey:@"timeline"] boolValue]) {
        [self.scvTimelineInstruction setHidden:YES];
    }
    else
    {
        [self.scvTimelineInstruction setHidden:NO];
    }
	// Do any additional setup after loading the view.
    self.scvTimelineInstruction.contentSize=CGSizeMake(320*7, [[UIScreen mainScreen] bounds].size.height-20);
    [self.scvTimelineInstruction setContentOffset:CGPointMake(0, 0)];
    
}
- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"addPhotoSegue"]) {        
        NSUserDefaults *userPreferences = [NSUserDefaults standardUserDefaults];
        [userPreferences setObject:[NSString stringWithFormat:@"0"] forKey:@"addPhotosFunction"];
        [userPreferences setObject:[self eventID] forKey:@"currentEventID"];
        [userPreferences setObject:[appDelegate.myDetailsManager.userInfoDic objectForKey:@"userDBID"] forKey:@"currentUserID"];
        [userPreferences synchronize];
    }
    
    if ([segue.identifier isEqualToString:@"gameMainToGame"])
    {      
        
        UINavigationController *navController = (UINavigationController*)[segue destinationViewController];

        spinViewController *mView =(spinViewController*)[navController topViewController];

        mView.eventID = self.eventID;

    }
    
    
    
        
    
}
- (void)viewDidUnload
{
    [self setMyScrollView:nil];
    animationImg = nil;
    [self setMyScrollViewRootView:nil];
    homeButtonView = nil;
    [self setMenuButton:nil];
    myPageControl = nil;
    popUpView = nil;
    addPhotoView = nil;
    iAmHomeView = nil;
    [self setScvTimelineInstruction:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

#pragma mark - home button action
- (IBAction)homeAction:(UIButton*)sender {
    switch (menuButtonFunction) {
        case 0: {
            NSLog(@"show");
            if (isActivity) {
                //[self dismissModalViewControllerAnimated:YES];
                [self dismissViewControllerAnimated:NO
                                                       completion:nil];
            }
            else
            {
                [self showRoundMenu];
            }
        }
            break;
        case 1: {
            NSLog(@"hide");
            [self hideRoundMenu:0];
        }
            break;
        default:
            break;
    }    
}
- (IBAction)touchMenuBackgroudViewAction:(id)sender {
    [self hideRoundMenu:0];
}

#pragma mark - home button function and annomition
- (void)showRoundMenu {
    [menuButton setEnabled:NO];
    [menuBackgroundView setUserInteractionEnabled:NO];
    [homeButtonView setUserInteractionEnabled:NO];
    
    UIGraphicsBeginImageContext(self.view.bounds.size);
    [self.myScrollViewRootView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    animationImg.image=image;
    [animationImg setAlpha:1.0f];
    [myScrollView setAlpha:0.0f];

    
    transformed= [CALayer layer];
    transformed.frame = CGRectMake(0, 0, 320, 460);

    imageLayer= [animationImg layer];

    [transformed addSublayer:imageLayer];

    [self.view.layer addSublayer:transformed];

    [self.view bringSubviewToFront:menuBackgroundView];
    [self.view bringSubviewToFront:popUpView];
    [self.view bringSubviewToFront:dismissView];
    [self.view bringSubviewToFront:quickDialView];
    [self.view bringSubviewToFront:addFriendsView];
    [self.view bringSubviewToFront:addTextView];
    [self.view bringSubviewToFront:addPhotoView];
    [self.view bringSubviewToFront:iAmHomeView];
    [self.view bringSubviewToFront:homeButtonView];
    
    ///////////////////////////////////////////////
    [UIView beginAnimations:@"describeView" context:nil];
    [UIView setAnimationDuration:0.3];
    CGRect ntViewFrame1=[popUpView frame];
    
    ntViewFrame1.origin.y=[[UIScreen mainScreen] bounds].size.height-360;
    
    popUpView.frame=ntViewFrame1;
    
    [UIView commitAnimations];
    ///////////////////////////////////////////////
    [UIView animateWithDuration:0.3
                     animations:^{ 

                         imageLayer.frame = CGRectMake(35.0f, 0.0f, 250.0f, 359.0f);
                         imageLayer.transform = CATransform3DMakeRotation(15.0f * M_PI / 180.0f,
                                                                          1.0f, 0.0f, 0.0f);
                         
                         CATransform3D initialTransform = transformed.sublayerTransform;
                         initialTransform.m34 = 1.0 / -500;
                         transformed.sublayerTransform = initialTransform;
                         [menuBackgroundView setAlpha:0.5f];
                         
                     } 
                     completion:^(BOOL finished){
                         [UIView animateWithDuration:0.2
                                          animations:^{ 
                                              imageLayer.frame = CGRectMake(35.0f, 0.0f, 250.0f, 359.0f);                                              
                                              imageLayer.transform = CATransform3DMakeRotation(M_PI / 180.0f,
                                                                                               1.0f, 0.0f, 0.0f);
                                                                                            
                                              CATransform3D initialTransform = transformed.sublayerTransform;
                                              initialTransform.m34 = 1.0 / -500;
                                              transformed.sublayerTransform = initialTransform;  
                                          } 
                                          completion:^(BOOL finished){
                                              [menuBackgroundView setUserInteractionEnabled:YES];
                                              [homeButtonView setUserInteractionEnabled:YES];
                                              [menuButton setEnabled:YES];
                                          }];

                                              

                     }];
    

    
    ///////////////////////////////////////////////
    [self annByx:280 View:quickDialView Time:0.9f];
    [self annByx:140 View:addFriendsView Time:0.8f];
    [self annByx:280 View:iAmHomeView Time:0.6f];
    [self annByx:120 View:dismissView Time:0.7f];
    [self annByx:290 View:addTextView Time:0.6f];
    [self annByx:150 View:addPhotoView Time:0.5f];
    menuButtonFunction=1;
}
- (void)hideRoundMenu:(NSInteger) function 
{
    [menuButton setEnabled:NO];
    [menuBackgroundView setUserInteractionEnabled:NO];
    [homeButtonView setUserInteractionEnabled:NO];
    
    [menuButton setEnabled:YES];

    [UIView animateWithDuration:0.3
                     animations:^{ 
                         imageLayer.frame = CGRectMake(0.0f, 0.0f, 320.0f, 460.0f);                                              
                         imageLayer.transform = CATransform3DMakeRotation(15.0f * M_PI / 180.0f,
                                                                          1.0f, 0.0f, 0.0f);
                         
                         CATransform3D initialTransform = transformed.sublayerTransform;
                         initialTransform.m34 = 1.0 / -500;
                         transformed.sublayerTransform = initialTransform; 

                     } 
                     completion:^(BOOL finished){
                         [UIView animateWithDuration:0.2
                                          animations:^{
                                              imageLayer.frame = CGRectMake(0.0f, 0.0f, 320.0f, 460.0f);                                              
                                              imageLayer.transform = CATransform3DMakeRotation(M_PI / 180.0f,
                                                                                               1.0f, 0.0f, 0.0f);
                                              
                                              CATransform3D initialTransform = transformed.sublayerTransform;
                                              initialTransform.m34 = 1.0 / -500;
                                              transformed.sublayerTransform = initialTransform; 
                                          } 
                                          completion:^(BOOL finished){
                                              [UIView animateWithDuration:0.0
                                                               animations:^{ 
                                                                   [myScrollView setAlpha:1.0f];
                                                               } 
                                                               completion:^(BOOL finished){
                                                                   [UIView animateWithDuration:0.0
                                                                                    animations:^{ 
                                                                                        [animationImg setAlpha:0.0f];
                                                                                    } 
                                                                                    completion:^(BOOL finished){
                                                                                        if (function==1) {//text
                                                                                            [self addTextActionFunction:nil];
                                                                                        }  
                                                                                        else if (function==2) {//add friends
                                                                                            [self addFriendsFunction];
                                                                                        }   
                                                                                        else if(function==3)//quick dial
                                                                                        {
                                                                                            [myScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
                                                                                        }
                                                                                        else if(function==4)
                                                                                        {
                                                                                            [self performSegueWithIdentifier:@"addPhotoSegue" sender:self];
                                                                                        }
                                                                                        [menuBackgroundView setUserInteractionEnabled:YES];
                                                                                        [homeButtonView setUserInteractionEnabled:YES];
                                                                                        [menuButton setEnabled:YES];
                                                                                    }];
                                                               }];
                                               }];
                     }];
    

    /////////////////////////////////
    [UIView beginAnimations:@"describeView" context:nil];
    [UIView setAnimationDuration:0.5];
    CGRect ntViewFrame1=[quickDialView frame];
    CGRect ntViewFrame2=[addFriendsView frame];
    CGRect ntViewFrame3=[addTextView frame];
    CGRect ntViewFrame4=[dismissView frame];
    CGRect ntViewFrame5=[popUpView frame];
    CGRect ntViewFrame6=[addPhotoView frame];
    CGRect ntViewFrame7=[iAmHomeView frame];

    ntViewFrame1.origin.x=-114;
    ntViewFrame2.origin.x=-100;
    ntViewFrame3.origin.x=-103;
    ntViewFrame4.origin.x=-82;
    ntViewFrame5.origin.y=[[UIScreen mainScreen] bounds].size.height-20;
    ntViewFrame6.origin.x=-107;
    ntViewFrame7.origin.x=-112;
    
    quickDialView.frame=ntViewFrame1;
    addFriendsView.frame=ntViewFrame2;
    addTextView.frame=ntViewFrame3;
    dismissView.frame=ntViewFrame4;
    popUpView.frame=ntViewFrame5;
    addPhotoView.frame=ntViewFrame6;
    iAmHomeView.frame=ntViewFrame7;
    
    [menuBackgroundView setAlpha:0.0f];

    [UIView commitAnimations];
    menuButtonFunction=0;
}
- (void) ann:(NSInteger) y View:(UIView*) view Time:(float) time
{
    CAKeyframeAnimation *keyAn = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    [keyAn setDuration:time];
    NSArray *array = [[NSArray alloc] initWithObjects:
                      [NSValue valueWithCGPoint:CGPointMake(view.center.x, view.center.y)],
                      [NSValue valueWithCGPoint:CGPointMake(view.center.x, view.center.y+y)],
                      [NSValue valueWithCGPoint:CGPointMake(view.center.x, view.center.y+y-20)],
                      [NSValue valueWithCGPoint:CGPointMake(view.center.x, view.center.y+y)],
                      [NSValue valueWithCGPoint:CGPointMake(view.center.x, view.center.y+y-10)],
                      [NSValue valueWithCGPoint:CGPointMake(view.center.x, view.center.y+y)],
                      nil];
    [keyAn setValues:array];
    NSArray *times = [[NSArray alloc] initWithObjects:
                      [NSNumber numberWithFloat:time-0.8f],
                      [NSNumber numberWithFloat:time-0.4f],
                      [NSNumber numberWithFloat:time-0.3f],
                      [NSNumber numberWithFloat:time-0.2f],
                      [NSNumber numberWithFloat:time-0.1f],
                      [NSNumber numberWithFloat:time],
                      nil];
    [keyAn setKeyTimes:times];
    view.layer.position = CGPointMake(view.center.x, view.center.y+y);
    [view.layer addAnimation:keyAn forKey:@"TextAnim"];
}
- (void) annByx:(NSInteger) x View:(UIView*) view Time:(float) time
{
    CAKeyframeAnimation *keyAn = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    [keyAn setDuration:time];
    NSArray *array = [[NSArray alloc] initWithObjects:
                      [NSValue valueWithCGPoint:CGPointMake(view.center.x, view.center.y)],
                      [NSValue valueWithCGPoint:CGPointMake(view.center.x+x, view.center.y)],
                      [NSValue valueWithCGPoint:CGPointMake(view.center.x+x-20, view.center.y)],
                      [NSValue valueWithCGPoint:CGPointMake(view.center.x+x, view.center.y)],
                      [NSValue valueWithCGPoint:CGPointMake(view.center.x+x-10, view.center.y)],
                      [NSValue valueWithCGPoint:CGPointMake(view.center.x+x, view.center.y)],
                      nil];
    [keyAn setValues:array];
    NSArray *times = [[NSArray alloc] initWithObjects:
                      [NSNumber numberWithFloat:time-0.8f],
                      [NSNumber numberWithFloat:time-0.4f],
                      [NSNumber numberWithFloat:time-0.3f],
                      [NSNumber numberWithFloat:time-0.2f],
                      [NSNumber numberWithFloat:time-0.1f],
                      [NSNumber numberWithFloat:time],
                      nil];
    [keyAn setKeyTimes:times];
    view.layer.position = CGPointMake(view.center.x+x, view.center.y);
    [view.layer addAnimation:keyAn forKey:@"TextAnim"];
}

#pragma mark - page control function
-(void) scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGPoint offsetofScrollView = myScrollView.contentOffset;  
    [myPageControl setCurrentPage:offsetofScrollView.x / scrollView.frame.size.width]; 
}


-(IBAction)pageClick:(id)send{    
    CGPoint offsetofScrollView = myScrollView.contentOffset;  
    [myPageControl setCurrentPage:offsetofScrollView.x / myScrollView.frame.size.width]; 
    
    CGRect rect;
    if (scollViewDirection==0) {//right
        if ([myPageControl currentPage]==1) {
            rect = CGRectMake(640, 0, myScrollView.frame.size.width, myScrollView.frame.size.height);
            [myPageControl setCurrentPage:2];
        }
        else if ([myPageControl currentPage]==2) {
            rect = CGRectMake(960, 0, myScrollView.frame.size.width, myScrollView.frame.size.height);
            [myPageControl setCurrentPage:3];
        }
        else if ([myPageControl currentPage]==3) {
            rect = CGRectMake(640, 0, myScrollView.frame.size.width, myScrollView.frame.size.height);
            scollViewDirection=1;
            [myPageControl setCurrentPage:2];
            
        }
    }
    else {//left
        if ([myPageControl currentPage]==2) {
            rect = CGRectMake(320, 0, myScrollView.frame.size.width, myScrollView.frame.size.height);
            [myPageControl setCurrentPage:1];
            
        }
        else if ([myPageControl currentPage]==1) {
            rect = CGRectMake(0, 0, myScrollView.frame.size.width, myScrollView.frame.size.height);
            [myPageControl setCurrentPage:0];
        }
        else if ([myPageControl currentPage]==0) {
            rect = CGRectMake(320, 0, myScrollView.frame.size.width, myScrollView.frame.size.height);
            [myPageControl setCurrentPage:1];
            
            scollViewDirection=0;
        }
    }
    
    [myScrollView scrollRectToVisible:rect animated:YES];
}

#pragma mark - buttons function

- (IBAction)dismissAction:(id)sender {
    
    [self dismissModalViewControllerAnimated:YES];
}

- (IBAction)addTextAction:(id)sender {
    [self hideRoundMenu:1];
}
- (void) addTextActionFunction:(NSNotification*)notification
{
    UINavigationController *addTimelineTextNav=[self.storyboard instantiateViewControllerWithIdentifier:@"addTimelineTextNav"];
    
    
    AddTimelineTextViewController *addTimelineTextViewController=(AddTimelineTextViewController *)[addTimelineTextNav topViewController];;
    addTimelineTextViewController.eventID=[self eventID];
    addTimelineTextViewController.userID=[[[appDelegate myDetailsManager] userInfoDic] objectForKey:@"userDBID"];
    addTimelineTextViewController.function=0;
    [self presentModalViewController:addTimelineTextNav animated:YES];
    [myScrollView setContentOffset:CGPointMake(320, 0) animated:YES];
}
-(void) addFriendsFunction//////add friends in timeline by selecting friendList
{
    EventAddFriendsViewController *eventAddFriendsViewController=[self.storyboard instantiateViewControllerWithIdentifier:@"EventAddFriendsViewController"];
    eventAddFriendsViewController.eventID=[self eventID];
    
    UINavigationController *eventAddFriendsNav=[[UINavigationController alloc] initWithRootViewController:eventAddFriendsViewController];

//    [timelineNavigationController popToRootViewControllerAnimated:NO];
//    [timelineNavigationController pushViewController:eventAddFriendsViewController animated:YES];
    [self presentModalViewController:eventAddFriendsNav animated:YES];

    [myScrollView setContentOffset:CGPointMake(320, 0) animated:YES];

}
#pragma mark - actionSheet
-(void)applicationWillTerminate:(UIApplication *)application{
	[bumpConn stopBump];
}

- (IBAction)addFriendsAction:(id)sender {
    [bumpConn setTimelineScrollViewController:self];
    [bumpConn setEventID:[[self eventID] intValue]];
    [bumpConn setFunction:1];
    [bumpConn startBump];
    [bumpConn sendDetails];
    
    [self hideRoundMenu:0];

//    UIActionSheet *actionSheet = [[UIActionSheet alloc]
//                                  initWithTitle:@"Add Friends Method"         //Title
//                                  delegate:self                  //delegate
//                                  cancelButtonTitle:@"Cancel" 
//                                  destructiveButtonTitle:nil
//                                  otherButtonTitles:@"Bump", @"Friends List", nil];  //button   
//    //    [actionSheet showInView:self.tabBarController.view];/////////////////////////////////////////////////////////interesting,not in tabbar has somge problem
//    [actionSheet showInView:self.view];/////////////////////////////////////////////////////////interesting,not in tabbar has somge problem
}

- (IBAction)quickDialAction:(id)sender {
    [self hideRoundMenu:3];
}

- (IBAction)addPhotosAction:(id)sender {
    [self hideRoundMenu:4];
}

- (IBAction)iAmHomeAction:(id)sender {        
    NSMutableArray *arr=[[appDelegate.eventsManager getEventDictionaryByEventID:self.eventID]objectForKey:@"eventFriends"];
    NSLog(@"%@",arr);

    for (int i=0; i<[arr count]; i++) {
        if ([[[[arr objectAtIndex:i] objectForKey:@"userID"] objectForKey:@"userDBID"] intValue]==[[appDelegate.myDetailsManager.userInfoDic objectForKey:@"userDBID"] intValue]) {
            if ([[[arr objectAtIndex:i] objectForKey:@"isHome"] intValue]==0) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Go home" message:@"Are you sure you are going home now" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes",nil];
                [alert setTag:0];
                [alert show];
            }
            else
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Already Home" message:@"You have been home already." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert setTag:0];
                [alert show];
            }
        }
    }


    
}

#pragma mark UIScrollView delegate
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    if (scrollView.tag==1)
    {
        if (scrollView.contentOffset.x>1920) {
            [UIView animateWithDuration:0.5
                             animations:^{
                                 [self.scvTimelineInstruction setAlpha:0.0];
                                 
                             }
                             completion:^(BOOL finished){
                                 [self.scvTimelineInstruction setHidden:YES];
                                 [appDelegate.instructionManager setInstructionDicWithValue:YES Key:[NSString stringWithFormat:@"timeline"]];
                             }];
        }
    }
}
- (void) scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.tag==1)
    {
        NSLog(@"%.2f",scrollView.contentOffset.x);
        if (scrollView.contentOffset.x>960.0) {
            [self.myScrollView setContentOffset:CGPointMake(960, 0) animated:YES];
        }
        else if (scrollView.contentOffset.x<1280.0)
        {
            [self.myScrollView setContentOffset:CGPointMake(640, 0) animated:YES];
        }
    }
}

#pragma mark - actionSheet delegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==0) {     

        [bumpConn setTimelineScrollViewController:self];
        [bumpConn setEventID:[[self eventID] intValue]];
        [bumpConn setFunction:1];
        [bumpConn startBump];
        [bumpConn sendDetails];
    }
    else if(buttonIndex==1){
        [self hideRoundMenu:2];
    }
}
#pragma mark - notification    
- (void)popupAddCommentView:(NSNotification*) notification{
    //  should be calling your tableviews data source model to reload
    //  put here just for demo
    NSMutableDictionary *dic=[notification object];
    
    UINavigationController *addTimelineTextNav=[self.storyboard instantiateViewControllerWithIdentifier:@"addTimelineTextNav"];
    AddTimelineTextViewController *addTimelineTextViewController=(AddTimelineTextViewController *)[addTimelineTextNav topViewController];
    addTimelineTextViewController.eventID=[dic objectForKey:@"eventID"];
    addTimelineTextViewController.postID=[dic objectForKey:@"postID"];
    addTimelineTextViewController.userID=[dic objectForKey:@"userID"];
    addTimelineTextViewController.function=1;
    if ([[dic objectForKey:@"cellType"] intValue]==0) {//chat
        EventMainPageTableCell *cell=[dic objectForKey:@"cell"];
        [addTimelineTextViewController setEventMainPageTableCell:cell];
    }
    else if ([[dic objectForKey:@"cellType"] intValue]==1)//photo
    {
        EventMainPageHTableCell *cell=[dic objectForKey:@"cell"];
        [addTimelineTextViewController setEventMainPageHTableCell:cell];
    }
    else if ([[dic objectForKey:@"cellType"] intValue]==2)//drink
    {
        EventMainPagePTableCell *cell=[dic objectForKey:@"cell"];
        [addTimelineTextViewController setEventMainPagePTableCell:cell];
    }
    [self presentModalViewController:addTimelineTextNav animated:YES];
    [myScrollView setContentOffset:CGPointMake(640, 0) animated:YES];
}

#pragma mark - UIAlertView delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag==0) {
        if (buttonIndex==1) {
            Kumulos *k=[[Kumulos alloc] init];
            [k setDelegate:self];
            [k createPostWithTextValue:[NSString stringWithFormat:@"%@ has been home.",[appDelegate.myDetailsManager.userInfoDic objectForKey:@"userName"]] andFunction:4 andDrinksDetail:nil andPhotoDetail:nil andUserID:[[appDelegate.myDetailsManager.userInfoDic objectForKey:@"userDBID"] intValue] andEventID:[self.eventID intValue]];
        }
    }
}

#pragma mark - Kumulos delegate
-(void) kumulosAPI:(Kumulos *)kumulos apiOperation:(KSAPIOperation *)operation createPostDidCompleteWithResult:(NSNumber *)newRecordID
{
    NSMutableArray *dic=[[appDelegate.eventsManager getEventDictionaryByEventID:self.eventID] objectForKey:@"eventFriends"];
    NSString *eventPeopleDBID;
    for (int i=0; i<[dic count]; i++) {
        if([[[[dic objectAtIndex:i] objectForKey:@"userID"] objectForKey:@"userDBID"] intValue]==[[appDelegate.myDetailsManager.userInfoDic objectForKey:@"userDBID"] intValue])
        {
            eventPeopleDBID=[NSString stringWithFormat:@"%d",[[[dic objectAtIndex:i] objectForKey:@"eventPeopleDBID"] intValue]];
        }
    }
    
    Kumulos *k=[[Kumulos alloc] init];
    [k setDelegate:self];
    [k updateHomeStatusWithIsHome:1 andEventPeopleDBID:[eventPeopleDBID intValue]];
}

-(void) kumulosAPI:(Kumulos *)kumulos apiOperation:(KSAPIOperation *)operation updateHomeStatusDidCompleteWithResult:(NSNumber *)affectedRows
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadFromAddFriends" object:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"addPost" object:nil];
    [self hideRoundMenu:0];
}



-(void)callGameView
{
    NSLog(@"called from Game Main");
    [self performSegueWithIdentifier:@"gameMainToGame" sender:self];
}

@end
