//
//  Kumulos.h
//  Kumulos
//
//  Created by Kumulos Bindings Compiler on Jan 24, 2013
//  Copyright Queensland University of Technology All rights reserved.
//

#import <Foundation/Foundation.h>
#import "libKumulos.h"


@class Kumulos;
@protocol KumulosDelegate <kumulosProxyDelegate>
@optional

 
- (void) kumulosAPI:(Kumulos*)kumulos apiOperation:(KSAPIOperation*)operation changeEventLocationDidCompleteWithResult:(NSNumber*)affectedRows;
 
- (void) kumulosAPI:(Kumulos*)kumulos apiOperation:(KSAPIOperation*)operation createEventsDidCompleteWithResult:(NSNumber*)newRecordID;
 
- (void) kumulosAPI:(Kumulos*)kumulos apiOperation:(KSAPIOperation*)operation deleteEventDidCompleteWithResult:(NSNumber*)affectedRows;
 
- (void) kumulosAPI:(Kumulos*)kumulos apiOperation:(KSAPIOperation*)operation editEventDidCompleteWithResult:(NSNumber*)affectedRows;
 
- (void) kumulosAPI:(Kumulos*)kumulos apiOperation:(KSAPIOperation*)operation updateEventIconDidCompleteWithResult:(NSNumber*)affectedRows;
 
- (void) kumulosAPI:(Kumulos*)kumulos apiOperation:(KSAPIOperation*)operation checkInviteFriendDidCompleteWithResult:(NSArray*)theResults;
 
- (void) kumulosAPI:(Kumulos*)kumulos apiOperation:(KSAPIOperation*)operation creatEventOrganizerDidCompleteWithResult:(NSNumber*)newRecordID;
 
- (void) kumulosAPI:(Kumulos*)kumulos apiOperation:(KSAPIOperation*)operation delectPeopleInEventDidCompleteWithResult:(NSNumber*)affectedRows;
 
- (void) kumulosAPI:(Kumulos*)kumulos apiOperation:(KSAPIOperation*)operation getAllEventsDidCompleteWithResult:(NSArray*)theResults;
 
- (void) kumulosAPI:(Kumulos*)kumulos apiOperation:(KSAPIOperation*)operation getOneEventDidCompleteWithResult:(NSArray*)theResults;
 
- (void) kumulosAPI:(Kumulos*)kumulos apiOperation:(KSAPIOperation*)operation getPeopleFromEventDidCompleteWithResult:(NSArray*)theResults;
 
- (void) kumulosAPI:(Kumulos*)kumulos apiOperation:(KSAPIOperation*)operation inviteFriendsDidCompleteWithResult:(NSNumber*)newRecordID;
 
- (void) kumulosAPI:(Kumulos*)kumulos apiOperation:(KSAPIOperation*)operation isAttentEventDidCompleteWithResult:(NSNumber*)affectedRows;
 
- (void) kumulosAPI:(Kumulos*)kumulos apiOperation:(KSAPIOperation*)operation updateHomeStatusDidCompleteWithResult:(NSNumber*)affectedRows;
 
- (void) kumulosAPI:(Kumulos*)kumulos apiOperation:(KSAPIOperation*)operation createPostCommentDidCompleteWithResult:(NSNumber*)newRecordID;
 
- (void) kumulosAPI:(Kumulos*)kumulos apiOperation:(KSAPIOperation*)operation getPostCommentDidCompleteWithResult:(NSArray*)theResults;
 
- (void) kumulosAPI:(Kumulos*)kumulos apiOperation:(KSAPIOperation*)operation createPostDidCompleteWithResult:(NSNumber*)newRecordID;
 
- (void) kumulosAPI:(Kumulos*)kumulos apiOperation:(KSAPIOperation*)operation deletePostDidCompleteWithResult:(NSNumber*)affectedRows;
 
- (void) kumulosAPI:(Kumulos*)kumulos apiOperation:(KSAPIOperation*)operation getAllDrinksDidCompleteWithResult:(NSArray*)theResults;
 
- (void) kumulosAPI:(Kumulos*)kumulos apiOperation:(KSAPIOperation*)operation getOnePostDidCompleteWithResult:(NSArray*)theResults;
 
