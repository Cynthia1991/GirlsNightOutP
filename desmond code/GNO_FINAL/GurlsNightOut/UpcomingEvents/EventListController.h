//
//  EventListController.h
//  GurlsNightOut
//
//  Created by Calvin on 7/04/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EventListCell.h"
#import "EGORefreshTableHeaderView.h"
#import "AppDelegate.h"
#import "BumpConnector.h"

@interface EventListController : UIViewController<UITextFieldDelegate,UIActionSheetDelegate,EGORefreshTableHeaderDelegate,UITableViewDataSource,UITableViewDelegate,MBProgressHUDDelegate,UIScrollViewDelegate,KumulosDelegate>
{
    EGORefreshTableHeaderView *refreshHeaderView;
    AppDelegate *appDelegate;
    BOOL _reloading;
    
    NSInteger eventIndex;
    
    BumpConnector *bumpConn;

    MBProgressHUD *HUD;
    
    NSMutableDictionary *delectEventDic;
    
    NSMutableDictionary *eventImageDic;

}
@property (nonatomic) NSInteger function;
@property (strong, nonatomic) IBOutlet UITableView *_tableView;
@property (strong, nonatomic) IBOutlet UISegmentedControl *mySegmentControl;
@property (strong, nonatomic) IBOutlet UIScrollView *scvEventListInstruction;

- (IBAction)addEventsAction:(id)sender;
- (IBAction)btBackButton:(id)sender;
- (IBAction)segmentAction:(id)sender;

- (void) reloadTableView:(NSNotification*) notification;
- (void) reloadAllevents:(NSNotification*) notification;
@end
