//
//  Kumulos.m
//  Kumulos
//
//  Created by Kumulos Bindings Compiler on Oct  5, 2012
//  Copyright Queensland University of Technology All rights reserved.
//

#import "Kumulos.h"

@implementation Kumulos

-(Kumulos*)init {

    if ([super init]) {
        theAPIKey = @"9cvy1q1462wd60cwxzzr3gtc410q71tz";
        theSecretKey = @"13kyfj50";
        useSSL = NO;
    }

    return self;
}

-(Kumulos*)initWithAPIKey:(NSString*)APIKey andSecretKey:(NSString*)secretKey{
    if([super init]){
        theAPIKey = [APIKey copy];
        theSecretKey = [secretKey copy];
    }
    return self;
 }


-(KSAPIOperation*) changeEventLocationWithEventDBID:(NSUInteger)eventDBID andLocationLongitude:(float)locationLongitude andLocationLatitude:(float)locationLatitude andLocationAddress:(NSString*)locationAddress andLocationName:(NSString*)locationName{

    
     NSMutableDictionary* theParams = [[NSMutableDictionary alloc]init];
            [theParams setValue:[NSNumber numberWithInt:eventDBID] forKey:@"eventDBID"];
                    [theParams setValue:[NSNumber numberWithFloat:locationLongitude] forKey:@"locationLongitude"];
                    [theParams setValue:[NSNumber numberWithFloat:locationLatitude] forKey:@"locationLatitude"];
                    [theParams setValue:locationAddress forKey:@"locationAddress"];
                    [theParams setValue:locationName forKey:@"locationName"];
                        
    KSAPIOperation* newOp = [[KSAPIOperation alloc]initWithAPIKey:theAPIKey andSecretKey:theSecretKey andMethodName:@"changeEventLocation" andParams:theParams];
    [newOp setDelegate:self];
    [newOp setUseSSL:useSSL];
            
    //we pass the method signature for the kumulosProxy callback on this thread
 
    [newOp setCallbackSelector:@selector( kumulosAPI: apiOperation: changeEventLocationDidCompleteWithResult:)];
    [newOp setSuccessCallbackMethodSignature:[self methodSignatureForSelector:@selector(apiOperation: didCompleteWithResult:)]];
    [newOp setErrorCallbackMethodSignature:[self methodSignatureForSelector:@selector(apiOperation: didFailWithError:)]];
    [opQueue addOperation:newOp];
 
    return newOp;
    
}

-(KSAPIOperation*) createEventsWithEventName:(NSString*)eventName andEventTime:(NSDate*)eventTime andStartTime:(NSDate*)startTime andEndTime:(NSDate*)endTime andIsValid:(BOOL)isValid andLocationName:(NSString*)locationName andLocationAddress:(NSString*)locationAddress andLocationLatitude:(float)locationLatitude andLocationLongitude:(float)locationLongitude andEventDetails:(NSString*)eventDetails andEventIconDBID:(NSInteger)eventIconDBID{

    
     NSMutableDictionary* theParams = [[NSMutableDictionary alloc]init];
            [theParams setValue:eventName forKey:@"eventName"];
                    [theParams setValue:eventTime forKey:@"eventTime"];
                    [theParams setValue:startTime forKey:@"startTime"];
                    [theParams setValue:endTime forKey:@"endTime"];
                    [theParams setValue:[NSNumber numberWithBool:isValid] forKey:@"isValid"];
                    [theParams setValue:locationName forKey:@"locationName"];
                    [theParams setValue:locationAddress forKey:@"locationAddress"];
                    [theParams setValue:[NSNumber numberWithFloat:locationLatitude] forKey:@"locationLatitude"];
                    [theParams setValue:[NSNumber numberWithFloat:locationLongitude] forKey:@"locationLongitude"];
                    [theParams setValue:eventDetails forKey:@"eventDetails"];
                    [theParams setValue:[NSNumber numberWithInt:eventIconDBID] forKey:@"eventIconDBID"];
                        
    KSAPIOperation* newOp = [[KSAPIOperation alloc]initWithAPIKey:theAPIKey andSecretKey:theSecretKey andMethodName:@"createEvents" andParams:theParams];
    [newOp setDelegate:self];
    [newOp setUseSSL:useSSL];
            
    //we pass the method signature for the kumulosProxy callback on this thread
 
    [newOp setCallbackSelector:@selector( kumulosAPI: apiOperation: createEventsDidCompleteWithResult:)];
    [newOp setSuccessCallbackMethodSignature:[self methodSignatureForSelector:@selector(apiOperation: didCompleteWithResult:)]];
    [newOp setErrorCallbackMethodSignature:[self methodSignatureForSelector:@selector(apiOperation: didFailWithError:)]];
    [opQueue addOperation:newOp];
 
    return newOp;
    
}

-(KSAPIOperation*) deleteEventWithEventDBID:(NSUInteger)eventDBID{

    
     NSMutableDictionary* theParams = [[NSMutableDictionary alloc]init];
            [theParams setValue:[NSNumber numberWithInt:eventDBID] forKey:@"eventDBID"];
                        
    KSAPIOperation* newOp = [[KSAPIOperation alloc]initWithAPIKey:theAPIKey andSecretKey:theSecretKey andMethodName:@"deleteEvent" andParams:theParams];
    [newOp setDelegate:self];
    [newOp setUseSSL:useSSL];
            
    //we pass the method signature for the kumulosProxy callback on this thread
 
    [newOp setCallbackSelector:@selector( kumulosAPI: apiOperation: deleteEventDidCompleteWithResult:)];
    [newOp setSuccessCallbackMethodSignature:[self methodSignatureForSelector:@selector(apiOperation: didCompleteWithResult:)]];
    [newOp setErrorCallbackMethodSignature:[self methodSignatureForSelector:@selector(apiOperation: didFailWithError:)]];
    [opQueue addOperation:newOp];
 
    return newOp;
    
}

-(KSAPIOperation*) editEventWithEventName:(NSString*)eventName andEventTime:(NSDate*)eventTime andLocationName:(NSString*)locationName andLocationAddress:(NSString*)locationAddress andLocationLatitude:(float)locationLatitude andLocationLongitude:(float)locationLongitude andEventDetails:(NSString*)eventDetails andEventDBID:(NSUInteger)eventDBID{

    
     NSMutableDictionary* theParams = [[NSMutableDictionary alloc]init];
            [theParams setValue:eventName forKey:@"eventName"];
                    [theParams setValue:eventTime forKey:@"eventTime"];
                    [theParams setValue:locationName forKey:@"locationName"];
                    [theParams setValue:locationAddress forKey:@"locationAddress"];
                    [theParams setValue:[NSNumber numberWithFloat:locationLatitude] forKey:@"locationLatitude"];
                    [theParams setValue:[NSNumber numberWithFloat:locationLongitude] forKey:@"locationLongitude"];
                    [theParams setValue:eventDetails forKey:@"eventDetails"];
                    [theParams setValue:[NSNumber numberWithInt:eventDBID] forKey:@"eventDBID"];
                        
    KSAPIOperation* newOp = [[KSAPIOperation alloc]initWithAPIKey:theAPIKey andSecretKey:theSecretKey andMethodName:@"editEvent" andParams:theParams];
    [newOp setDelegate:self];
    [newOp setUseSSL:useSSL];
            
    //we pass the method signature for the kumulosProxy callback on this thread
 
    [newOp setCallbackSelector:@selector( kumulosAPI: apiOperation: editEventDidCompleteWithResult:)];
    [newOp setSuccessCallbackMethodSignature:[self methodSignatureForSelector:@selector(apiOperation: didCompleteWithResult:)]];
    [newOp setErrorCallbackMethodSignature:[self methodSignatureForSelector:@selector(apiOperation: didFailWithError:)]];
    [opQueue addOperation:newOp];
 
    return newOp;
    
}

