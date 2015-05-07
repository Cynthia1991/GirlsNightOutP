//
//  TimelineCellKumulos.m
//  gno
//
//  Created by Calvin on 7/08/12.
//
//

#import "TimelineCellKumulos.h"

@implementation TimelineCellKumulos
@synthesize eventPostID,eventID;

- (id) initByEventPostID:(NSString *)eventPostID1 EventID:(NSString *)eventID1
{
    if (self = [super init]) {
        self.eventPostID=eventPostID1;
        self.eventID=eventID1;
        appDelegate=(AppDelegate*)[[UIApplication sharedApplication] delegate];
        appDelegate.timelineManager.eventID=[self eventID];
    }
    return self;
}

- (void) createLike
{
    NSString *userDBID=[[appDelegate.myDetailsManager userInfoDic] objectForKey:@"userDBID"];
    
    Kumulos *k=[[Kumulos alloc] init];
    [k setDelegate:self];
    [k checkLikeWithUserID:[userDBID intValue] andLikeID:[self.eventPostID intValue] andEventID:[self.eventID intValue]];
}

- (void) createCommentWithComment:(NSString*) comment
{
    NSString *userDBID=[[appDelegate.myDetailsManager userInfoDic] objectForKey:@"userDBID"];

    Kumulos *k=[[Kumulos alloc] init];
    [k setDelegate:self];
    [k createPostCommentWithComment:comment andUserID:[userDBID intValue] andPostID:[self.eventPostID intValue] andEventID:[self.eventID intValue]];
}

-(void) kumulosAPI:(Kumulos *)kumulos apiOperation:(KSAPIOperation *)operation checkLikeDidCompleteWithResult:(NSArray *)theResults
{
    if ([theResults count]==0) {
        NSString *userDBID=[[appDelegate.myDetailsManager userInfoDic] objectForKey:@"userDBID"];
        
        Kumulos *k=[[Kumulos alloc] init];
        [k setDelegate:self];
        [k createPostLikeWithUserID:[userDBID intValue] andLikeID:[self.eventPostID intValue] andEventID:[self.eventID intValue]];
    }
}
-(void) kumulosAPI:(Kumulos *)kumulos apiOperation:(KSAPIOperation *)operation createPostLikeDidCompleteWithResult:(NSNumber *)newRecordID
{
    Kumulos *k=[[Kumulos alloc] init];
    k.delegate=self;
    [k getPostLikeWithEventID:[self.eventID intValue]];
}

-(void) kumulosAPI:(Kumulos *)kumulos apiOperation:(KSAPIOperation *)operation getPostLikeDidCompleteWithResult:(NSArray *)theResults
{
    NSMutableArray *array=[[NSMutableArray alloc] initWithArray:theResults];
    appDelegate.timelineManager.likePostDic=[[NSMutableDictionary alloc] init];
    [appDelegate.timelineManager.likePostDic setObject:array forKey:self.eventID];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadByLike" object:nil];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"eventPostDBID like %@", self.eventPostID];
    NSArray *abc = [[appDelegate.timelineManager.timelineDic objectForKey:self.eventID] filteredArrayUsingPredicate:predicate];
        
    [appDelegate sendNotificationWithFriendsList:[[NSMutableArray alloc] initWithArray:abc] Content:[NSString stringWithFormat:@"like your post."] UserID:[[appDelegate.myDetailsManager userInfoDic] objectForKey:@"userName"] EventID:[self eventID] function:0];

}

@end
