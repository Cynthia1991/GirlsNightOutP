//
//  AppDelegate.m
//  GurlsNightOut
//
//  Created by calvin on 3/04/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//Cynthia test!
//
#import <QuartzCore/QuartzCore.h>
#import "AppDelegate.h"
#import "TimelineScrollViewController.h"
#import "InternetChecker.h"

@implementation AppDelegate

@synthesize window = _window;
@synthesize navController = _navController;
@synthesize menuViewController = _menuViewController;
@synthesize myDetailsManager,friendsManager,eventsManager;
@synthesize timelineManager,eventID,photoManager;
@synthesize addDrinkManager;
@synthesize facebook;
@synthesize addFriendDBID,addFriendName,isConnectInternet,emergencyManager,instructionManager;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
   
	[[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];

    [application setStatusBarStyle:UIStatusBarStyleBlackOpaque];
    
    ////////////////////////////////////////////////////////////////////////////////////init all manager
    self.myDetailsManager=[[MyDetailsManager alloc] init];
    self.friendsManager=[[FriendsManager alloc] init];
    self.eventsManager=[[EventsManager alloc] init];
    self.photoManager=[[PhotoManager alloc] init];
    self.addDrinkManager=[[AddDrinkManager alloc] init];
    self.timelineManager=[[TimelineManager alloc] init];
    self.emergencyManager=[[EmergencyManager alloc] init];
    self.instructionManager=[[InstructionManager alloc] init];

    
    
    [self.myDetailsManager updateDeviceToken];
    ////////////////////////////////////////////////////////////////////////////////////init facebook and testflight

    facebook = [[Facebook alloc] initWithAppId:@"389760794407039" andDelegate:self];

    [TestFlight takeOff:@"a20fb1a220c0ea30f5ecfdea3197b7a5_MjMyNDIyMDExLTA5LTIzIDAzOjMzOjI4LjA2MjY1NA"];
    

    /////////////////////////////////////////////////////////////////////////////////////////////////////////
    [[NSNotificationCenter defaultCenter]  addObserver:self selector:@selector(saveUserDetails:) name:@"save user detail to app" object:nil];
    [[NSNotificationCenter defaultCenter]  addObserver:self selector:@selector(openTimelineByNotificationWithUserInfoNotificationCenter:) name:@"openTimelineByNotificationWithUserInfoNotificationCenter" object:nil];
    [[NSNotificationCenter defaultCenter]  addObserver:self selector:@selector(deleteIcon:) name:@"delete icon" object:nil];
    [[NSNotificationCenter defaultCenter]  addObserver:self selector:@selector(addIcon:) name:@"add icon" object:nil];


    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
//    [UIApplication sharedApplication].applicationIconBadgeNumber=0;
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [UIApplication sharedApplication].applicationIconBadgeNumber=0;
    isConnectInternet=[[InternetChecker alloc] internetCheck];
    NSLog(@"isConnectInternet: %d",isConnectInternet);
    if (!isConnectInternet) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Network condition" message:@"No network at the moment, some functions are dependent on the internet. Please check your network condition." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


#pragma mark - init myDetailManager
- (void)initMyDetailsManager
{
    self.myDetailsManager=[[MyDetailsManager alloc] init];
}

#pragma mark - init FriendsManager
- (void)initFriendsManager
{
    self.friendsManager=[[FriendsManager alloc] init];
}
#pragma mark - Notification
- (void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken
{
	NSLog(@"My token is: %@", deviceToken);
    NSString *token=[NSString stringWithFormat:@"%@",deviceToken];
    token=[token stringByReplacingOccurrencesOfString:@" " withString:@""];
    token=[token substringFromIndex:1];
    token=[token substringToIndex:[token length]-1];
    NSLog(@"%@",token);
    NSString *deviceTokenPath=[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"deviceTokenPath"];
    if ([token writeToFile:deviceTokenPath atomically:YES encoding:NSASCIIStringEncoding error:nil]) {
        NSLog(@"save device successful");
    }
}

- (void)application:(UIApplication*)application didFailToRegisterForRemoteNotificationsWithError:(NSError*)error
{
	NSLog(@"Failed to get token, error: %@", error);
}
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    NSLog(@"%@",userInfo);
    
    ////////////////////////////////////////////////////////////////////////////////////init the notification sound
    NSURL *url = [NSURL fileURLWithPath:[[NSBundle mainBundle]
                                         pathForResource:@"notificationSound"
                                         ofType:@"mp3"]];
    NSError *error;
    audioPlayer = [[AVAudioPlayer alloc]
                   initWithContentsOfURL:url
                   error:&error];
    if (error)
    {
        NSLog(@"Error in audioPlayer: %@",
              [error localizedDescription]);
    } else {
        [audioPlayer prepareToPlay];
    }
    /////////////////////////////////////////////////////////////////////////////////////////////////////////
//    NSDateFormatter *dateTimeFormat = [[NSDateFormatter alloc] init];
//    [dateTimeFormat setDateFormat:@"yyyyMMddHHmmss"]; //24 hrs
//    NSDate *date=[dateTimeFormat dateFromString:[userInfo objectForKey:@"timeCreated"]];
//    NSLog(@"%@",date);
//    
//    NSMutableDictionary *photoDic=[[NSMutableDictionary alloc] init];
//    NSData *photoData=[[NSData alloc] init];
//    if (![[userInfo objectForKey:@"photoDic"] isEqualToString:@"(null)"]) {
//        photoDic=[[userInfo objectForKey:@"photoDic"] JSONValue];
//        photoData = [NSKeyedArchiver archivedDataWithRootObject:photoDic];
//    }
//    
//    NSMutableDictionary *drinkDic=[[NSMutableDictionary alloc] init];
//    NSData *drinkData=[[NSData alloc] init];
//    if (![[userInfo objectForKey:@"drinkDic"] isEqualToString:@"(null)"]) {
//        drinkDic=[[userInfo objectForKey:@"drinkDic"] JSONValue];
//        drinkData = [NSKeyedArchiver archivedDataWithRootObject:drinkDic];
//    }
//    
//    
//    NSMutableDictionary *eventIDDic=[[NSMutableDictionary alloc] initWithDictionary:[self.eventsManager getEventDictionaryByEventID:[userInfo objectForKey:@"eventID"]]];
//    NSMutableDictionary *eventDetailDic=[[NSMutableDictionary alloc] initWithDictionary:[[[[self.eventsManager getEventDictionaryByEventID:[userInfo objectForKey:@"eventID"]] objectForKey:@"eventFriends"] objectAtIndex:0] objectForKey:@"eventID"]];
//    
//    NSMutableDictionary *userIDDic;
//    for (int i=0; i<[[eventIDDic objectForKey:@"eventFriends"] count]; i++) {
//        if ([[[[[eventIDDic objectForKey:@"eventFriends"] objectAtIndex:i] objectForKey:@"userID"] objectForKey:@"userDBID"] intValue]==[[userInfo objectForKey:@"userID"] intValue]) {
//            userIDDic=[[NSMutableDictionary alloc] initWithDictionary:[[[eventIDDic objectForKey:@"eventFriends"] objectAtIndex:i] objectForKey:@"userID"]];
//        }
//    }
//    
//    NSMutableDictionary *recieveTimeline=[[NSMutableDictionary alloc] init];
//    [recieveTimeline setObject:[NSString stringWithFormat:@"%@",[userInfo objectForKey:@"eventPostDBID"]] forKey:@"eventPostDBID"];
//    [recieveTimeline setObject:[[NSNumber alloc] initWithInt:[[userInfo objectForKey:@"postFunction"] intValue]] forKey:@"function"];
//    [recieveTimeline setObject:[NSString stringWithFormat:@"%@",[userInfo objectForKey:@"textValue"]] forKey:@"textValue"];
//    [recieveTimeline setObject:date forKey:@"timeCreated"];
//    [recieveTimeline setObject:date forKey:@"timeUpdated"];
//    [recieveTimeline setObject:photoData forKey:@"photoDetail"];
//    [recieveTimeline setObject:drinkData forKey:@"drinksDetail"];
//    [recieveTimeline setObject:userIDDic forKey:@"userID"];
//    [recieveTimeline setObject:eventDetailDic forKey:@"eventID"];

    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    MTStatusBarOverlay *overlay = [MTStatusBarOverlay sharedInstance];
    overlay.animation = MTStatusBarOverlayAnimationFallDown;  // MTStatusBarOverlayAnimationShrink
    overlay.detailViewMode = MTDetailViewModeHistory;         // enable automatic history-tracking and show in detail-view
    overlay.delegate = self;
    overlay.progress = 0.0;
    NSString *content=[NSString stringWithFormat:@"%@",[[userInfo objectForKey:@"aps"] objectForKey:@"alert"]];
    NSArray *contentArr=[content componentsSeparatedByString:@":"];


    
    if ([[userInfo objectForKey:@"function"] intValue]==0) {//update timeline
        [overlay postImmediateFinishMessage:[NSString stringWithFormat:@"%@ send a messege!",[contentArr objectAtIndex:0]] duration:6.0 animated:YES];
        overlay.progress = 1.0;
        
        [audioPlayer play];    
        NSLog(@"notificationID:%d,timelineManager:%d",[[userInfo objectForKey:@"eventID"] intValue],[[self eventID] intValue]);
        
        ///////////////////////////////////////////////////////////////////whether include the timeline controller
        UINavigationController *navController=(UINavigationController *)self.window.rootViewController;
        NSArray *viewContrlls=navController.viewControllers;
        
        Boolean isOpenTimeline=NO;
        
        for( int i=0;i<[viewContrlls count];i++){
            id obj=[viewContrlls objectAtIndex:i];
            if([obj isKindOfClass:NSClassFromString(@"TimelineScrollViewController")])
            {
                isOpenTimeline=YES;
            }
        }
        ///////////////////////////////////////////////////////////////////
        if ([[userInfo objectForKey:@"eventID"] intValue]==[[self eventID] intValue]) {
            if (!isOpenTimeline) {
                [self openTimelineByNotificationWithUserInfo:userInfo];
            }
            if (![[contentArr objectAtIndex:0] isEqualToString:[self.myDetailsManager.userInfoDic objectForKey:@"userName"]]) {
                [self.timelineManager reloadPostByEventID:[self eventID]];
            }

        }
        else
        {
            [self openTimelineByNotificationWithUserInfo:userInfo];
        }
        ///////////////////////////////////////////////////////////////////

        


        [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadFromAppleNotification" object:nil];
    }
    else if ([[userInfo objectForKey:@"function"] intValue]==1) {//update event list
        [overlay postImmediateFinishMessage:[NSString stringWithFormat:@"%@ invite you to an event!",[contentArr objectAtIndex:0]] duration:6.0 animated:YES];
        overlay.progress = 1.0;
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadFromAddFriends" object:nil];
    }
    else if ([[userInfo objectForKey:@"function"] intValue]==2)//add friends in search bar
    {
        addFriendDBID=[userInfo objectForKey:@"userID"];
        addFriendName=[userInfo objectForKey:@"textValue"];
        
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:[NSString stringWithFormat:@"%@ add you as new friend. /nAre you sure want to add %@ as your friend?",addFriendName,addFriendName] delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"Add" otherButtonTitles:nil];
        [actionSheet setTag:0];
        [actionSheet showInView:self.window];
    }



}
- (void) openTimelineByNotificationWithUserInfoNotificationCenter:(NSNotification*)notification
{
    
}
- (void) openTimelineByNotificationWithUserInfo:(NSDictionary*)userInfo
{
    TimelineScrollViewController *timelineScrollViewController=[self.window.rootViewController.storyboard instantiateViewControllerWithIdentifier:@"TimelineScrollViewController"];
    timelineScrollViewController.eventID=[NSString stringWithFormat:@"%d",[[userInfo objectForKey:@"eventID"] intValue]];
    //
    NSMutableDictionary *eventDic=[self.eventsManager getEventDictionaryByEventID:[userInfo objectForKey:@"eventID"]];
    
    timelineScrollViewController.friendsList=[[NSMutableArray alloc] initWithArray:[eventDic objectForKey:@"eventFriends"]];
    
    ///////////////////////////////////////////////////////////////////current event or past
    NSDate *eventDate=[eventDic objectForKey:@"eventTime"];
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDateComponents *components = [cal components:( NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit ) fromDate:[[NSDate alloc] init]];
    NSDate *today = [cal dateByAddingComponents:components toDate:[[NSDate alloc] init] options:0]; //This variable should now be pointing at a date object that is the start of today (midnight);
    [components setHour:-24];
    [components setMinute:0];
    [components setSecond:0];
    NSDate *yesterday = [cal dateByAddingComponents:components toDate: today options:0];
    
    if ([eventDate compare:yesterday]==1) {
        timelineScrollViewController.isActivity=0;//current
    }
    else
    {
        timelineScrollViewController.isActivity=1;//past
    }
    [self.window.rootViewController presentModalViewController:timelineScrollViewController animated:YES];
    ///////////////////////////////////////////////////////////////////
}
#pragma mark - add friend action sheet delegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (actionSheet.tag==0) {
        if (buttonIndex==0) {
            Kumulos *k=[[Kumulos alloc] init];
            [k setDelegate:self];
            [k createFriendsWithFriendsName:addFriendName andUserDBID:[[self.myDetailsManager.userInfoDic objectForKey:@"userDBID"] intValue] andFriendsUserDBID:[addFriendDBID intValue]];
        }
    }
}
#pragma mark - kumulos delegate
- (void)kumulosAPI:(Kumulos *)kumulos apiOperation:(KSAPIOperation *)operation createFriendsDidCompleteWithResult:(NSNumber *)newRecordID
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"reload Friends List Data" object:nil];
}