-(KSAPIOperation*) updateEventIconWithEventIconDBID:(NSInteger)eventIconDBID andEventDBID:(NSUInteger)eventDBID{

    
     NSMutableDictionary* theParams = [[NSMutableDictionary alloc]init];
            [theParams setValue:[NSNumber numberWithInt:eventIconDBID] forKey:@"eventIconDBID"];
                    [theParams setValue:[NSNumber numberWithInt:eventDBID] forKey:@"eventDBID"];
                        
    KSAPIOperation* newOp = [[KSAPIOperation alloc]initWithAPIKey:theAPIKey andSecretKey:theSecretKey andMethodName:@"updateEventIcon" andParams:theParams];
    [newOp setDelegate:self];
    [newOp setUseSSL:useSSL];
            
    //we pass the method signature for the kumulosProxy callback on this thread
 
    [newOp setCallbackSelector:@selector( kumulosAPI: apiOperation: updateEventIconDidCompleteWithResult:)];
    [newOp setSuccessCallbackMethodSignature:[self methodSignatureForSelector:@selector(apiOperation: didCompleteWithResult:)]];
    [newOp setErrorCallbackMethodSignature:[self methodSignatureForSelector:@selector(apiOperation: didFailWithError:)]];
    [opQueue addOperation:newOp];
 
    return newOp;
    
}

-(KSAPIOperation*) checkInviteFriendWithEventID:(NSUInteger)eventID andUserID:(NSUInteger)userID{

    
     NSMutableDictionary* theParams = [[NSMutableDictionary alloc]init];
            [theParams setValue:[NSNumber numberWithInt:eventID] forKey:@"eventID"];
                    [theParams setValue:[NSNumber numberWithInt:userID] forKey:@"userID"];
                        
    KSAPIOperation* newOp = [[KSAPIOperation alloc]initWithAPIKey:theAPIKey andSecretKey:theSecretKey andMethodName:@"checkInviteFriend" andParams:theParams];
    [newOp setDelegate:self];
    [newOp setUseSSL:useSSL];
            
    //we pass the method signature for the kumulosProxy callback on this thread
 
    [newOp setCallbackSelector:@selector( kumulosAPI: apiOperation: checkInviteFriendDidCompleteWithResult:)];
    [newOp setSuccessCallbackMethodSignature:[self methodSignatureForSelector:@selector(apiOperation: didCompleteWithResult:)]];
    [newOp setErrorCallbackMethodSignature:[self methodSignatureForSelector:@selector(apiOperation: didFailWithError:)]];
    [opQueue addOperation:newOp];
 
    return newOp;
    
}

-(KSAPIOperation*) creatEventOrganizerWithRole:(NSString*)role andIsConfirm:(NSInteger)isConfirm andIsHome:(NSInteger)isHome andEventID:(NSUInteger)eventID andUserID:(NSUInteger)userID{

    
     NSMutableDictionary* theParams = [[NSMutableDictionary alloc]init];
            [theParams setValue:role forKey:@"role"];
                    [theParams setValue:[NSNumber numberWithInt:isConfirm] forKey:@"isConfirm"];
                    [theParams setValue:[NSNumber numberWithInt:isHome] forKey:@"isHome"];
                    [theParams setValue:[NSNumber numberWithInt:eventID] forKey:@"eventID"];
                    [theParams setValue:[NSNumber numberWithInt:userID] forKey:@"userID"];
                        
    KSAPIOperation* newOp = [[KSAPIOperation alloc]initWithAPIKey:theAPIKey andSecretKey:theSecretKey andMethodName:@"creatEventOrganizer" andParams:theParams];
    [newOp setDelegate:self];
    [newOp setUseSSL:useSSL];
            
    //we pass the method signature for the kumulosProxy callback on this thread
 
    [newOp setCallbackSelector:@selector( kumulosAPI: apiOperation: creatEventOrganizerDidCompleteWithResult:)];
    [newOp setSuccessCallbackMethodSignature:[self methodSignatureForSelector:@selector(apiOperation: didCompleteWithResult:)]];
    [newOp setErrorCallbackMethodSignature:[self methodSignatureForSelector:@selector(apiOperation: didFailWithError:)]];
    [opQueue addOperation:newOp];
 
    return newOp;
    
}

-(KSAPIOperation*) delectPeopleInEventWithEventID:(NSUInteger)eventID andUserID:(NSUInteger)userID{

    
     NSMutableDictionary* theParams = [[NSMutableDictionary alloc]init];
            [theParams setValue:[NSNumber numberWithInt:eventID] forKey:@"eventID"];
                    [theParams setValue:[NSNumber numberWithInt:userID] forKey:@"userID"];
                        
    KSAPIOperation* newOp = [[KSAPIOperation alloc]initWithAPIKey:theAPIKey andSecretKey:theSecretKey andMethodName:@"delectPeopleInEvent" andParams:theParams];
    [newOp setDelegate:self];
    [newOp setUseSSL:useSSL];
            
    //we pass the method signature for the kumulosProxy callback on this thread
 
    [newOp setCallbackSelector:@selector( kumulosAPI: apiOperation: delectPeopleInEventDidCompleteWithResult:)];
    [newOp setSuccessCallbackMethodSignature:[self methodSignatureForSelector:@selector(apiOperation: didCompleteWithResult:)]];
    [newOp setErrorCallbackMethodSignature:[self methodSignatureForSelector:@selector(apiOperation: didFailWithError:)]];
    [opQueue addOperation:newOp];
 
    return newOp;
    
}

-(KSAPIOperation*) getAllEventsWithUserID:(NSUInteger)userID{

    
     NSMutableDictionary* theParams = [[NSMutableDictionary alloc]init];
            [theParams setValue:[NSNumber numberWithInt:userID] forKey:@"userID"];
                        
    KSAPIOperation* newOp = [[KSAPIOperation alloc]initWithAPIKey:theAPIKey andSecretKey:theSecretKey andMethodName:@"getAllEvents" andParams:theParams];
    [newOp setDelegate:self];
    [newOp setUseSSL:useSSL];
            
    //we pass the method signature for the kumulosProxy callback on this thread
 
    [newOp setCallbackSelector:@selector( kumulosAPI: apiOperation: getAllEventsDidCompleteWithResult:)];
    [newOp setSuccessCallbackMethodSignature:[self methodSignatureForSelector:@selector(apiOperation: didCompleteWithResult:)]];
    [newOp setErrorCallbackMethodSignature:[self methodSignatureForSelector:@selector(apiOperation: didFailWithError:)]];
    [opQueue addOperation:newOp];
 
    return newOp;
    
}

