//
//  FriendsListViewController.h
//  GurlsNightOut
//
//  Created by Calvin on 11/04/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BumpConnector.h"
#import "AppDelegate.h"
#import "AddEventsViewController.h"
#import "EventAddFriendsViewController.h"
#import "EGORefreshTableHeaderView.h"


@interface FriendsListViewController : UIViewController <UIActionSheetDelegate,EGORefreshTableHeaderDelegate,KumulosDelegate,UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray *friendsArray;
    NSMutableArray *friendsArrayTableView;
    
    BumpConnector *bumpConn;

    AppDelegate *appDelegate;
    
    NSInteger friendFunction;
    NSString *inviteFriendEventID;
    NSMutableArray *eventFriends;
    
    EGORefreshTableHeaderView *refreshHeaderView;
    BOOL _reloading;
    
    NSString *evetnIDForAddFriends;
    
    NSMutableDictionary *iconDic;

}
@property (nonatomic, retain) NSString *inviteFriendEventID;
@property (nonatomic) NSInteger friendFunction;//0=friends manager,1=add event,2=add friend in timeline(cancel),3=event details
@property (nonatomic,retain) AddEventsViewController *addEventsViewController;
@property (nonatomic,retain) EventAddFriendsViewController *eventAddFriendsViewController;
@property (nonatomic,retain) NSMutableArray *eventFriends;
@property (nonatomic,retain) NSString *evetnIDForAddFriends;
@property (strong, nonatomic) IBOutlet UITableView *_tableView;
@property (strong, nonatomic) IBOutlet UIButton *rightButton;
@property (strong, nonatomic) IBOutlet UIView *footerView;

- (IBAction)doneAction:(id)sender;
- (IBAction)backAction:(id)sender;
- (IBAction)addFriendsAction:(id)sender;
@end