#pragma mark - facebook delegate
- (void)facebookLogout {
    [facebook logout];
}
- (void) fbDidLogout {
    // Remove saved authorization information if it exists
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults objectForKey:@"FBAccessTokenKey"]) {
        [defaults removeObjectForKey:@"FBAccessTokenKey"];
        [defaults removeObjectForKey:@"FBExpirationDateKey"];
        [defaults synchronize];
    }
}

- (void)facebookLogin
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults objectForKey:@"FBAccessTokenKey"] && [defaults objectForKey:@"FBExpirationDateKey"]) {
        facebook.accessToken = [defaults objectForKey:@"FBAccessTokenKey"];
        facebook.expirationDate = [defaults objectForKey:@"FBExpirationDateKey"];
    }
    if (![facebook isSessionValid])
    {
        //[facebook authorize:nil];
        NSArray *permissions = [[NSArray alloc] initWithObjects:
                                @"user_photos",
                                nil];
        [facebook authorize:permissions];
    }
}
// For iOS 4.2+ support
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    return [facebook handleOpenURL:url]; 
}

- (void)fbDidLogin
{
   
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[facebook accessToken] forKey:@"FBAccessTokenKey"];
    [defaults setObject:[facebook expirationDate] forKey:@"FBExpirationDateKey"];
    [defaults synchronize];
    
    self.me = [facebook requestWithGraphPath:@"me" andDelegate:self];
    self.photoAlbums =  [facebook requestWithGraphPath:@"me/albums" andDelegate:self];
       
}

