//
//  AddEventsViewController.h
//  GurlsNightOut
//
//  Created by Calvin on 7/04/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "AddFunctionCell.h"
#import "AddFunctionLabelCell.h"
#import "EventListController.h"
#import "Kumulos.h"
#import "AppDelegate.h"
#import "PlaceAnnotation.h"
#import "BumpConnector.h"
#import "MBProgressHUD.h"

@interface AddEventsViewController : UIViewController<KumulosDelegate,UIActionSheetDelegate,UITextFieldDelegate,MKMapViewDelegate,UITableViewDelegate,UITableViewDataSource,MBProgressHUDDelegate,CLLocationManagerDelegate>
{
    NSMutableArray *titleArray;
    NSMutableArray *friendsArray;
    NSMutableArray *tempFriendsArrayTableView;
    NSMutableDictionary *newEventDic;
    
    AppDelegate *appDelegate;
    
    NSInteger actionSheetFunction;
    UIActionSheet *actionSheetDate;
    
    UIAlertController *alertControllerDate;

    UIDatePicker *pickerViewDate;
    NSDate *eventDate;
    
    NSIndexPath *indexTableView;
    
    NSString *locationName;
    NSString *locationAddress;
    float locationLatitude;
    float locationLongitude;
	CLLocationManager *currentLocation;

    NSString *eventName;
    
    NSInteger function;//0=add event,1=event Details edit,2=event details display
    NSMutableDictionary *iconDic;
    
    BumpConnector *bumpConn;

    NSInteger postFriendTimes;
}
@property (nonatomic, retain) EventListController *eventListController;
@property (nonatomic, retain) NSMutableArray *friendsArray;

@property (nonatomic, retain) NSMutableArray *friendsArrayInEventDetails;
@property (nonatomic) NSInteger addFriendsInEventDetailsFunction;


@property (nonatomic, retain) NSString *locationName;
@property (nonatomic, retain) NSString *locationAddress;
@property (nonatomic, retain) CLLocationManager *currentLocation;
@property (nonatomic) float locationLatitude;
@property (nonatomic) float locationLongitude;;
@property (nonatomic, retain) NSString *eventName;
@property (nonatomic, retain) NSString *eventDetails;
@property (nonatomic, retain) NSString *eventIconDBID;
@property (nonatomic, retain) NSDate *eventDate;
@property (nonatomic) NSInteger function;;////0=add event,1=event Details edit, 2=event detail display
@property (nonatomic) NSInteger eventDBID;

@property (nonatomic) Boolean isActivity;//0=current,1=pass


@property (strong, nonatomic) IBOutlet UISegmentedControl *mySegumentedControll;
@property (strong, nonatomic) IBOutlet UIView *footerView;
@property (strong, nonatomic) IBOutlet UIView *headerView;
@property (strong, nonatomic) IBOutlet MKMapView *myMapView;
@property (strong, nonatomic) IBOutlet UILabel *lbEventName;
@property (strong, nonatomic) IBOutlet UILabel *lbEventTime;
@property (strong, nonatomic) IBOutlet UILabel *lbEventDetails;
@property (strong, nonatomic) IBOutlet UIButton *btEventIcon;
@property (strong, nonatomic) IBOutlet UIButton *btTimeline;
@property (strong, nonatomic) IBOutlet UIButton *btCancel;
@property (strong, nonatomic) IBOutlet UIButton *btDone;
@property (strong, nonatomic) IBOutlet UIButton *btEdit;
@property (strong, nonatomic) IBOutlet UIButton *btBack;
@property (strong, nonatomic) IBOutlet UILabel *lbEventStartTime;
@property (weak, nonatomic) IBOutlet UILabel *lbInvitedBy;
@property (strong, nonatomic) IBOutlet UIImageView *ivBackground;

@property (strong, nonatomic) IBOutlet UITableView *_tableView;
@property (strong,nonatomic) MBProgressHUD *HUD;

- (IBAction)doneButtonAction:(id)sender;
- (IBAction)cancelButtonAction:(id)sender;
- (IBAction)btTimelineAction:(id)sender;
- (IBAction)sgmAction:(id)sender;
- (IBAction)backButtonAction:(id)sender;
- (IBAction)editButtonAction:(id)sender;
- (void) popPicker;
- (IBAction)btEventIconAction:(id)sender;
- (void) initHeaderView:(NSNotification*) notification;

@end
