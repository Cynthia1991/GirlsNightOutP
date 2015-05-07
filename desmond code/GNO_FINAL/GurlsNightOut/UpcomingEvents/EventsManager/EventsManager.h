//
//  EventsManager.h
//  GurlsNightOut
//
//  Created by Calvin on 8/05/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Kumulos.h"

@interface EventsManager : NSObject <KumulosDelegate>
{
}
@property (nonatomic, retain) NSMutableArray *eventsArray;
@property (nonatomic, retain) NSString *eventsArrayPath;
@property (nonatomic, retain) NSString *myUserDBID;
@property (nonatomic, retain) NSString *currentEventDBID;
@property (nonatomic, retain) UIImage *eventImage;

- (Boolean) writeToFile;
- (void) getAllEventsByFunction:(NSInteger) function;
- (void) deleteEventByIndex: (int) section Row:(int) row;
- (NSMutableDictionary*) getEventDictionaryByEventID:(NSString *) eventID;
- (void) updateFriendsListByEventDBID:(NSString *)eventDBID function:(NSInteger) function;
- (void) saveEventImage:(UIImage*) img EventDBID:(NSInteger) eventDBID;
@end




@interface NSDictionary(myCompare)
- (NSComparisonResult)eventListCompareMethodWithDict: (NSDictionary*)theOtherDict;
- (NSComparisonResult)timelineCompareMethodWithDict: (NSDictionary*)theOtherDict;
- (NSComparisonResult)quickDialUserNameCompareMethodWithDict: (NSDictionary*)theOtherDict;
@end

@implementation NSDictionary(myCompare)
- (NSComparisonResult)eventListCompareMethodWithDict: (NSDictionary*)anotherDict
{
    NSDictionary *firstDict = self;
        
    NSDate *firstDateStr = [firstDict objectForKey: @"eventTime"];
    NSDate *secondDateStr = [anotherDict objectForKey: @"eventTime"];
    
    return [firstDateStr compare: secondDateStr];
}
- (NSComparisonResult)timelineCompareMethodWithDict: (NSDictionary*)anotherDict
{
    NSDictionary *firstDict = self;
    
    NSDate *firstDateStr = [firstDict objectForKey: @"timeCreated"];
    NSDate *secondDateStr = [anotherDict objectForKey: @"timeCreated"];
    
    return [secondDateStr compare: firstDateStr];
}
- (NSComparisonResult)quickDialUserNameCompareMethodWithDict: (NSDictionary*)anotherDict
{
    NSDictionary *firstDict = self;
    NSString *firstStr = [firstDict objectForKey: @"userName"];
    NSString *secondStr =[anotherDict objectForKey: @"userName"];
    
    return [firstStr compare: secondStr];
}
@end
