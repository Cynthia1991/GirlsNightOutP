//
//  FriendsManager.m
//  GurlsNightOut
//
//  Created by Calvin on 5/05/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "FriendsManager.h"

@implementation FriendsManager
@synthesize friendsList,friendsListPath,myUserDBID,friendsDictionary;
- (id) init
{
    if (self = [super init]) {
        NSLog(@"-----------running friendsManager----------------");

        self.friendsDictionary=[[NSMutableDictionary alloc] init];//For add friends
        
        self.friendsListPath=[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"friendsListPath"];
        
        self.friendsList=[[NSMutableArray alloc] init];
        [self getAllFriendsByFunction:0];
        
        //get my userDBID
        self.myUserDBID=[self getMyUserDBID];
    }    
    return self;
}

- (void) getAllFriendsByFunction:(NSInteger) function//0=load data from local firstly,1=load data from server directly
{
    BOOL friendsListPathExists = [[NSFileManager defaultManager] fileExistsAtPath:self.friendsListPath];
    self.myUserDBID=[self getMyUserDBID];

    if (function==0) {//from local files first, if not exist, then load from server,such as login to load the last history first
        if (friendsListPathExists) {
            friendsList=[NSMutableArray arrayWithContentsOfFile:self.friendsListPath];
        }
        else {
            if ([[self getMyUserDBID] length]!=0) {
                [self getAllFriendsFromServer];
            }
        }
    }
    else {//load from server directly, such as updating friends list
        if ([[self getMyUserDBID] length]!=0) {
            [self getAllFriendsFromServer];
        }
    }

}
- (void) getAllFriendsFromServer
{
    Kumulos *k=[[Kumulos alloc] init];
    [k setDelegate:self];
    [k getAllFriendsWithUserDBID:[self.myUserDBID intValue]];
}

- (NSString *) getMyUserDBID
{
    NSString *userInfoDicPath=[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"userInfoDicPath"];    
    BOOL userInfoDicPathExists = [[NSFileManager defaultManager] fileExistsAtPath:userInfoDicPath];
    if (userInfoDicPathExists) {
        return [[NSDictionary dictionaryWithContentsOfFile:userInfoDicPath] objectForKey:@"userDBID"];
    }
    return nil;
}

- (Boolean) addFriends:(NSDictionary *)friendsDetails
{
    [self.friendsDictionary removeAllObjects];
    [self.friendsDictionary addEntriesFromDictionary:friendsDetails];
    
    
    Kumulos *k=[[Kumulos alloc] init];
    [k setDelegate:self];
    [k checkFriendsWithUserDBID:[[self getMyUserDBID] intValue] andFriendsUserDBID:[[friendsDetails objectForKey:@"userDBID"] intValue]];
    return YES;
}
- (void) writeToFile
{
    [self.friendsList writeToFile:self.friendsListPath atomically:YES];
}
#pragma mark - Kumulos delegate
- (void) kumulosAPI:(Kumulos *)kumulos apiOperation:(KSAPIOperation *)operation getAllFriendsDidCompleteWithResult:(NSArray *)theResults
{
    NSMutableArray *arr=[[NSMutableArray alloc] init];
    if ([theResults count]!=0) {
        for (int i=0; i<[theResults count]; i++) {
            NSMutableDictionary *dic=[[NSMutableDictionary alloc] initWithDictionary:[theResults objectAtIndex:i]];
            if ([dic objectForKey:@"friendsUserDBID"]!=nil) {
                [arr addObject:[[NSMutableDictionary alloc] initWithDictionary:[dic objectForKey:@"friendsUserDBID"] ]];
            }
        }
    }
    for (int i=0; i<[arr count]; i++) {
        for (int j=0; j<[self.friendsList count]; j++) {
            if ([[[arr objectAtIndex:i] objectForKey:@"userDBID"] intValue]==[[[self.friendsList objectAtIndex:j] objectForKey:@"userDBID"] intValue]) {
                if ([[self.friendsList objectAtIndex:j] objectForKey:@"mobilePhone"]!=nil) {
                    [[arr objectAtIndex:i] setObject:[NSString stringWithFormat:@"%@",[[self.friendsList objectAtIndex:j] objectForKey:@"mobilePhone"]] forKey:@"mobilePhone"];
                }
                else
                {
                    [[arr objectAtIndex:i] setObject:[NSString stringWithFormat:@""] forKey:@"mobilePhone"];
                }
                
                if ([[self.friendsList objectAtIndex:j] objectForKey:@"facebook"]!=nil) {
                    [[arr objectAtIndex:i] setObject:[NSString stringWithFormat:@"%@",[[self.friendsList objectAtIndex:j] objectForKey:@"facebook"]] forKey:@"facebook"];
                }
                else
                {
                    [[arr objectAtIndex:i] setObject:[NSString stringWithFormat:@""] forKey:@"facebook"];
                }
            }
        }
    }

    
    [self.friendsList removeAllObjects];
    [self.friendsList addObjectsFromArray:arr];
    [self.friendsList writeToFile:self.friendsListPath atomically:YES];

    [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadTableView" object:nil];

}

////////////////////check the relationship first, and then create the relationship
- (void) kumulosAPI:(Kumulos *)kumulos apiOperation:(KSAPIOperation *)operation checkFriendsDidCompleteWithResult:(NSArray *)theResults
{
    if ([theResults count]==0) {
        Kumulos *k=[[Kumulos alloc] init];
        [k setDelegate:self];
        [k createFriendsWithFriendsName:[NSString stringWithFormat:@"%@",[self.friendsDictionary objectForKey:@"userName"]] andUserDBID:[self.myUserDBID intValue] andFriendsUserDBID:[[self.friendsDictionary objectForKey:@"userDBID"] intValue]];
    }
    else
    {
        for (int i=0; i<[self.friendsList count]; i++) {
            if ([[[self.friendsList objectAtIndex:i] objectForKey:@"userDBID"] intValue]==[[[theResults objectAtIndex:0] objectForKey:@"friendsUserDBID"] intValue]) {
                [[self.friendsList objectAtIndex:i] setObject:[self.friendsDictionary objectForKey:@"mobilePhone"] forKey:@"mobilePhone"];
                [[self.friendsList objectAtIndex:i] setObject:[self.friendsDictionary objectForKey:@"facebook"] forKey:@"facebook"];
            }
        }
        [self.friendsList writeToFile:self.friendsListPath atomically:YES];

    }
}

-(void) kumulosAPI:(Kumulos *)kumulos apiOperation:(KSAPIOperation *)operation createFriendsDidCompleteWithResult:(NSNumber *)newRecordID
{
    NSMutableDictionary *friend=[[NSMutableDictionary alloc] init];
    [friend addEntriesFromDictionary:self.friendsDictionary];
    [self.friendsList addObject:friend];
    [self.friendsList writeToFile:self.friendsListPath atomically:YES];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadTableView" object:nil];

}

-(void) kumulosAPI:(kumulosProxy *)kumulos apiOperation:(KSAPIOperation *)operation didFailWithError:(NSString *)theError
{
    NSLog(@"kumulos error: %@",theError);
}
@end