- (void) kumulosAPI:(Kumulos*)kumulos apiOperation:(KSAPIOperation*)operation getPostDidCompleteWithResult:(NSArray*)theResults;
 
- (void) kumulosAPI:(Kumulos*)kumulos apiOperation:(KSAPIOperation*)operation getPostCountDidCompleteWithResult:(NSNumber*)aggregateResult;
 
- (void) kumulosAPI:(Kumulos*)kumulos apiOperation:(KSAPIOperation*)operation getPostInRangeDidCompleteWithResult:(NSArray*)theResults;
 
- (void) kumulosAPI:(Kumulos*)kumulos apiOperation:(KSAPIOperation*)operation updateDrinkLocationDidCompleteWithResult:(NSNumber*)affectedRows;
 
- (void) kumulosAPI:(Kumulos*)kumulos apiOperation:(KSAPIOperation*)operation checkLikeDidCompleteWithResult:(NSArray*)theResults;
 
- (void) kumulosAPI:(Kumulos*)kumulos apiOperation:(KSAPIOperation*)operation createPostLikeDidCompleteWithResult:(NSNumber*)newRecordID;
 
- (void) kumulosAPI:(Kumulos*)kumulos apiOperation:(KSAPIOperation*)operation getPostLikeDidCompleteWithResult:(NSArray*)theResults;
 
- (void) kumulosAPI:(Kumulos*)kumulos apiOperation:(KSAPIOperation*)operation checkFriendsDidCompleteWithResult:(NSArray*)theResults;
 
- (void) kumulosAPI:(Kumulos*)kumulos apiOperation:(KSAPIOperation*)operation createFriendsDidCompleteWithResult:(NSNumber*)newRecordID;
 
- (void) kumulosAPI:(Kumulos*)kumulos apiOperation:(KSAPIOperation*)operation getAllFriendsDidCompleteWithResult:(NSArray*)theResults;
 
- (void) kumulosAPI:(Kumulos*)kumulos apiOperation:(KSAPIOperation*)operation updateFriendsDidCompleteWithResult:(NSNumber*)affectedRows;
 
- (void) kumulosAPI:(Kumulos*)kumulos apiOperation:(KSAPIOperation*)operation deleteIconDidCompleteWithResult:(NSNumber*)affectedRows;
 
- (void) kumulosAPI:(Kumulos*)kumulos apiOperation:(KSAPIOperation*)operation getPhotoDidCompleteWithResult:(NSArray*)theResults;
 
- (void) kumulosAPI:(Kumulos*)kumulos apiOperation:(KSAPIOperation*)operation uploadPhotosDidCompleteWithResult:(NSNumber*)newRecordID;
 
- (void) kumulosAPI:(Kumulos*)kumulos apiOperation:(KSAPIOperation*)operation createUserAPIDidCompleteWithResult:(NSNumber*)newRecordID;
 
- (void) kumulosAPI:(Kumulos*)kumulos apiOperation:(KSAPIOperation*)operation getFriendByNameDidCompleteWithResult:(NSArray*)theResults;
 
- (void) kumulosAPI:(Kumulos*)kumulos apiOperation:(KSAPIOperation*)operation getUserDBDidCompleteWithResult:(NSArray*)theResults;
 
- (void) kumulosAPI:(Kumulos*)kumulos apiOperation:(KSAPIOperation*)operation getUserDBByFacebookIDDidCompleteWithResult:(NSArray*)theResults;
 
- (void) kumulosAPI:(Kumulos*)kumulos apiOperation:(KSAPIOperation*)operation getUserInfoByDBIDDidCompleteWithResult:(NSArray*)theResults;
 
- (void) kumulosAPI:(Kumulos*)kumulos apiOperation:(KSAPIOperation*)operation updateBadgeNumberDidCompleteWithResult:(NSNumber*)affectedRows;
 
- (void) kumulosAPI:(Kumulos*)kumulos apiOperation:(KSAPIOperation*)operation updateDeviceTokenDidCompleteWithResult:(NSNumber*)affectedRows;
 
- (void) kumulosAPI:(Kumulos*)kumulos apiOperation:(KSAPIOperation*)operation updateMyDetailsDidCompleteWithResult:(NSNumber*)affectedRows;
 