-(KSAPIOperation*) getOneEventWithEventPeopleDBID:(NSUInteger)eventPeopleDBID{

    
     NSMutableDictionary* theParams = [[NSMutableDictionary alloc]init];
            [theParams setValue:[NSNumber numberWithInt:eventPeopleDBID] forKey:@"eventPeopleDBID"];
                        
    KSAPIOperation* newOp = [[KSAPIOperation alloc]initWithAPIKey:theAPIKey andSecretKey:theSecretKey andMethodName:@"getOneEvent" andParams:theParams];
    [newOp setDelegate:self];
    [newOp setUseSSL:useSSL];
            
    //we pass the method signature for the kumulosProxy callback on this thread
 
    [newOp setCallbackSelector:@selector( kumulosAPI: apiOperation: getOneEventDidCompleteWithResult:)];
    [newOp setSuccessCallbackMethodSignature:[self methodSignatureForSelector:@selector(apiOperation: didCompleteWithResult:)]];
    [newOp setErrorCallbackMethodSignature:[self methodSignatureForSelector:@selector(apiOperation: didFailWithError:)]];
    [opQueue addOperation:newOp];
 
    return newOp;
    
}

-(KSAPIOperation*) getPeopleFromEventWithEventID:(NSUInteger)eventID{

    
     NSMutableDictionary* theParams = [[NSMutableDictionary alloc]init];
            [theParams setValue:[NSNumber numberWithInt:eventID] forKey:@"eventID"];
                        
    KSAPIOperation* newOp = [[KSAPIOperation alloc]initWithAPIKey:theAPIKey andSecretKey:theSecretKey andMethodName:@"getPeopleFromEvent" andParams:theParams];
    [newOp setDelegate:self];
    [newOp setUseSSL:useSSL];
            
    //we pass the method signature for the kumulosProxy callback on this thread
 
    [newOp setCallbackSelector:@selector( kumulosAPI: apiOperation: getPeopleFromEventDidCompleteWithResult:)];
    [newOp setSuccessCallbackMethodSignature:[self methodSignatureForSelector:@selector(apiOperation: didCompleteWithResult:)]];
    [newOp setErrorCallbackMethodSignature:[self methodSignatureForSelector:@selector(apiOperation: didFailWithError:)]];
    [opQueue addOperation:newOp];
 
    return newOp;
    
}

-(KSAPIOperation*) inviteFriendsWithRole:(NSString*)role andIsConfirm:(NSInteger)isConfirm andIsHome:(NSInteger)isHome andEventID:(NSUInteger)eventID andUserID:(NSUInteger)userID{

    
     NSMutableDictionary* theParams = [[NSMutableDictionary alloc]init];
            [theParams setValue:role forKey:@"role"];
                    [theParams setValue:[NSNumber numberWithInt:isConfirm] forKey:@"isConfirm"];
                    [theParams setValue:[NSNumber numberWithInt:isHome] forKey:@"isHome"];
                    [theParams setValue:[NSNumber numberWithInt:eventID] forKey:@"eventID"];
                    [theParams setValue:[NSNumber numberWithInt:userID] forKey:@"userID"];
                        
    KSAPIOperation* newOp = [[KSAPIOperation alloc]initWithAPIKey:theAPIKey andSecretKey:theSecretKey andMethodName:@"inviteFriends" andParams:theParams];
    [newOp setDelegate:self];
    [newOp setUseSSL:useSSL];
            
    //we pass the method signature for the kumulosProxy callback on this thread
 
    [newOp setCallbackSelector:@selector( kumulosAPI: apiOperation: inviteFriendsDidCompleteWithResult:)];
    [newOp setSuccessCallbackMethodSignature:[self methodSignatureForSelector:@selector(apiOperation: didCompleteWithResult:)]];
    [newOp setErrorCallbackMethodSignature:[self methodSignatureForSelector:@selector(apiOperation: didFailWithError:)]];
    [opQueue addOperation:newOp];
 
    return newOp;
    
}

-(KSAPIOperation*) isAttentEventWithEventPeopleDBID:(NSUInteger)eventPeopleDBID andIsConfirm:(NSInteger)isConfirm{

    
     NSMutableDictionary* theParams = [[NSMutableDictionary alloc]init];
            [theParams setValue:[NSNumber numberWithInt:eventPeopleDBID] forKey:@"eventPeopleDBID"];
                    [theParams setValue:[NSNumber numberWithInt:isConfirm] forKey:@"isConfirm"];
                        
    KSAPIOperation* newOp = [[KSAPIOperation alloc]initWithAPIKey:theAPIKey andSecretKey:theSecretKey andMethodName:@"isAttentEvent" andParams:theParams];
    [newOp setDelegate:self];
    [newOp setUseSSL:useSSL];
            
    //we pass the method signature for the kumulosProxy callback on this thread
 
    [newOp setCallbackSelector:@selector( kumulosAPI: apiOperation: isAttentEventDidCompleteWithResult:)];
    [newOp setSuccessCallbackMethodSignature:[self methodSignatureForSelector:@selector(apiOperation: didCompleteWithResult:)]];
    [newOp setErrorCallbackMethodSignature:[self methodSignatureForSelector:@selector(apiOperation: didFailWithError:)]];
    [opQueue addOperation:newOp];
 
    return newOp;
    
}

-(KSAPIOperation*) updateHomeStatusWithIsHome:(NSInteger)isHome andEventPeopleDBID:(NSUInteger)eventPeopleDBID{

    
     NSMutableDictionary* theParams = [[NSMutableDictionary alloc]init];
            [theParams setValue:[NSNumber numberWithInt:isHome] forKey:@"isHome"];
                    [theParams setValue:[NSNumber numberWithInt:eventPeopleDBID] forKey:@"eventPeopleDBID"];
                        
    KSAPIOperation* newOp = [[KSAPIOperation alloc]initWithAPIKey:theAPIKey andSecretKey:theSecretKey andMethodName:@"updateHomeStatus" andParams:theParams];
    [newOp setDelegate:self];
    [newOp setUseSSL:useSSL];
            
    //we pass the method signature for the kumulosProxy callback on this thread
 
    [newOp setCallbackSelector:@selector( kumulosAPI: apiOperation: updateHomeStatusDidCompleteWithResult:)];
    [newOp setSuccessCallbackMethodSignature:[self methodSignatureForSelector:@selector(apiOperation: didCompleteWithResult:)]];
    [newOp setErrorCallbackMethodSignature:[self methodSignatureForSelector:@selector(apiOperation: didFailWithError:)]];
    [opQueue addOperation:newOp];
 
    return newOp;
    
}

-(KSAPIOperation*) createPostCommentWithComment:(NSString*)comment andUserID:(NSUInteger)userID andPostID:(NSUInteger)postID andEventID:(NSUInteger)eventID{

    
     NSMutableDictionary* theParams = [[NSMutableDictionary alloc]init];
            [theParams setValue:comment forKey:@"comment"];
                    [theParams setValue:[NSNumber numberWithInt:userID] forKey:@"userID"];
                    [theParams setValue:[NSNumber numberWithInt:postID] forKey:@"postID"];
                    [theParams setValue:[NSNumber numberWithInt:eventID] forKey:@"eventID"];
                        
    KSAPIOperation* newOp = [[KSAPIOperation alloc]initWithAPIKey:theAPIKey andSecretKey:theSecretKey andMethodName:@"createPostComment" andParams:theParams];
    [newOp setDelegate:self];
    [newOp setUseSSL:useSSL];
            
    //we pass the method signature for the kumulosProxy callback on this thread
 
    [newOp setCallbackSelector:@selector( kumulosAPI: apiOperation: createPostCommentDidCompleteWithResult:)];
    [newOp setSuccessCallbackMethodSignature:[self methodSignatureForSelector:@selector(apiOperation: didCompleteWithResult:)]];
    [newOp setErrorCallbackMethodSignature:[self methodSignatureForSelector:@selector(apiOperation: didFailWithError:)]];
    [opQueue addOperation:newOp];
 
    return newOp;
    
}

