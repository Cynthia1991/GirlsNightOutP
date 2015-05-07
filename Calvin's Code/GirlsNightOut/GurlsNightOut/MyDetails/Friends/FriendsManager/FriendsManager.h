//
//  FriendsManager.h
//  GurlsNightOut
//
//  Created by Calvin on 5/05/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Kumulos.h"

@interface FriendsManager : NSObject<KumulosDelegate>
{
    NSString *myUserDBID;
    NSMutableDictionary *friendsDictionary;
    
    NSMutableArray *friendsList;
    NSString *friendsListPath;

}
@property (nonatomic,retain) NSMutableArray *friendsList;
@property (nonatomic,retain) NSString *friendsListPath;
@property (nonatomic,retain) NSString *myUserDBID;
@property (nonatomic,retain) NSMutableDictionary *friendsDictionary;

- (id) init;
- (Boolean) addFriends:(NSDictionary*) friendsDetails;
- (void) getAllFriendsByFunction:(NSInteger) function;
- (void) writeToFile;
@end
