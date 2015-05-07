//
//  EventAddFriendsViewController.h
//  gno
//
//  Created by calvin on 5/06/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "Kumulos.h"

@interface EventAddFriendsViewController : UITableViewController<KumulosDelegate>
{
    AppDelegate *appDelegate;
    NSString *eventID;
}

@property (nonatomic, retain) NSMutableArray *oldFriendsList;
@property (nonatomic, retain) NSMutableArray *nowFriendsList;
@property (nonatomic, retain) NSString *eventID;
- (IBAction)addFriendsAction:(id)sender;
- (IBAction)CancelAction:(id)sender;
-(void) updateServer:(NSMutableArray*) nowFriendsList1;

@end