-(KSAPIOperation*) getPostCommentWithEventID:(NSUInteger)eventID{

    
     NSMutableDictionary* theParams = [[NSMutableDictionary alloc]init];
            [theParams setValue:[NSNumber numberWithInt:eventID] forKey:@"eventID"];
                        
    KSAPIOperation* newOp = [[KSAPIOperation alloc]initWithAPIKey:theAPIKey andSecretKey:theSecretKey andMethodName:@"getPostComment" andParams:theParams];
    [newOp setDelegate:self];
    [newOp setUseSSL:useSSL];
            
    //we pass the method signature for the kumulosProxy callback on this thread
 
    [newOp setCallbackSelector:@selector( kumulosAPI: apiOperation: getPostCommentDidCompleteWithResult:)];
    [newOp setSuccessCallbackMethodSignature:[self methodSignatureForSelector:@selector(apiOperation: didCompleteWithResult:)]];
    [newOp setErrorCallbackMethodSignature:[self methodSignatureForSelector:@selector(apiOperation: didFailWithError:)]];
    [opQueue addOperation:newOp];
 
    return newOp;
    
}

-(KSAPIOperation*) createPostWithTextValue:(NSString*)textValue andFunction:(NSInteger)function andDrinksDetail:(NSData*)drinksDetail andPhotoDetail:(NSData*)photoDetail andUserID:(NSUInteger)userID andEventID:(NSUInteger)eventID{

    
     NSMutableDictionary* theParams = [[NSMutableDictionary alloc]init];
            [theParams setValue:textValue forKey:@"textValue"];
                    [theParams setValue:[NSNumber numberWithInt:function] forKey:@"function"];
                    [theParams setValue:drinksDetail forKey:@"drinksDetail"];
                    [theParams setValue:photoDetail forKey:@"photoDetail"];
                    [theParams setValue:[NSNumber numberWithInt:userID] forKey:@"userID"];
                    [theParams setValue:[NSNumber numberWithInt:eventID] forKey:@"eventID"];
                        
    KSAPIOperation* newOp = [[KSAPIOperation alloc]initWithAPIKey:theAPIKey andSecretKey:theSecretKey andMethodName:@"createPost" andParams:theParams];
    [newOp setDelegate:self];
    [newOp setUseSSL:useSSL];
            
    //we pass the method signature for the kumulosProxy callback on this thread
 
    [newOp setCallbackSelector:@selector( kumulosAPI: apiOperation: createPostDidCompleteWithResult:)];
    [newOp setSuccessCallbackMethodSignature:[self methodSignatureForSelector:@selector(apiOperation: didCompleteWithResult:)]];
    [newOp setErrorCallbackMethodSignature:[self methodSignatureForSelector:@selector(apiOperation: didFailWithError:)]];
    [opQueue addOperation:newOp];
 
    return newOp;
    
}

-(KSAPIOperation*) deletePostWithEventPostDBID:(NSUInteger)eventPostDBID{

    
     NSMutableDictionary* theParams = [[NSMutableDictionary alloc]init];
            [theParams setValue:[NSNumber numberWithInt:eventPostDBID] forKey:@"eventPostDBID"];
                        
    KSAPIOperation* newOp = [[KSAPIOperation alloc]initWithAPIKey:theAPIKey andSecretKey:theSecretKey andMethodName:@"deletePost" andParams:theParams];
    [newOp setDelegate:self];
    [newOp setUseSSL:useSSL];
            
    //we pass the method signature for the kumulosProxy callback on this thread
 
    [newOp setCallbackSelector:@selector( kumulosAPI: apiOperation: deletePostDidCompleteWithResult:)];
    [newOp setSuccessCallbackMethodSignature:[self methodSignatureForSelector:@selector(apiOperation: didCompleteWithResult:)]];
    [newOp setErrorCallbackMethodSignature:[self methodSignatureForSelector:@selector(apiOperation: didFailWithError:)]];
    [opQueue addOperation:newOp];
 
    return newOp;
    
}

-(KSAPIOperation*) getAllDrinksWithFunction:(NSInteger)function andEventID:(NSUInteger)eventID{

    
     NSMutableDictionary* theParams = [[NSMutableDictionary alloc]init];
            [theParams setValue:[NSNumber numberWithInt:function] forKey:@"function"];
                    [theParams setValue:[NSNumber numberWithInt:eventID] forKey:@"eventID"];
                        
    KSAPIOperation* newOp = [[KSAPIOperation alloc]initWithAPIKey:theAPIKey andSecretKey:theSecretKey andMethodName:@"getAllDrinks" andParams:theParams];
    [newOp setDelegate:self];
    [newOp setUseSSL:useSSL];
            
    //we pass the method signature for the kumulosProxy callback on this thread
 
    [newOp setCallbackSelector:@selector( kumulosAPI: apiOperation: getAllDrinksDidCompleteWithResult:)];
    [newOp setSuccessCallbackMethodSignature:[self methodSignatureForSelector:@selector(apiOperation: didCompleteWithResult:)]];
    [newOp setErrorCallbackMethodSignature:[self methodSignatureForSelector:@selector(apiOperation: didFailWithError:)]];
    [opQueue addOperation:newOp];
 
    return newOp;
    
}

-(KSAPIOperation*) getOnePostWithEventPostDBID:(NSUInteger)eventPostDBID{

    
     NSMutableDictionary* theParams = [[NSMutableDictionary alloc]init];
            [theParams setValue:[NSNumber numberWithInt:eventPostDBID] forKey:@"eventPostDBID"];
                        
    KSAPIOperation* newOp = [[KSAPIOperation alloc]initWithAPIKey:theAPIKey andSecretKey:theSecretKey andMethodName:@"getOnePost" andParams:theParams];
    [newOp setDelegate:self];
    [newOp setUseSSL:useSSL];
            
    //we pass the method signature for the kumulosProxy callback on this thread
 
    [newOp setCallbackSelector:@selector( kumulosAPI: apiOperation: getOnePostDidCompleteWithResult:)];
    [newOp setSuccessCallbackMethodSignature:[self methodSignatureForSelector:@selector(apiOperation: didCompleteWithResult:)]];
    [newOp setErrorCallbackMethodSignature:[self methodSignatureForSelector:@selector(apiOperation: didFailWithError:)]];
    [opQueue addOperation:newOp];
 
    return newOp;
    
}