- (void) kumulosAPI:(Kumulos*)kumulos apiOperation:(KSAPIOperation*)operation updateUserIconDidCompleteWithResult:(NSNumber*)affectedRows;

@end

@interface Kumulos : kumulosProxy {
    NSString* theAPIKey;
    NSString* theSecretKey;
}

-(Kumulos*)init;
-(Kumulos*)initWithAPIKey:(NSString*)APIKey andSecretKey:(NSString*)secretKey;

   
-(KSAPIOperation*) changeEventLocationWithEventDBID:(NSUInteger)eventDBID andLocationLongitude:(float)locationLongitude andLocationLatitude:(float)locationLatitude andLocationAddress:(NSString*)locationAddress andLocationName:(NSString*)locationName;
    
   
-(KSAPIOperation*) createEventsWithEventName:(NSString*)eventName andEventTime:(NSDate*)eventTime andStartTime:(NSDate*)startTime andEndTime:(NSDate*)endTime andIsValid:(BOOL)isValid andLocationName:(NSString*)locationName andLocationAddress:(NSString*)locationAddress andLocationLatitude:(float)locationLatitude andLocationLongitude:(float)locationLongitude andEventDetails:(NSString*)eventDetails andEventIconDBID:(NSInteger)eventIconDBID;
    
   
-(KSAPIOperation*) deleteEventWithEventDBID:(NSUInteger)eventDBID;
    
   
-(KSAPIOperation*) editEventWithEventName:(NSString*)eventName andEventTime:(NSDate*)eventTime andLocationName:(NSString*)locationName andLocationAddress:(NSString*)locationAddress andLocationLatitude:(float)locationLatitude andLocationLongitude:(float)locationLongitude andEventDetails:(NSString*)eventDetails andEventDBID:(NSUInteger)eventDBID;
    
   
-(KSAPIOperation*) updateEventIconWithEventIconDBID:(NSInteger)eventIconDBID andEventDBID:(NSUInteger)eventDBID;
    
   
-(KSAPIOperation*) checkInviteFriendWithEventID:(NSUInteger)eventID andUserID:(NSUInteger)userID;
    
   
-(KSAPIOperation*) creatEventOrganizerWithRole:(NSString*)role andIsConfirm:(NSInteger)isConfirm andIsHome:(NSInteger)isHome andEventID:(NSUInteger)eventID andUserID:(NSUInteger)userID;
    
   
-(KSAPIOperation*) delectPeopleInEventWithEventID:(NSUInteger)eventID andUserID:(NSUInteger)userID;
    
   
-(KSAPIOperation*) getAllEventsWithUserID:(NSUInteger)userID;
    
   
-(KSAPIOperation*) getOneEventWithEventPeopleDBID:(NSUInteger)eventPeopleDBID;
    
   
-(KSAPIOperation*) getPeopleFromEventWithEventID:(NSUInteger)eventID;
    
   
-(KSAPIOperation*) inviteFriendsWithRole:(NSString*)role andIsConfirm:(NSInteger)isConfirm andIsHome:(NSInteger)isHome andEventID:(NSUInteger)eventID andUserID:(NSUInteger)userID;
    
   
-(KSAPIOperation*) isAttentEventWithEventPeopleDBID:(NSUInteger)eventPeopleDBID andIsConfirm:(NSInteger)isConfirm;
    
   
-(KSAPIOperation*) updateHomeStatusWithIsHome:(NSInteger)isHome andEventPeopleDBID:(NSUInteger)eventPeopleDBID;
    
   
-(KSAPIOperation*) createPostCommentWithComment:(NSString*)comment andUserID:(NSUInteger)userID andPostID:(NSUInteger)postID andEventID:(NSUInteger)eventID;
    
   
-(KSAPIOperation*) getPostCommentWithEventID:(NSUInteger)eventID;
    
   
-(KSAPIOperation*) createPostWithTextValue:(NSString*)textValue andFunction:(NSInteger)function andDrinksDetail:(NSData*)drinksDetail andPhotoDetail:(NSData*)photoDetail andUserID:(NSUInteger)userID andEventID:(NSUInteger)eventID;
    
   
-(KSAPIOperation*) deletePostWithEventPostDBID:(NSUInteger)eventPostDBID;
    
   
-(KSAPIOperation*) getAllDrinksWithFunction:(NSInteger)function andEventID:(NSUInteger)eventID;
    
   
-(KSAPIOperation*) getOnePostWithEventPostDBID:(NSUInteger)eventPostDBID;
    
   
-(KSAPIOperation*) getPostWithEventID:(NSUInteger)eventID;
    
   
-(KSAPIOperation*) getPostCountWithEventID:(NSUInteger)eventID;
    
   
-(KSAPIOperation*) getPostInRangeWithEventID:(NSUInteger)eventID andStartNumber:(NSNumber*)startNumber andRangeNumber:(NSNumber*)rangeNumber;
    
   
-(KSAPIOperation*) updateDrinkLocationWithDrinksDetail:(NSData*)drinksDetail andEventPostDBID:(NSUInteger)eventPostDBID;
    
   
-(KSAPIOperation*) checkLikeWithUserID:(NSUInteger)userID andLikeID:(NSUInteger)likeID andEventID:(NSUInteger)eventID;
    
   
-(KSAPIOperation*) createPostLikeWithUserID:(NSUInteger)userID andLikeID:(NSUInteger)likeID andEventID:(NSUInteger)eventID;
    
   
-(KSAPIOperation*) getPostLikeWithEventID:(NSUInteger)eventID;
    
   
-(KSAPIOperation*) checkFriendsWithUserDBID:(NSUInteger)userDBID andFriendsUserDBID:(NSUInteger)friendsUserDBID;
    
   
-(KSAPIOperation*) createFriendsWithFriendsName:(NSString*)friendsName andUserDBID:(NSUInteger)userDBID andFriendsUserDBID:(NSUInteger)friendsUserDBID;
    
   
-(KSAPIOperation*) getAllFriendsWithUserDBID:(NSUInteger)userDBID;
    
   
-(KSAPIOperation*) updateFriendsWithFriendsName:(NSString*)friendsName andFriendsDBID:(NSUInteger)friendsDBID;
    
   
-(KSAPIOperation*) deleteIconWithPhotosDBID:(NSUInteger)photosDBID;
    
   
-(KSAPIOperation*) getPhotoWithPhotosDBID:(NSUInteger)photosDBID;
    
   
-(KSAPIOperation*) uploadPhotosWithPhotoValue:(NSData*)photoValue andTextValue:(NSString*)textValue andLargePhotoValue:(NSData*)largePhotoValue;
    
   
-(KSAPIOperation*) createUserAPIWithUserID:(NSString*)userID andUserName:(NSString*)userName andUserPassword:(NSString*)userPassword andPhotosDBID:(NSInteger)photosDBID andLatitude:(float)latitude andLongitude:(float)longitude andDeviceToken:(NSString*)deviceToken andBadgeNumber:(NSInteger)badgeNumber andLoginType:(NSInteger)loginType;
    
   
-(KSAPIOperation*) getFriendByNameWithUserName:(NSString*)userName;
    
   
-(KSAPIOperation*) getUserDBWithUserID:(NSString*)userID andUserPassword:(NSString*)userPassword;
    
   
-(KSAPIOperation*) getUserDBByFacebookIDWithUserID:(NSString*)userID;
    
   
-(KSAPIOperation*) getUserInfoByDBIDWithUserDBID:(NSUInteger)userDBID;
    
   
-(KSAPIOperation*) updateBadgeNumberWithUserDBID:(NSUInteger)userDBID andBadgeNumber:(NSInteger)badgeNumber;
    
   
-(KSAPIOperation*) updateDeviceTokenWithDeviceToken:(NSString*)deviceToken andUserDBID:(NSUInteger)userDBID;
    
   
-(KSAPIOperation*) updateMyDetailsWithUserDBID:(NSUInteger)userDBID andUserName:(NSString*)userName andUserPassword:(NSString*)userPassword;
    
   
-(KSAPIOperation*) updateUserIconWithPhotosDBID:(NSInteger)photosDBID andUserDBID:(NSUInteger)userDBID;
    
            
@end