  //
//  TimelineManager.m
//  GurlsNightOut
//
//  Created by calvin on 16/05/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TimelineManager.h"

@implementation TimelineManager
@synthesize eventID,timelineDic,timelineDicPath,likePostDic,likePostDicPath,commentPostDic,commentPostDicPath;

- (id) init
{
    if (self = [super init]) {
        NSLog(@"-----------running timelinesManager----------------");
        k=[[Kumulos alloc] init];
        k.delegate=self;
        
        self.timelineDicPath=[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"timelineArrayyPath"];
        
        BOOL timelineDicPathExists = [[NSFileManager defaultManager] fileExistsAtPath:self.timelineDicPath];
        
        if (timelineDicPathExists) {
            self.timelineDic=[NSMutableDictionary dictionaryWithContentsOfFile:self.timelineDicPath];
        }
        else {
            self.timelineDic=[[NSMutableDictionary alloc] init];
        }
        likePostDic=[[NSMutableDictionary alloc] init];
        commentPostDic=[[NSMutableDictionary alloc] init];

    }
    return self;
}
- (id) initByEventID:(NSString *)eventID1//function:0=init, 1=reload
{
    if (self = [super init]) {
        NSLog(@"-----------running timelinesManager----------------");

        self.eventID=[[NSString alloc] initWithFormat:@"%@",eventID1];
        k=[[Kumulos alloc] init];
        k.delegate=self;

        self.timelineDicPath=[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"timelineArrayyPath"];
        
        BOOL timelineDicPathExists = [[NSFileManager defaultManager] fileExistsAtPath:self.timelineDicPath];
        
        if (timelineDicPathExists) {
            self.timelineDic=[NSMutableDictionary dictionaryWithContentsOfFile:self.timelineDicPath];
        }
        else {
            self.timelineDic=[[NSMutableDictionary alloc] init];
        }
        
        [k getPostCountWithEventID:[self.eventID intValue]];
        
        
        likePostDic=[[NSMutableDictionary alloc] init];
        commentPostDic=[[NSMutableDictionary alloc] init];

        
        [[NSNotificationCenter defaultCenter]  addObserver:self selector:@selector(reloadPostLike:) name:@"reloadPostLike" object:nil];
        [[NSNotificationCenter defaultCenter]  addObserver:self selector:@selector(reloadPostComment:) name:@"reloadPostComment" object:nil];

    }
    return self;
}
- (void) reloadPostByEventID:(NSString *) eventID1
{
    self.eventID=eventID1;
    [k getPostCountWithEventID:[self.eventID intValue]];
}

- (void) reloadAllPostByEventID:(NSString *) eventID1
{
    self.eventID=eventID1;
    [[timelineDic objectForKey:self.eventID] removeAllObjects];
    [k getPostCountWithEventID:[self.eventID intValue]];
}
- (void) addTimeline:(NSMutableDictionary*)timeline EventID:(NSString *)eventDBID1
{
    self.eventID=eventDBID1;
    [[timelineDic objectForKey:eventDBID1] insertObject:timeline atIndex:0];
    ////sort
    [[timelineDic objectForKey:eventDBID1] sortUsingSelector:@selector(timelineCompareMethodWithDict:)];
    [self writeToFile];

    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"GetAllPost" object:self];
    
}

/////////////////////////////////////////////////////////////////////////////////////////////////
- (Boolean) writeToFile
{
    return [self.timelineDic writeToFile:self.timelineDicPath atomically:YES];
}

- (void)reloadPostLike:(NSNotification*) notification
{
    [self initPostLike];
}
- (void)reloadPostComment:(NSNotification*) notification
{
    [self initPostComment];
}
- (void) initPostLike
{
    [k getPostLikeWithEventID:[self.eventID intValue]];
}
- (void) initPostComment
{
    [k getPostCommentWithEventID:[self.eventID intValue]];
}
#pragma mark - Kumulos delegate
- (void) kumulosAPI:(Kumulos *)kumulos apiOperation:(KSAPIOperation *)operation getPostCountDidCompleteWithResult:(NSNumber *)aggregateResult
{
    NSLog(@"%@",aggregateResult);
    if ([aggregateResult intValue]!=0) {
        if ([[timelineDic objectForKey:self.eventID] count]==0) {
            NSMutableArray *arr=[[NSMutableArray alloc] init];
            [timelineDic setObject:arr forKey:self.eventID];
            [k getPostInRangeWithEventID:[self.eventID intValue] andStartNumber:[[NSNumber alloc] initWithInteger:0] andRangeNumber:aggregateResult];
        }
        else
        {
            NSInteger index=[aggregateResult intValue]-[[timelineDic objectForKey:self.eventID] count] ;///////////////////////////////
            if ([[timelineDic objectForKey:self.eventID] count]!=[aggregateResult intValue]) {
                [k getPostInRangeWithEventID:[self.eventID intValue] andStartNumber:[[NSNumber alloc] initWithInteger:0] andRangeNumber:[[NSNumber alloc] initWithInteger:index]];
            }
            else
            {
                [self initPostComment];
            }
        }
    }

}
- (void) kumulosAPI:(Kumulos *)kumulos apiOperation:(KSAPIOperation *)operation getPostInRangeDidCompleteWithResult:(NSArray *)theResults
{
    NSLog(@"%d",[[timelineDic objectForKey:self.eventID] count]);
    for (int i=[theResults count]-1; i>=0; i--) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"eventPostDBID == %@", [[theResults objectAtIndex:i] objectForKey:@"eventPostDBID"]];
        NSArray *abc = [[timelineDic objectForKey:self.eventID] filteredArrayUsingPredicate:predicate];
        
        if ([abc count]==0) {
            [[timelineDic objectForKey:self.eventID] insertObject:[theResults objectAtIndex:i] atIndex:0];
        }
    }
    
    [[timelineDic objectForKey:self.eventID] sortUsingSelector:@selector(timelineCompareMethodWithDict:)];

    NSLog(@"%d",[[timelineDic objectForKey:self.eventID] count]);

    [self writeToFile];
    
    [self initPostComment];
}

- (void) kumulosAPI:(kumulosProxy *)kumulos apiOperation:(KSAPIOperation *)operation didFailWithError:(NSString *)theError
{
    NSLog(@"%@",theError);
    
    BOOL timelineArrayyPathExists = [[NSFileManager defaultManager] fileExistsAtPath:self.timelineDicPath];
    
    if (timelineArrayyPathExists) {
        self.timelineDic=[NSMutableDictionary dictionaryWithContentsOfFile:timelineDicPath];
    }
}

-(void) kumulosAPI:(Kumulos *)kumulos apiOperation:(KSAPIOperation *)operation getPostCommentDidCompleteWithResult:(NSArray *)theResults
{
    NSMutableArray *array=[[NSMutableArray alloc] initWithArray:theResults];
    [commentPostDic setObject:array forKey:self.eventID];
        
    NSLog(@"%@",commentPostDic);
    
    [self initPostLike];

}

-(void) kumulosAPI:(Kumulos *)kumulos apiOperation:(KSAPIOperation *)operation getPostLikeDidCompleteWithResult:(NSArray *)theResults
{
    NSMutableArray *array=[[NSMutableArray alloc] initWithArray:theResults];
    [likePostDic setObject:array forKey:self.eventID];
    NSLog(@"%@",likePostDic);
    self.eventID=[NSString stringWithFormat:@"0"];

    [[NSNotificationCenter defaultCenter] postNotificationName:@"GetAllPost" object:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadByLike" object:nil];

}
@end