-(KSAPIOperation*) getPostWithEventID:(NSUInteger)eventID{

    
     NSMutableDictionary* theParams = [[NSMutableDictionary alloc]init];
            [theParams setValue:[NSNumber numberWithInt:eventID] forKey:@"eventID"];
                        
    KSAPIOperation* newOp = [[KSAPIOperation alloc]initWithAPIKey:theAPIKey andSecretKey:theSecretKey andMethodName:@"getPost" andParams:theParams];
    [newOp setDelegate:self];
    [newOp setUseSSL:useSSL];
            
    //we pass the method signature for the kumulosProxy callback on this thread
 
    [newOp setCallbackSelector:@selector( kumulosAPI: apiOperation: getPostDidCompleteWithResult:)];
    [newOp setSuccessCallbackMethodSignature:[self methodSignatureForSelector:@selector(apiOperation: didCompleteWithResult:)]];
    [newOp setErrorCallbackMethodSignature:[self methodSignatureForSelector:@selector(apiOperation: didFailWithError:)]];
    [opQueue addOperation:newOp];
 
    return newOp;
    
}

-(KSAPIOperation*) getPostCountWithEventID:(NSUInteger)eventID{

    
     NSMutableDictionary* theParams = [[NSMutableDictionary alloc]init];
            [theParams setValue:[NSNumber numberWithInt:eventID] forKey:@"eventID"];
                        
    KSAPIOperation* newOp = [[KSAPIOperation alloc]initWithAPIKey:theAPIKey andSecretKey:theSecretKey andMethodName:@"getPostCount" andParams:theParams];
    [newOp setDelegate:self];
    [newOp setUseSSL:useSSL];
            
    //we pass the method signature for the kumulosProxy callback on this thread
 
    [newOp setCallbackSelector:@selector( kumulosAPI: apiOperation: getPostCountDidCompleteWithResult:)];
    [newOp setSuccessCallbackMethodSignature:[self methodSignatureForSelector:@selector(apiOperation: didCompleteWithResult:)]];
    [newOp setErrorCallbackMethodSignature:[self methodSignatureForSelector:@selector(apiOperation: didFailWithError:)]];
    [opQueue addOperation:newOp];
 
    return newOp;
    
}

-(KSAPIOperation*) getPostInRangeWithEventID:(NSUInteger)eventID andStartNumber:(NSNumber*)startNumber andRangeNumber:(NSNumber*)rangeNumber{

    
     NSMutableDictionary* theParams = [[NSMutableDictionary alloc]init];
            [theParams setValue:[NSNumber numberWithInt:eventID] forKey:@"eventID"];
                    [theParams setValue:startNumber forKey:@"startNumber"];
                    [theParams setValue:rangeNumber forKey:@"rangeNumber"];
                        
    KSAPIOperation* newOp = [[KSAPIOperation alloc]initWithAPIKey:theAPIKey andSecretKey:theSecretKey andMethodName:@"getPostInRange" andParams:theParams];
    [newOp setDelegate:self];
    [newOp setUseSSL:useSSL];
            
    //we pass the method signature for the kumulosProxy callback on this thread
 
    [newOp setCallbackSelector:@selector( kumulosAPI: apiOperation: getPostInRangeDidCompleteWithResult:)];
    [newOp setSuccessCallbackMethodSignature:[self methodSignatureForSelector:@selector(apiOperation: didCompleteWithResult:)]];
    [newOp setErrorCallbackMethodSignature:[self methodSignatureForSelector:@selector(apiOperation: didFailWithError:)]];
    [opQueue addOperation:newOp];
 
    return newOp;
    
}

-(KSAPIOperation*) updateDrinkLocationWithDrinksDetail:(NSData*)drinksDetail andEventPostDBID:(NSUInteger)eventPostDBID{

    
     NSMutableDictionary* theParams = [[NSMutableDictionary alloc]init];
            [theParams setValue:drinksDetail forKey:@"drinksDetail"];
                    [theParams setValue:[NSNumber numberWithInt:eventPostDBID] forKey:@"eventPostDBID"];
                        
    KSAPIOperation* newOp = [[KSAPIOperation alloc]initWithAPIKey:theAPIKey andSecretKey:theSecretKey andMethodName:@"updateDrinkLocation" andParams:theParams];
    [newOp setDelegate:self];
    [newOp setUseSSL:useSSL];
            
    //we pass the method signature for the kumulosProxy callback on this thread
 
    [newOp setCallbackSelector:@selector( kumulosAPI: apiOperation: updateDrinkLocationDidCompleteWithResult:)];
    [newOp setSuccessCallbackMethodSignature:[self methodSignatureForSelector:@selector(apiOperation: didCompleteWithResult:)]];
    [newOp setErrorCallbackMethodSignature:[self methodSignatureForSelector:@selector(apiOperation: didFailWithError:)]];
    [opQueue addOperation:newOp];
 
    return newOp;
    
}

-(KSAPIOperation*) checkLikeWithUserID:(NSUInteger)userID andLikeID:(NSUInteger)likeID andEventID:(NSUInteger)eventID{

    
     NSMutableDictionary* theParams = [[NSMutableDictionary alloc]init];
            [theParams setValue:[NSNumber numberWithInt:userID] forKey:@"userID"];
                    [theParams setValue:[NSNumber numberWithInt:likeID] forKey:@"likeID"];
                    [theParams setValue:[NSNumber numberWithInt:eventID] forKey:@"eventID"];
                        
    KSAPIOperation* newOp = [[KSAPIOperation alloc]initWithAPIKey:theAPIKey andSecretKey:theSecretKey andMethodName:@"checkLike" andParams:theParams];
    [newOp setDelegate:self];
    [newOp setUseSSL:useSSL];
            
    //we pass the method signature for the kumulosProxy callback on this thread
 
    [newOp setCallbackSelector:@selector( kumulosAPI: apiOperation: checkLikeDidCompleteWithResult:)];
    [newOp setSuccessCallbackMethodSignature:[self methodSignatureForSelector:@selector(apiOperation: didCompleteWithResult:)]];
    [newOp setErrorCallbackMethodSignature:[self methodSignatureForSelector:@selector(apiOperation: didFailWithError:)]];
    [opQueue addOperation:newOp];
 
    return newOp;
    
}

-(KSAPIOperation*) createPostLikeWithUserID:(NSUInteger)userID andLikeID:(NSUInteger)likeID andEventID:(NSUInteger)eventID{

    
     NSMutableDictionary* theParams = [[NSMutableDictionary alloc]init];
            [theParams setValue:[NSNumber numberWithInt:userID] forKey:@"userID"];
                    [theParams setValue:[NSNumber numberWithInt:likeID] forKey:@"likeID"];
                    [theParams setValue:[NSNumber numberWithInt:eventID] forKey:@"eventID"];
                        
    KSAPIOperation* newOp = [[KSAPIOperation alloc]initWithAPIKey:theAPIKey andSecretKey:theSecretKey andMethodName:@"createPostLike" andParams:theParams];
    [newOp setDelegate:self];
    [newOp setUseSSL:useSSL];
            
    //we pass the method signature for the kumulosProxy callback on this thread
 
    [newOp setCallbackSelector:@selector( kumulosAPI: apiOperation: createPostLikeDidCompleteWithResult:)];
    [newOp setSuccessCallbackMethodSignature:[self methodSignatureForSelector:@selector(apiOperation: didCompleteWithResult:)]];
    [newOp setErrorCallbackMethodSignature:[self methodSignatureForSelector:@selector(apiOperation: didFailWithError:)]];
    [opQueue addOperation:newOp];
 
    return newOp;
    
}

