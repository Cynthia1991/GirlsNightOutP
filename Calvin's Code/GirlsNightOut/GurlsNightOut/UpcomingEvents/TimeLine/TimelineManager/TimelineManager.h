//
//  TimelineManager.h
//  GurlsNightOut
//
//  Created by calvin on 16/05/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Kumulos.h"

@interface TimelineManager : NSObject<KumulosDelegate>
{
    NSInteger function;//get or add
    
    NSInteger loadingTime;
    
    Kumulos *k;
    
    Boolean isKumulosFinish;
}
@property (nonatomic, retain) NSString *eventID;
@property (nonatomic, retain) NSMutableDictionary *timelineDic;
@property (nonatomic, retain) NSString *timelineDicPath;
@property (nonatomic, retain) NSMutableDictionary *likePostDic;
@property (nonatomic, retain) NSString *likePostDicPath;
@property (nonatomic, retain) NSMutableDictionary *commentPostDic;
@property (nonatomic, retain) NSString *commentPostDicPath;

- (id) initByEventID:(NSString *)eventID1;
- (void) initPostLike;
- (void) initPostComment;
- (void) reloadPostLike:(NSNotification*) notification;
- (void) reloadPostComment:(NSNotification*) notification;
- (Boolean) writeToFile;
- (void) addTimeline:(NSMutableDictionary*)timeline EventID:(NSString *)eventDBID1;
- (void) reloadPostByEventID:(NSString *) eventID1;
- (void) reloadAllPostByEventID:(NSString *) eventID1;



@end


//@interface NSDictionary(timelineCompare)
//- (NSComparisonResult)timelineCompareMethodWithDict: (NSDictionary*)theOtherDict;
//- (NSComparisonResult)quickDialUserNameCompareMethodWithDict: (NSDictionary*)theOtherDict;
//@end
//
//@implementation NSDictionary(timelineCompare)
//- (NSComparisonResult)timelineCompareMethodWithDict: (NSDictionary*)anotherDict
//{
//    NSDictionary *firstDict = self;
//       
//    NSDate *firstDateStr = [firstDict objectForKey: @"timeCreated"];
//    NSDate *secondDateStr = [anotherDict objectForKey: @"timeCreated"];
//    
//    return [secondDateStr compare: firstDateStr];
//}
//
//- (NSComparisonResult)quickDialUserNameCompareMethodWithDict: (NSDictionary*)anotherDict
//{
//    NSDictionary *firstDict = self;
//    NSString *firstStr = [firstDict objectForKey: @"userName"];
//    NSString *secondStr =[anotherDict objectForKey: @"userName"];
//    
//    return [firstStr compare: secondStr];
//}
//@end
