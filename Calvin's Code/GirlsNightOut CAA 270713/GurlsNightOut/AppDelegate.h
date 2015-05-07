//
//  AppDelegate.h
//  GurlsNightOut
//
//  Created by calvin on 3/04/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyDetailsManager.h"
#import "FriendsManager.h"
#import "EventsManager.h"
#import "Drinks.h"
#import "PhotoManager.h"
#import "TimelineManager.h"
#import "AddDrinkManager.h"
#import <AVFoundation/AVFoundation.h>
#import "FBConnect.h"
#import "MBProgressHUD.h"
#import "MTStatusBarOverlay.h"
#import "EmergencyManager.h"
#import "InstructionManager.h"

@class MenuViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate,FBSessionDelegate,FBRequestDelegate,MTStatusBarOverlayDelegate,UIActionSheetDelegate,KumulosDelegate>
{
    AVAudioPlayer *audioPlayer;
    Facebook *facebook;
    
    NSMutableData *receivedData;

}
@property (strong, nonatomic) UIWindow *window;
@property (retain, nonatomic) IBOutlet UINavigationController *navController;
@property (retain, nonatomic) MenuViewController *menuViewController;
@property (retain, nonatomic) MyDetailsManager *myDetailsManager;
@property (retain, nonatomic) FriendsManager *friendsManager;
@property (retain, nonatomic) EventsManager *eventsManager;
@property (retain, nonatomic) PhotoManager *photoManager;
@property (retain, nonatomic) TimelineManager *timelineManager;
@property (retain, nonatomic) AddDrinkManager *addDrinkManager;
@property (retain, nonatomic) EmergencyManager *emergencyManager;
@property (retain, nonatomic) InstructionManager *instructionManager;
@property (retain, nonatomic) NSString *eventID;
@property (nonatomic, retain) Facebook *facebook;


@property (nonatomic, strong) FBRequest *me;
@property (nonatomic, strong) FBRequest *photoAlbums;
@property (nonatomic, strong) FBRequest *profilePics;
@property (nonatomic, strong) FBRequest *getProfilePics;

-(void)CallToFindProfilePics:(NSString *)PicsID;
-(void)getProfilePics:(NSString *)PicsID;


@property (retain, nonatomic) NSString *addFriendDBID;
@property (retain, nonatomic) NSString *addFriendName;
@property (nonatomic) Boolean isConnectInternet;


- (void)initMyDetailsManager;
- (void)initFriendsManager;
- (void)facebookLogin;
- (void)facebookLogout;
- (void)sendNotificationWithFriendsList:(NSMutableArray*)friendsList Content:(NSString*) content1 UserID:(NSString *)userID1 EventID:(NSString*)eventID1 function:(NSInteger) function1;
- (void)sendStatusBarNotificationWithContent:(NSString *)content;
- (void)sendNotificationForTimelineWithFriendsList:(NSMutableArray*)friendsList Content:(NSString*) content1 UserID:(NSString *)userID1 EventID:(NSString*)eventID1 function:(NSInteger) function1 PostFunction:(NSInteger)postFunction eventPostDBID:(NSInteger) eventPostDBID timeCreated:(NSString*)timeCreated photoDBID:(NSMutableDictionary*)photoDic drinkID:(NSMutableDictionary*)drinkDic;

- (void)saveUserDetails:(NSNotification*) notification;
-(BOOL) internetChecker;
- (void) openTimelineByNotificationWithUserInfoNotificationCenter:(NSNotification*)notification;
-(void) addIcon:(NSNotification*)notification;
-(void) deleteIcon:(NSNotification*)notification;

@end