-(void)getProfilePics:(NSString *)PicsID
{
    NSLog(@"picsID %@",PicsID);
    self.getProfilePics =  [facebook requestWithGraphPath:PicsID andDelegate:self];

}

-(void)CallToFindProfilePics:(NSString *)PicsID
{
    NSLog(@"picsID %@",PicsID);
    self.profilePics =  [facebook requestWithGraphPath:PicsID andDelegate:self];

}

- (void)request:(FBRequest *)request didLoad:(id)result
{
    
    if (request == self.me) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"loginToServer" object:result];

    }
    else if (request == self.photoAlbums)
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"loginToServerGetphotos" object:result];
        
    }
    else if (request == self.profilePics)
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"loginToServergetProfile" object:result];
        
    }
    
    else if (request == self.getProfilePics)
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"getProfile" object:result];
        
    }
    
    
    }

- (void)fbDidNotLogin:(BOOL)cancelled
{
}
- (void)fbSessionInvalidated
{
}

-(void) fbDidExtendToken:(NSString *)accessToken expiresAt:(NSDate *)expiresAt
{
    
}

#pragma mark - helper for sending notification to others

-(void) sendNotificationForTimelineWithFriendsList:(NSMutableArray*)friendsList Content:(NSString*) content1 UserID:(NSString *)userID1 EventID:(NSString*)eventID1 function:(NSInteger) function1 PostFunction:(NSInteger)postFunction eventPostDBID:(NSInteger) eventPostDBID timeCreated:(NSString*)timeCreated photoDBID:(NSMutableDictionary*)photoDic drinkID:(NSMutableDictionary*)drinkDic
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"addPost" object:nil];

    ///////////////////////
    NSString *deviceTokens=[NSString stringWithFormat:@""];
    for (int i=0; i<[friendsList count]; i++) {
        if ([[[[friendsList objectAtIndex:i] objectForKey:@"userID"] objectForKey:@"deviceToken"] length]!=0) {
            if ([[[[friendsList objectAtIndex:i] objectForKey:@"userID"] objectForKey:@"userDBID"] intValue]!=[[self.myDetailsManager.userInfoDic objectForKey:@"userDBID"] intValue]) {
                deviceTokens=[deviceTokens stringByAppendingFormat:@"%@!@",[[[friendsList objectAtIndex:i] objectForKey:@"userID"] objectForKey:@"deviceToken"]];
            }
        }
    }
    NSLog(@"%@",deviceTokens);
    if ([deviceTokens length]!=0) {
        deviceTokens=[deviceTokens substringToIndex:[deviceTokens length]-2];
        
        NSString *content=[NSString stringWithFormat:@"%@:",[[[self myDetailsManager] userInfoDic] objectForKey:@"userName"]];
        content=[content stringByAppendingFormat:@"%@",content1];
        content=[content stringByReplacingOccurrencesOfString:@" " withString:@"!@"];
        NSString *photoDicStr=[photoDic JSONRepresentation];
        NSString *drinkDicStr=[drinkDic JSONRepresentation];
        NSString *urlStr=[NSString stringWithFormat:@"http://calvin.gotoip2.com/sentNotification.jsp?eventID=%@&content=%@&badge=1&function=%d&productionFunction=0&deviceTokens=%@&userID=%@&postFunction=%d&eventPostDBID=%d&timeCreated=%@&photoDic=%@&drinkDic=%@&textValue=%@",eventID1,content,function1,deviceTokens,userID1,postFunction,eventPostDBID,timeCreated,photoDicStr,drinkDicStr,content1];
        
        
        NSURL *url=[NSURL URLWithString:urlStr];
        
        // Create the request.
        NSURLRequest *theRequest=[NSURLRequest requestWithURL:url
                                                  cachePolicy:NSURLRequestUseProtocolCachePolicy
                                              timeoutInterval:20.0];
        
        // create the connection with the request
        // and start loading the data
        NSURLConnection *theConnection=[[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
        [theConnection start];
        
        if (theConnection) {
            receivedData = [NSMutableData data];
        } else {
            NSLog(@"Connection failed.");
        }
    }

}
-(void) sendNotificationWithFriendsList:(NSMutableArray*)friendsList Content:(NSString*) content1 UserID:(NSString *)userID1 EventID:(NSString*)eventID1 function:(NSInteger) function1//0=add post, 1=add event
{
    ///////////////////////
    NSString *deviceTokens=[NSString stringWithFormat:@""];
    for (int i=0; i<[friendsList count]; i++) {
        if ([[[[friendsList objectAtIndex:i] objectForKey:@"userID"] objectForKey:@"deviceToken"] length]!=0) {
            if ([[[[friendsList objectAtIndex:i] objectForKey:@"userID"] objectForKey:@"userDBID"] intValue]!=[userID1 intValue]) {
                deviceTokens=[deviceTokens stringByAppendingFormat:@"%@!@",[[[friendsList objectAtIndex:i] objectForKey:@"userID"] objectForKey:@"deviceToken"]];
            }
        }
    }
    NSLog(@"%@",deviceTokens);
    if ([deviceTokens length]!=0) {
        deviceTokens=[deviceTokens substringToIndex:[deviceTokens length]-2];
        
        NSString *content=[NSString stringWithFormat:@"%@:",[[[self myDetailsManager] userInfoDic] objectForKey:@"userName"]];
        content=[content stringByAppendingFormat:@"%@",content1];
        content=[content stringByReplacingOccurrencesOfString:@" " withString:@"!@"];
        
        NSString *myUserName=[NSString stringWithFormat:@"%@",[self.myDetailsManager.userInfoDic objectForKey:@"userName"]];
        myUserName=[myUserName stringByReplacingOccurrencesOfString:@" " withString:@"!@"];

        NSString *urlStr=[NSString stringWithFormat:@"http://calvin.gotoip2.com/sentNotification.jsp?eventID=%@&content=%@&badge=1&function=%d&productionFunction=0&deviceTokens=%@&userID=%@&textValue=%@",eventID1,content,function1,deviceTokens,myUserName,myUserName];
        NSURL *url=[NSURL URLWithString:urlStr];
        
        // Create the request.
        NSURLRequest *theRequest=[NSURLRequest requestWithURL:url
                                                  cachePolicy:NSURLRequestUseProtocolCachePolicy
                                              timeoutInterval:20.0];
        
        // create the connection with the request
        // and start loading the data
        NSURLConnection *theConnection=[[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
        [theConnection start];
        
        if (theConnection) {
            receivedData = [NSMutableData data];
        } else {
            NSLog(@"Connection failed.");
        }
    }

}
#pragma mark - NSURLConnection delegate
-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
	[receivedData setLength: 0];
//    NSLog(@"connection: didReceiveResponse:1");
}
-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
	[receivedData appendData:data];
//    NSLog(@"connection: didReceiveData:2");
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog(@"ERROR with %@",error);
}
-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSString *result = [[NSString alloc] initWithBytes: [receivedData mutableBytes] length:[receivedData length] encoding:NSUTF8StringEncoding];
    if (result!=nil) {
        NSLog(@"%@",result);
    }
}

