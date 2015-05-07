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

@interface BumpConnector : NSObject <BumpAPIDelegate,KumulosDelegate> {
	BumpAPI *bumpObject;
	
	FriendsListViewController *friendListViewController;	
    TimelineScrollViewController *timelineScrollViewController;
    EventListController *eventListController;
	AppDelegate *appDelegate;
//	int packetsAttempted;
    
    NSInteger function;
    NSInteger eventID;
}

@property (nonatomic, assign) FriendsListViewController *friendsListViewController;
@property (nonatomic, retain) TimelineScrollViewController *timelineScrollViewController;
@property (nonatomic, retain) EventListController *eventListController;
@property (nonatomic, retain) AppDelegate *appDelegate;
@property (nonatomic) NSInteger function;
@property (nonatomic) NSInteger eventID;

- (void) sendDetails;
- (void) startBump;
- (void) stopBump;
- (void) loadAppData;
@end