-(KSAPIOperation*) getPostLikeWithEventID:(NSUInteger)eventID{

    
     NSMutableDictionary* theParams = [[NSMutableDictionary alloc]init];
            [theParams setValue:[NSNumber numberWithInt:eventID] forKey:@"eventID"];
                        
    KSAPIOperation* newOp = [[KSAPIOperation alloc]initWithAPIKey:theAPIKey andSecretKey:theSecretKey andMethodName:@"getPostLike" andParams:theParams];
    [newOp setDelegate:self];
    [newOp setUseSSL:useSSL];
            
    //we pass the method signature for the kumulosProxy callback on this thread
 
    [newOp setCallbackSelector:@selector( kumulosAPI: apiOperation: getPostLikeDidCompleteWithResult:)];
    [newOp setSuccessCallbackMethodSignature:[self methodSignatureForSelector:@selector(apiOperation: didCompleteWithResult:)]];
    [newOp setErrorCallbackMethodSignature:[self methodSignatureForSelector:@selector(apiOperation: didFailWithError:)]];
    [opQueue addOperation:newOp];
 
    return newOp;
    
}

-(KSAPIOperation*) checkFriendsWithUserDBID:(NSUInteger)userDBID andFriendsUserDBID:(NSUInteger)friendsUserDBID{

    
     NSMutableDictionary* theParams = [[NSMutableDictionary alloc]init];
            [theParams setValue:[NSNumber numberWithInt:userDBID] forKey:@"userDBID"];
                    [theParams setValue:[NSNumber numberWithInt:friendsUserDBID] forKey:@"friendsUserDBID"];
                        
    KSAPIOperation* newOp = [[KSAPIOperation alloc]initWithAPIKey:theAPIKey andSecretKey:theSecretKey andMethodName:@"checkFriends" andParams:theParams];
    [newOp setDelegate:self];
    [newOp setUseSSL:useSSL];
            
    //we pass the method signature for the kumulosProxy callback on this thread
 
    [newOp setCallbackSelector:@selector( kumulosAPI: apiOperation: checkFriendsDidCompleteWithResult:)];
    [newOp setSuccessCallbackMethodSignature:[self methodSignatureForSelector:@selector(apiOperation: didCompleteWithResult:)]];
    [newOp setErrorCallbackMethodSignature:[self methodSignatureForSelector:@selector(apiOperation: didFailWithError:)]];
    [opQueue addOperation:newOp];
 
    return newOp;
    
}

-(KSAPIOperation*) createFriendsWithFriendsName:(NSString*)friendsName andUserDBID:(NSUInteger)userDBID andFriendsUserDBID:(NSUInteger)friendsUserDBID{

    
     NSMutableDictionary* theParams = [[NSMutableDictionary alloc]init];
            [theParams setValue:friendsName forKey:@"friendsName"];
                    [theParams setValue:[NSNumber numberWithInt:userDBID] forKey:@"userDBID"];
                    [theParams setValue:[NSNumber numberWithInt:friendsUserDBID] forKey:@"friendsUserDBID"];
                        
    KSAPIOperation* newOp = [[KSAPIOperation alloc]initWithAPIKey:theAPIKey andSecretKey:theSecretKey andMethodName:@"createFriends" andParams:theParams];
    [newOp setDelegate:self];
    [newOp setUseSSL:useSSL];
            
    //we pass the method signature for the kumulosProxy callback on this thread
 
    [newOp setCallbackSelector:@selector( kumulosAPI: apiOperation: createFriendsDidCompleteWithResult:)];
    [newOp setSuccessCallbackMethodSignature:[self methodSignatureForSelector:@selector(apiOperation: didCompleteWithResult:)]];
    [newOp setErrorCallbackMethodSignature:[self methodSignatureForSelector:@selector(apiOperation: didFailWithError:)]];
    [opQueue addOperation:newOp];
 
    return newOp;
    
}

-(KSAPIOperation*) getAllFriendsWithUserDBID:(NSUInteger)userDBID{

    
     NSMutableDictionary* theParams = [[NSMutableDictionary alloc]init];
            [theParams setValue:[NSNumber numberWithInt:userDBID] forKey:@"userDBID"];
                        
    KSAPIOperation* newOp = [[KSAPIOperation alloc]initWithAPIKey:theAPIKey andSecretKey:theSecretKey andMethodName:@"getAllFriends" andParams:theParams];
    [newOp setDelegate:self];
    [newOp setUseSSL:useSSL];
            
    //we pass the method signature for the kumulosProxy callback on this thread
 
    [newOp setCallbackSelector:@selector( kumulosAPI: apiOperation: getAllFriendsDidCompleteWithResult:)];
    [newOp setSuccessCallbackMethodSignature:[self methodSignatureForSelector:@selector(apiOperation: didCompleteWithResult:)]];
    [newOp setErrorCallbackMethodSignature:[self methodSignatureForSelector:@selector(apiOperation: didFailWithError:)]];
    [opQueue addOperation:newOp];
 
    return newOp;
    
}

-(KSAPIOperation*) updateFriendsWithFriendsName:(NSString*)friendsName andFriendsDBID:(NSUInteger)friendsDBID{

    
     NSMutableDictionary* theParams = [[NSMutableDictionary alloc]init];
            [theParams setValue:friendsName forKey:@"friendsName"];
                    [theParams setValue:[NSNumber numberWithInt:friendsDBID] forKey:@"friendsDBID"];
                        
    KSAPIOperation* newOp = [[KSAPIOperation alloc]initWithAPIKey:theAPIKey andSecretKey:theSecretKey andMethodName:@"updateFriends" andParams:theParams];
    [newOp setDelegate:self];
    [newOp setUseSSL:useSSL];
            
    //we pass the method signature for the kumulosProxy callback on this thread
 
    [newOp setCallbackSelector:@selector( kumulosAPI: apiOperation: updateFriendsDidCompleteWithResult:)];
    [newOp setSuccessCallbackMethodSignature:[self methodSignatureForSelector:@selector(apiOperation: didCompleteWithResult:)]];
    [newOp setErrorCallbackMethodSignature:[self methodSignatureForSelector:@selector(apiOperation: didFailWithError:)]];
    [opQueue addOperation:newOp];
 
    return newOp;
    
}

-(KSAPIOperation*) deleteIconWithPhotosDBID:(NSUInteger)photosDBID{

    
     NSMutableDictionary* theParams = [[NSMutableDictionary alloc]init];
            [theParams setValue:[NSNumber numberWithInt:photosDBID] forKey:@"photosDBID"];
                        
    KSAPIOperation* newOp = [[KSAPIOperation alloc]initWithAPIKey:theAPIKey andSecretKey:theSecretKey andMethodName:@"deleteIcon" andParams:theParams];
    [newOp setDelegate:self];
    [newOp setUseSSL:useSSL];
            
    //we pass the method signature for the kumulosProxy callback on this thread
 
    [newOp setCallbackSelector:@selector( kumulosAPI: apiOperation: deleteIconDidCompleteWithResult:)];
    [newOp setSuccessCallbackMethodSignature:[self methodSignatureForSelector:@selector(apiOperation: didCompleteWithResult:)]];
    [newOp setErrorCallbackMethodSignature:[self methodSignatureForSelector:@selector(apiOperation: didFailWithError:)]];
    [opQueue addOperation:newOp];
 
    return newOp;
    
}

