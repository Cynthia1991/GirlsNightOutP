//
//  EventMainPageViewController.h
//  GurlsNightOut
//
//  Created by calvin on 17/04/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TimeScroller.h"
//#import "TimelineManager.h"
#import "AppDelegate.h"
#import "Kumulos.h"
#import "EGORefreshTableHeaderView.h"
#import "MTStatusBarOverlay.h"
#import "ACStatusBarOverlayWindow.h"

#define kTriggerOffSet 100.0f

@interface EventMainPageViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, TimeScrollerDelegate,KumulosDelegate,EGORefreshTableHeaderDelegate,UIActionSheetDelegate,MBProgressHUDDelegate,MTStatusBarOverlayDelegate,ACStatusBarOverlayWindowDelegate>
{
    EGORefreshTableHeaderView *refreshHeaderView;
    BOOL _reloading;

    CGPoint touchBeganPoint;
    
    BOOL homeViewIsOutOfStage;
    
    
    NSMutableArray *_datasource;
    TimeScroller *_timeScroller;
    
    ///////////////////////////////
    
    AppDelegate *appDelegate;
    
    NSInteger moreButtonClickTime;
    NSInteger addPost;
    
    NSMutableDictionary *iconDic;
    NSMutableDictionary *photosDic;
    
    CGRect imageLocation;
    UIImageView *largeImgView;
    
    MTStatusBarOverlay *overlay;
    
    ACStatusBarOverlayWindow *overlayWindow;

}
@property (nonatomic, retain) NSString *eventID;
@property (nonatomic) NSInteger addPost;
@property (nonatomic) NSInteger moreButtonClickTime;
@property (strong, nonatomic) IBOutlet UITableView *_tableView;
@property (strong, nonatomic) IBOutlet UISegmentedControl *mySegmentedControl;
@property (strong, nonatomic) IBOutlet UIView *largeImageView;
@property (strong, nonatomic) IBOutlet UIView *largeImageBackgroundView;
@property (strong, nonatomic) MBProgressHUD *HUD;
@property (strong, nonatomic) NSMutableArray *friendsArray;

- (void)reloadData:(NSNotification*) notification;
- (void)reloadPost:(NSNotification*) notification;
- (void)reloadTableViewDataSource;
- (void)doneLoadingTableViewData;
- (IBAction)segmentControlAction:(id)sender;
- (void)saveImage:(UILongPressGestureRecognizer *)recognizer;//long press detect
- (void)hideImage:(UITapGestureRecognizer *)recognizer;//long press detect
- (void)contentViewClicked:(UITapGestureRecognizer *)gestureRecognizer;

@end