#pragma mark - push loading indicator
- (void) sendStatusBarNotificationWithContent:(NSString *)content
{
    MTStatusBarOverlay *overlay = [MTStatusBarOverlay sharedInstance];
    overlay.animation = MTStatusBarOverlayAnimationFallDown;  // MTStatusBarOverlayAnimationShrink
    overlay.detailViewMode = MTDetailViewModeHistory;         // enable automatic history-tracking and show in detail-view
    overlay.delegate = self;
    overlay.progress = 0.0;
    [overlay postImmediateFinishMessage:content duration:6.0 animated:YES];
    overlay.progress = 1.0;
}

- (void)saveUserDetails:(NSNotification*) notification
{
    NSMutableArray *theResults=[notification object];
    
    //save the user info in local
    NSString *userInfoDicPath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"userInfoDicPath"];
    NSMutableDictionary *dic=[[NSMutableDictionary alloc] init];
    [dic setObject:[[theResults objectAtIndex:0] objectForKey:@"userID"] forKey:@"userID"];
    [dic setObject:[[theResults objectAtIndex:0] objectForKey:@"userDBID"] forKey:@"userDBID"];
    [dic setObject:[[theResults objectAtIndex:0] objectForKey:@"userName"] forKey:@"userName"];
    [dic setObject:[[theResults objectAtIndex:0] objectForKey:@"photosDBID"] forKey:@"photosDBID"];
    [dic setObject:[[theResults objectAtIndex:0] objectForKey:@"deviceToken"] forKey:@"deviceToken"];
    [dic setObject:[[theResults objectAtIndex:0] objectForKey:@"latitude"] forKey:@"latitude"];
    [dic setObject:[[theResults objectAtIndex:0] objectForKey:@"longitude"] forKey:@"longitude"];
    [dic setObject:[[theResults objectAtIndex:0] objectForKey:@"userPassword"] forKey:@"userPassword"];
    [dic setObject:[[theResults objectAtIndex:0] objectForKey:@"timeCreated"] forKey:@"timeCreated"];
    [dic setObject:[[theResults objectAtIndex:0] objectForKey:@"timeUpdated"] forKey:@"timeUpdated"];
    [dic setObject:[[theResults objectAtIndex:0] objectForKey:@"loginType"] forKey:@"loginType"];
    [dic writeToFile:userInfoDicPath atomically:YES];
    
    if ([[[theResults objectAtIndex:0] objectForKey:@"photosDBID"] intValue]!=0) {
        if ([self.photoManager getPhotoByPhotoDBID:[[theResults objectAtIndex:0] objectForKey:@"photosDBID"]]==nil) {
            [self loadPhotoFromServer:[[[theResults objectAtIndex:0] objectForKey:@"photosDBID"] intValue]];
        }
    }
    
    [self initMyDetailsManager];
    [self.myDetailsManager updateDeviceToken];//update device token
    [self.friendsManager getAllFriendsByFunction:0];//get friends
}
-(void) deleteIcon:(NSNotification*)notification
{
    NSString *photoDBID=[notification object];
    [photoManager deletePhotoWithPhotoDBID:photoDBID];
}

-(void) addIcon:(NSNotification*)notification
{
    NSMutableDictionary *dic=[notification object];
    [photoManager addPhoto:[dic objectForKey:@"imageData"] text:@"1" PhotoDBID:[dic objectForKey:@"photoDBID"]];
}
#pragma mark - load photo from server
- (void) loadPhotoFromServer:(int) photoDBID
{
    Kumulos *k=[[Kumulos alloc] init];
    [k setDelegate:self];
    [k getPhotoWithPhotosDBID:photoDBID];
}
- (void) kumulosAPI:(Kumulos *)kumulos apiOperation:(KSAPIOperation *)operation getPhotoDidCompleteWithResult:(NSArray *)theResults
{
    [[self photoManager] addPhoto:[[theResults objectAtIndex:0] objectForKey:@"photoValue"] text:[[theResults objectAtIndex:0] objectForKey:@"textValue"] PhotoDBID:[[theResults objectAtIndex:0] objectForKey:@"photosDBID"]];
}

#pragma mark - internet checker
-(BOOL) internetChecker
{
    return [[InternetChecker alloc] internetCheck];
}
@end
