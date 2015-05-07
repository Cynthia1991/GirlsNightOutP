//
//  BumpConnector.h
//  bumpTest
//
//  Created by Zac Fitz-Walter on 16/12/10.
//  Copyright 2010 Phd Student. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BumpAPI.h"
#import "Bumper.h"
#import "AppDelegate.h"
#import "Kumulos.h"

@class FriendsListViewController;
@class TimelineScrollViewController;
@class EventListController;
@class AddEventsViewController;

@interface BumpConnector : NSObject <BumpAPIDelegate,KumulosDelegate> {
	BumpAPI *bumpObject;
	
	FriendsListViewController *friendListViewController;	
    TimelineScrollViewController *timelineScrollViewController;
    EventListController *eventListController;
	AppDelegate *appDelegate;
//	int packetsAttempted;
    
    NSInteger function;//0=detal,1=add friend for organizer, 2=add friend for member, 3=add friends for event details
    NSInteger eventID;
    
    NSString *friendToken;
    NSMutableData *receivedData;
    
    Boolean isFinish;
    
    NSMutableDictionary *friendDic;
}

@property (nonatomic, assign) FriendsListViewController *friendsListViewController;
@property (nonatomic, retain) TimelineScrollViewController *timelineScrollViewController;
@property (nonatomic, retain) EventListController *eventListController;
@property (nonatomic, retain) AddEventsViewController *addEventsViewController;
@property (nonatomic, retain) AppDelegate *appDelegate;
@property (nonatomic) NSInteger function;
@property (nonatomic) NSInteger eventID;

- (void) sendDetails;
- (void) startBump;
- (void) stopBump;
- (void) loadAppData;
@end
