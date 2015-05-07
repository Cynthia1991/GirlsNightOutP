//
//  EventsManager.m
//  GurlsNightOut
//
//  Created by Calvin on 8/05/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "EventsManager.h"

@implementation EventsManager
@synthesize eventsArray,eventsArrayPath,myUserDBID,eventImage,currentEventDBID;
- (id) init
{
    if (self = [super init]) {
        NSLog(@"-----------running eventsManager----------------");
        self.eventsArrayPath=[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"eventsArrayPath"];
        
        self.eventsArray=[[NSMutableArray alloc] init];
        [self getAllEventsByFunction:0];
    }
    return self;
}
- (Boolean) writeToFile
{
    return [self.eventsArray writeToFile:self.eventsArrayPath atomically:YES];
}

- (void) deleteEventByIndex: (int) section Row:(int) row
{
    Kumulos *k=[[Kumulos alloc] init];  
    [k setDelegate:self]; 
    [k deleteEventWithEventDBID:[[[[self.eventsArray objectAtIndex:section] objectAtIndex:row] objectForKey:@"eventID"] intValue]];
    
    [[self.eventsArray objectAtIndex:section] removeObjectAtIndex:row];

}

- (void) getAllEventsByFunction:(NSInteger) function//0=load data from local firstly,1=load data from server directly
{
    BOOL eventsArrayPathExists = [[NSFileManager defaultManager] fileExistsAtPath:self.eventsArrayPath];
    self.myUserDBID=[self getMyUserDBID];
    
    if (function==0) {//from local files first, if not exist, then load from server,such as login to load the last history first
        if (eventsArrayPathExists) {
            self.eventsArray=[NSMutableArray arrayWithContentsOfFile:self.eventsArrayPath];
        }
        else {
            if ([[self getMyUserDBID] length]!=0) {
                [self getAllEventsFromServer];
            }
        }
    }
    else {//load from server directly, such as updating events list
        if ([[self getMyUserDBID] length]!=0) {
            [self getAllEventsFromServer];
        }
    }
    
}
- (void) getAllEventsFromServer
{
    Kumulos *k=[[Kumulos alloc] init];
    [k setDelegate:self];
    [k getAllEventsWithUserID:[self.myUserDBID intValue]];
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

- (NSMutableDictionary*) getEventDictionaryByEventID:(NSString *) eventID1
{
    for (int i=0; i<[self.eventsArray count]; i++) {
        for (int j=0; j<[[self.eventsArray objectAtIndex:i] count]; j++) {
            NSString *eventID=[[[self.eventsArray objectAtIndex:i] objectAtIndex:j] objectForKey:@"eventID"];
            if ([eventID intValue]==[eventID1 intValue]) {
                return [[self.eventsArray objectAtIndex:i] objectAtIndex:j];
            }
        }
    }
    return nil;
}

-(void) updateFriendsListByEventDBID:(NSString *)eventDBID function:(NSInteger) function
{
    Kumulos *k=[[Kumulos alloc] init];  
    [k setDelegate:self]; 
    [k getPeopleFromEventWithEventID:[eventDBID intValue]];
}

-(void) saveEventImage:(UIImage *)img EventDBID:(NSInteger) eventDBID
{
    self.currentEventDBID=[NSString stringWithFormat:@"%d",eventDBID];
    self.eventImage=[img copy];
    NSMutableDictionary *dic=[self getEventDictionaryByEventID:[NSString stringWithFormat:@"%d",eventDBID]];
    if ([[dic objectForKey:@"eventIconDBID"] intValue]!=0) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"delete icon" object:[dic objectForKey:@"eventIconDBID"]];//delete local icon
    }

    //delete icon in server
    Kumulos *k=[[Kumulos alloc] init];
    [k setDelegate:self];
    [k deleteIconWithPhotosDBID:[[dic objectForKey:@"eventIconDBID"] intValue]];
}
#pragma mark - Kumulos delegate
-(void) kumulosAPI:(Kumulos *)kumulos apiOperation:(KSAPIOperation *)operation deleteIconDidCompleteWithResult:(NSNumber *)affectedRows
{
    NSData *imageData=UIImageJPEGRepresentation(self.eventImage, 1.0);;
    Kumulos *k=[[Kumulos alloc] init];
    [k setDelegate:self];
    [k uploadPhotosWithPhotoValue:imageData andTextValue:@"1" andLargePhotoValue:nil];
}
-(void) kumulosAPI:(Kumulos *)kumulos apiOperation:(KSAPIOperation *)operation uploadPhotosDidCompleteWithResult:(NSNumber *)newRecordID
{
    NSData *imageData=UIImageJPEGRepresentation(self.eventImage, 1.0);
    NSMutableDictionary *dic=[[NSMutableDictionary alloc] init];
    [dic setObject:imageData forKey:@"imageData"];
    [dic setObject:[NSString stringWithFormat:@"%@", newRecordID] forKey:@"photoDBID"];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"add icon" object:dic];
    
    //    [photoManager addPhoto:imageData text:@"1" PhotoDBID:[NSString stringWithFormat:@"%@", newRecordID]];
    for (int i=0; i<[self.eventsArray count]; i++) {
        for (int j=0; j<[[self.eventsArray objectAtIndex:i] count]; j++) {
            NSString *eventID=[[[self.eventsArray objectAtIndex:i] objectAtIndex:j] objectForKey:@"eventID"];
            if ([eventID intValue]==[self.currentEventDBID intValue]) {
                [[[self.eventsArray objectAtIndex:i] objectAtIndex:j] setObject:newRecordID forKey:@"eventIconDBID"];
                NSLog(@"%@",[[self.eventsArray objectAtIndex:i] objectAtIndex:j]);
            }
        }
    }
    
    [self writeToFile];
    
    Kumulos *k=[[Kumulos alloc] init];
    [k setDelegate:self];
    [k updateEventIconWithEventIconDBID:[newRecordID intValue] andEventDBID:[self.currentEventDBID intValue]];
}
- (void) kumulosAPI:(Kumulos *)kumulos apiOperation:(KSAPIOperation *)operation updateEventIconDidCompleteWithResult:(NSNumber *)affectedRows
{
    NSLog(@"upload icon");    
    NSMutableDictionary *dic=[[NSMutableDictionary alloc] initWithDictionary:[self getEventDictionaryByEventID:[NSString stringWithFormat:@"%@",self.currentEventDBID]]];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"initHeaderView" object:[dic objectForKey:@"eventIconDBID"]];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"dismiss my detail photo" object:nil];

}
- (void) kumulosAPI:(Kumulos *)kumulos apiOperation:(KSAPIOperation *)operation getAllEventsDidCompleteWithResult:(NSArray *)theResults
{
    [self.eventsArray removeAllObjects];
    NSMutableArray *arrFuture=[[NSMutableArray alloc] init];
    NSMutableArray *arrPass=[[NSMutableArray alloc] init];
    [self.eventsArray addObject:arrFuture];
    [self.eventsArray addObject:arrPass];
    
    if ([theResults count]!=0) {
        for (int i=0; i<[theResults count]; i++) {
            NSMutableDictionary *dic=[[NSMutableDictionary alloc] init];
            [dic setObject:[[[theResults objectAtIndex:i] objectForKey:@"eventID"] objectForKey:@"eventDBID"] forKey:@"eventID"];
            [dic setObject:[[[theResults objectAtIndex:i] objectForKey:@"eventID"] objectForKey:@"eventName"] forKey:@"eventName"];
            [dic setObject:[[[theResults objectAtIndex:i] objectForKey:@"eventID"] objectForKey:@"eventDetails"] forKey:@"eventDetails"];
            [dic setObject:[[[theResults objectAtIndex:i] objectForKey:@"eventID"] objectForKey:@"eventTime"] forKey:@"eventTime"];
            [dic setObject:[[[theResults objectAtIndex:i] objectForKey:@"eventID"] objectForKey:@"startTime"] forKey:@"startTime"];
            [dic setObject:[[[theResults objectAtIndex:i] objectForKey:@"eventID"] objectForKey:@"endTime"] forKey:@"endTime"];
            [dic setObject:[[[theResults objectAtIndex:i] objectForKey:@"eventID"] objectForKey:@"locationName"] forKey:@"locationName"];
            [dic setObject:[[[theResults objectAtIndex:i] objectForKey:@"eventID"] objectForKey:@"locationAddress"] forKey:@"locationAddress"];
            [dic setObject:[[[theResults objectAtIndex:i] objectForKey:@"eventID"] objectForKey:@"locationLatitude"] forKey:@"locationLatitude"];
            [dic setObject:[[[theResults objectAtIndex:i] objectForKey:@"eventID"] objectForKey:@"locationLongitude"] forKey:@"locationLongitude"];
            [dic setObject:[[[theResults objectAtIndex:i] objectForKey:@"eventID"] objectForKey:@"eventIconDBID"] forKey:@"eventIconDBID"];
            [dic setObject:[[NSMutableArray alloc] init] forKey:@"eventFriends"];
            
//            NSDateFormatter *formatter1 = [[NSDateFormatter alloc] init];
//            formatter1.dateFormat = @"dd/MM/yyyy HH:mm:ss";
            NSDate *eventDate = [[[theResults objectAtIndex:i] objectForKey:@"eventID"] objectForKey:@"eventTime"];
            
            NSCalendar *cal = [NSCalendar currentCalendar];
            NSDateComponents *components = [cal components:( NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit ) fromDate:[[NSDate alloc] init]];
            
            NSDate *today = [cal dateByAddingComponents:components toDate:[[NSDate alloc] init] options:0]; //This variable should now be pointing at a date object that is the start of today (midnight);
            [components setHour:-24];
            [components setMinute:0];
            [components setSecond:0];
            NSDate *yesterday = [cal dateByAddingComponents:components toDate: today options:0];
            NSLog(@"yesterday=%@, taday=%@",yesterday,[[NSDate alloc] init]);

            if ([eventDate compare:yesterday]==1) {//the future
                [[self.eventsArray objectAtIndex:0] addObject:dic];
            }
            else//the past
            {
                [[self.eventsArray objectAtIndex:1] addObject:dic];

            }
            
        }
        
        [[self.eventsArray objectAtIndex:0] sortUsingSelector:@selector(eventListCompareMethodWithDict:)];
        [[self.eventsArray objectAtIndex:1] sortUsingSelector:@selector(eventListCompareMethodWithDict:)];
        
        
        [self writeToFile];
        
        for (int i=0; i<[self.eventsArray count]; i++) {
            for (int j=0; j<[[self.eventsArray objectAtIndex:i] count]; j++) {
                if ([[[self.eventsArray objectAtIndex:i] objectAtIndex:j] objectForKey:@"eventID"]!=nil) {
                    Kumulos *k=[[Kumulos alloc] init];
                    [k setDelegate:self];
                    [k getPeopleFromEventWithEventID:[[[[self.eventsArray objectAtIndex:i] objectAtIndex:j] objectForKey:@"eventID"] intValue]];
                }
            }
        }
    }
    else
    {
        [self writeToFile];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadEventsTableView" object:nil];
    }

}