-(KSAPIOperation*) getPhotoWithPhotosDBID:(NSUInteger)photosDBID{

    
     NSMutableDictionary* theParams = [[NSMutableDictionary alloc]init];
            [theParams setValue:[NSNumber numberWithInt:photosDBID] forKey:@"photosDBID"];
                        
    KSAPIOperation* newOp = [[KSAPIOperation alloc]initWithAPIKey:theAPIKey andSecretKey:theSecretKey andMethodName:@"getPhoto" andParams:theParams];
    [newOp setDelegate:self];
    [newOp setUseSSL:useSSL];
            
    //we pass the method signature for the kumulosProxy callback on this thread
 
    [newOp setCallbackSelector:@selector( kumulosAPI: apiOperation: getPhotoDidCompleteWithResult:)];
    [newOp setSuccessCallbackMethodSignature:[self methodSignatureForSelector:@selector(apiOperation: didCompleteWithResult:)]];
    [newOp setErrorCallbackMethodSignature:[self methodSignatureForSelector:@selector(apiOperation: didFailWithError:)]];
    [opQueue addOperation:newOp];
 
    return newOp;
    
}

-(KSAPIOperation*) uploadPhotosWithPhotoValue:(NSData*)photoValue andTextValue:(NSString*)textValue andLargePhotoValue:(NSData*)largePhotoValue{

    
     NSMutableDictionary* theParams = [[NSMutableDictionary alloc]init];
            [theParams setValue:photoValue forKey:@"photoValue"];
                    [theParams setValue:textValue forKey:@"textValue"];
                    [theParams setValue:largePhotoValue forKey:@"largePhotoValue"];
                        
    KSAPIOperation* newOp = [[KSAPIOperation alloc]initWithAPIKey:theAPIKey andSecretKey:theSecretKey andMethodName:@"uploadPhotos" andParams:theParams];
    [newOp setDelegate:self];
    [newOp setUseSSL:useSSL];
            
    //we pass the method signature for the kumulosProxy callback on this thread
 
    [newOp setCallbackSelector:@selector( kumulosAPI: apiOperation: uploadPhotosDidCompleteWithResult:)];
    [newOp setSuccessCallbackMethodSignature:[self methodSignatureForSelector:@selector(apiOperation: didCompleteWithResult:)]];
    [newOp setErrorCallbackMethodSignature:[self methodSignatureForSelector:@selector(apiOperation: didFailWithError:)]];
    [opQueue addOperation:newOp];
 
    return newOp;
    
}

-(KSAPIOperation*) createUserAPIWithUserID:(NSString*)userID andUserName:(NSString*)userName andUserPassword:(NSString*)userPassword andPhotosDBID:(NSInteger)photosDBID andLatitude:(float)latitude andLongitude:(float)longitude andDeviceToken:(NSString*)deviceToken andBadgeNumber:(NSInteger)badgeNumber andLoginType:(NSInteger)loginType{

    
     NSMutableDictionary* theParams = [[NSMutableDictionary alloc]init];
            [theParams setValue:userID forKey:@"userID"];
                    [theParams setValue:userName forKey:@"userName"];
                    [theParams setValue:userPassword forKey:@"userPassword"];
                    [theParams setValue:[NSNumber numberWithInt:photosDBID] forKey:@"photosDBID"];
                    [theParams setValue:[NSNumber numberWithFloat:latitude] forKey:@"latitude"];
                    [theParams setValue:[NSNumber numberWithFloat:longitude] forKey:@"longitude"];
                    [theParams setValue:deviceToken forKey:@"deviceToken"];
                    [theParams setValue:[NSNumber numberWithInt:badgeNumber] forKey:@"badgeNumber"];
                    [theParams setValue:[NSNumber numberWithInt:loginType] forKey:@"loginType"];
                        
    KSAPIOperation* newOp = [[KSAPIOperation alloc]initWithAPIKey:theAPIKey andSecretKey:theSecretKey andMethodName:@"createUserAPI" andParams:theParams];
    [newOp setDelegate:self];
    [newOp setUseSSL:useSSL];
            
    //we pass the method signature for the kumulosProxy callback on this thread
 
    [newOp setCallbackSelector:@selector( kumulosAPI: apiOperation: createUserAPIDidCompleteWithResult:)];
    [newOp setSuccessCallbackMethodSignature:[self methodSignatureForSelector:@selector(apiOperation: didCompleteWithResult:)]];
    [newOp setErrorCallbackMethodSignature:[self methodSignatureForSelector:@selector(apiOperation: didFailWithError:)]];
    [opQueue addOperation:newOp];
 
    return newOp;
    
}

-(KSAPIOperation*) getFriendByNameWithUserName:(NSString*)userName{

    
     NSMutableDictionary* theParams = [[NSMutableDictionary alloc]init];
            [theParams setValue:userName forKey:@"userName"];
                        
    KSAPIOperation* newOp = [[KSAPIOperation alloc]initWithAPIKey:theAPIKey andSecretKey:theSecretKey andMethodName:@"getFriendByName" andParams:theParams];
    [newOp setDelegate:self];
    [newOp setUseSSL:useSSL];
            
    //we pass the method signature for the kumulosProxy callback on this thread
 
    [newOp setCallbackSelector:@selector( kumulosAPI: apiOperation: getFriendByNameDidCompleteWithResult:)];
    [newOp setSuccessCallbackMethodSignature:[self methodSignatureForSelector:@selector(apiOperation: didCompleteWithResult:)]];
    [newOp setErrorCallbackMethodSignature:[self methodSignatureForSelector:@selector(apiOperation: didFailWithError:)]];
    [opQueue addOperation:newOp];
 
    return newOp;
    
}

-(KSAPIOperation*) getUserDBWithUserID:(NSString*)userID andUserPassword:(NSString*)userPassword{

    
     NSMutableDictionary* theParams = [[NSMutableDictionary alloc]init];
            [theParams setValue:userID forKey:@"userID"];
                    [theParams setValue:userPassword forKey:@"userPassword"];
                        
    KSAPIOperation* newOp = [[KSAPIOperation alloc]initWithAPIKey:theAPIKey andSecretKey:theSecretKey andMethodName:@"getUserDB" andParams:theParams];
    [newOp setDelegate:self];
    [newOp setUseSSL:useSSL];
            
    //we pass the method signature for the kumulosProxy callback on this thread
 
    [newOp setCallbackSelector:@selector( kumulosAPI: apiOperation: getUserDBDidCompleteWithResult:)];
    [newOp setSuccessCallbackMethodSignature:[self methodSignatureForSelector:@selector(apiOperation: didCompleteWithResult:)]];
    [newOp setErrorCallbackMethodSignature:[self methodSignatureForSelector:@selector(apiOperation: didFailWithError:)]];
    [opQueue addOperation:newOp];
 
    return newOp;
    
}