- (void) kumulosAPI:(Kumulos *)kumulos apiOperation:(KSAPIOperation *)operation deleteEventDidCompleteWithResult:(NSNumber *)affectedRows
{
    NSLog(@"Delete successful.");
    [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadFromAddFriends" object:nil];

}
- (void) kumulosAPI:(Kumulos *)kumulos apiOperation:(KSAPIOperation *)operation getPeopleFromEventDidCompleteWithResult:(NSArray *)theResults
{
    if ([theResults count]!=0) {
        NSMutableArray *arr=[[NSMutableArray alloc] init];
        for (int i=0; i<[theResults count]; i++) {
            NSMutableDictionary *dic=[[NSMutableDictionary alloc] initWithDictionary:[theResults objectAtIndex:i]];
            [arr addObject:dic];
        }
        NSString *index=[self getEventIndex:[[[theResults objectAtIndex:0] objectForKey:@"eventID"] objectForKey:@"eventDBID"]];
        NSArray *array=[index componentsSeparatedByString:@","];
        
        if (![index isEqualToString:@"NoThisEvent"]) {
            [[[self.eventsArray objectAtIndex:[[array objectAtIndex:0] intValue]] objectAtIndex:[[array objectAtIndex:1] intValue]] setObject:arr forKey:@"eventFriends"];
            
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"isHome == 0"];
            NSArray *abc = [arr filteredArrayUsingPredicate:predicate];
            if ([abc count]==0) {
                if ([[array objectAtIndex:0] intValue]==0) {
                    NSMutableDictionary *dic=[[NSMutableDictionary alloc] initWithDictionary:[[self.eventsArray objectAtIndex:0] objectAtIndex:[[array objectAtIndex:1] intValue]]];
                    [[self.eventsArray objectAtIndex:0] removeObjectAtIndex:[[array objectAtIndex:1] intValue]];
                    [[self.eventsArray objectAtIndex:1] addObject:dic];
                    
                    [[self.eventsArray objectAtIndex:0] sortUsingSelector:@selector(eventListCompareMethodWithDict:)];
                    [[self.eventsArray objectAtIndex:1] sortUsingSelector:@selector(eventListCompareMethodWithDict:)];
                }
            }
        }
        [self writeToFile];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"reload modify event friend tableview" object:nil];//event detail update table view
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadEventsTableView" object:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"hideEventListHUD" object:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshQuickDial" object:nil];

}
- (NSString*) getEventIndex:(NSString *) resultEventID
{
    for (int i=0; i<[self.eventsArray count]; i++) {
        for (int j=0; j<[[self.eventsArray objectAtIndex:i] count]; j++) {
            if ([[[[self.eventsArray objectAtIndex:i] objectAtIndex:j] objectForKey:@"eventID"] isEqual:resultEventID]) {
                return [NSString stringWithFormat:@"%d,%d", i,j];
            }
        }
    }
    return [NSString stringWithFormat:@"NoThisEvent"];
    
}
@end