-(KSAPIOperation*) getUserDBByFacebookIDWithUserID:(NSString*)userID{

    
     NSMutableDictionary* theParams = [[NSMutableDictionary alloc]init];
            [theParams setValue:userID forKey:@"userID"];
                        
    KSAPIOperation* newOp = [[KSAPIOperation alloc]initWithAPIKey:theAPIKey andSecretKey:theSecretKey andMethodName:@"getUserDBByFacebookID" andParams:theParams];
    [newOp setDelegate:self];
    [newOp setUseSSL:useSSL];
            
    //we pass the method signature for the kumulosProxy callback on this thread
 
    [newOp setCallbackSelector:@selector( kumulosAPI: apiOperation: getUserDBByFacebookIDDidCompleteWithResult:)];
    [newOp setSuccessCallbackMethodSignature:[self methodSignatureForSelector:@selector(apiOperation: didCompleteWithResult:)]];
    [newOp setErrorCallbackMethodSignature:[self methodSignatureForSelector:@selector(apiOperation: didFailWithError:)]];
    [opQueue addOperation:newOp];
 
    return newOp;
    
}

-(KSAPIOperation*) getUserInfoByDBIDWithUserDBID:(NSUInteger)userDBID{

    
     NSMutableDictionary* theParams = [[NSMutableDictionary alloc]init];
            [theParams setValue:[NSNumber numberWithInt:userDBID] forKey:@"userDBID"];
                        
    KSAPIOperation* newOp = [[KSAPIOperation alloc]initWithAPIKey:theAPIKey andSecretKey:theSecretKey andMethodName:@"getUserInfoByDBID" andParams:theParams];
    [newOp setDelegate:self];
    [newOp setUseSSL:useSSL];
            
    //we pass the method signature for the kumulosProxy callback on this thread
 
    [newOp setCallbackSelector:@selector( kumulosAPI: apiOperation: getUserInfoByDBIDDidCompleteWithResult:)];
    [newOp setSuccessCallbackMethodSignature:[self methodSignatureForSelector:@selector(apiOperation: didCompleteWithResult:)]];
    [newOp setErrorCallbackMethodSignature:[self methodSignatureForSelector:@selector(apiOperation: didFailWithError:)]];
    [opQueue addOperation:newOp];
 
    return newOp;
    
}

-(KSAPIOperation*) updateBadgeNumberWithUserDBID:(NSUInteger)userDBID andBadgeNumber:(NSInteger)badgeNumber{

    
     NSMutableDictionary* theParams = [[NSMutableDictionary alloc]init];
            [theParams setValue:[NSNumber numberWithInt:userDBID] forKey:@"userDBID"];
                    [theParams setValue:[NSNumber numberWithInt:badgeNumber] forKey:@"badgeNumber"];
                        
    KSAPIOperation* newOp = [[KSAPIOperation alloc]initWithAPIKey:theAPIKey andSecretKey:theSecretKey andMethodName:@"updateBadgeNumber" andParams:theParams];
    [newOp setDelegate:self];
    [newOp setUseSSL:useSSL];
            
    //we pass the method signature for the kumulosProxy callback on this thread
 
    [newOp setCallbackSelector:@selector( kumulosAPI: apiOperation: updateBadgeNumberDidCompleteWithResult:)];
    [newOp setSuccessCallbackMethodSignature:[self methodSignatureForSelector:@selector(apiOperation: didCompleteWithResult:)]];
    [newOp setErrorCallbackMethodSignature:[self methodSignatureForSelector:@selector(apiOperation: didFailWithError:)]];
    [opQueue addOperation:newOp];
 
    return newOp;
    
}

-(KSAPIOperation*) updateDeviceTokenWithDeviceToken:(NSString*)deviceToken andUserDBID:(NSUInteger)userDBID{

    
     NSMutableDictionary* theParams = [[NSMutableDictionary alloc]init];
            [theParams setValue:deviceToken forKey:@"deviceToken"];
                    [theParams setValue:[NSNumber numberWithInt:userDBID] forKey:@"userDBID"];
                        
    KSAPIOperation* newOp = [[KSAPIOperation alloc]initWithAPIKey:theAPIKey andSecretKey:theSecretKey andMethodName:@"updateDeviceToken" andParams:theParams];
    [newOp setDelegate:self];
    [newOp setUseSSL:useSSL];
            
    //we pass the method signature for the kumulosProxy callback on this thread
 
    [newOp setCallbackSelector:@selector( kumulosAPI: apiOperation: updateDeviceTokenDidCompleteWithResult:)];
    [newOp setSuccessCallbackMethodSignature:[self methodSignatureForSelector:@selector(apiOperation: didCompleteWithResult:)]];
    [newOp setErrorCallbackMethodSignature:[self methodSignatureForSelector:@selector(apiOperation: didFailWithError:)]];
    [opQueue addOperation:newOp];
 
    return newOp;
    
}

-(KSAPIOperation*) updateMyDetailsWithUserDBID:(NSUInteger)userDBID andUserName:(NSString*)userName andUserPassword:(NSString*)userPassword{

    
     NSMutableDictionary* theParams = [[NSMutableDictionary alloc]init];
            [theParams setValue:[NSNumber numberWithInt:userDBID] forKey:@"userDBID"];
                    [theParams setValue:userName forKey:@"userName"];
                    [theParams setValue:userPassword forKey:@"userPassword"];
                        
    KSAPIOperation* newOp = [[KSAPIOperation alloc]initWithAPIKey:theAPIKey andSecretKey:theSecretKey andMethodName:@"updateMyDetails" andParams:theParams];
    [newOp setDelegate:self];
    [newOp setUseSSL:useSSL];
            
    //we pass the method signature for the kumulosProxy callback on this thread
 
    [newOp setCallbackSelector:@selector( kumulosAPI: apiOperation: updateMyDetailsDidCompleteWithResult:)];
    [newOp setSuccessCallbackMethodSignature:[self methodSignatureForSelector:@selector(apiOperation: didCompleteWithResult:)]];
    [newOp setErrorCallbackMethodSignature:[self methodSignatureForSelector:@selector(apiOperation: didFailWithError:)]];
    [opQueue addOperation:newOp];
 
    return newOp;
    
}

-(KSAPIOperation*) updateUserIconWithPhotosDBID:(NSInteger)photosDBID andUserDBID:(NSUInteger)userDBID{

    
     NSMutableDictionary* theParams = [[NSMutableDictionary alloc]init];
            [theParams setValue:[NSNumber numberWithInt:photosDBID] forKey:@"photosDBID"];
                    [theParams setValue:[NSNumber numberWithInt:userDBID] forKey:@"userDBID"];
                        
    KSAPIOperation* newOp = [[KSAPIOperation alloc]initWithAPIKey:theAPIKey andSecretKey:theSecretKey andMethodName:@"updateUserIcon" andParams:theParams];
    [newOp setDelegate:self];
    [newOp setUseSSL:useSSL];
            
    //we pass the method signature for the kumulosProxy callback on this thread
 
    [newOp setCallbackSelector:@selector( kumulosAPI: apiOperation: updateUserIconDidCompleteWithResult:)];
    [newOp setSuccessCallbackMethodSignature:[self methodSignatureForSelector:@selector(apiOperation: didCompleteWithResult:)]];
    [newOp setErrorCallbackMethodSignature:[self methodSignatureForSelector:@selector(apiOperation: didFailWithError:)]];
    [opQueue addOperation:newOp];
 
    return newOp;
    
}

@end