//
//  BumpConnector.m
//  bumpTest
//
//  Created by Zac Fitz-Walter on 16/12/10.
//  Copyright 2010 Phd Student. All rights reserved.
//

#import "BumpConnector.h"
//#import "Keys.h"
#import "FriendsListViewController.h"
#import "TimelineScrollViewController.h"
#import "EventMainPageViewController.h"

@implementation BumpConnector
@synthesize friendsListViewController,timelineScrollViewController,eventListController,appDelegate,addEventsViewController;
@synthesize function,eventID;

- (id) init{
	if(self = [super init]){
        [self loadAppData];
        appDelegate=(AppDelegate*)[[UIApplication sharedApplication] delegate];
	}
	return self;
}
-(void) loadAppData{
    bumpObject = [BumpAPI sharedInstance];
}

-(void) configBump{
	[bumpObject configAPIKey:@"b6c78cf63d254345a3951e8897be3b09"]; //put your api key here. Get an api key from http://bu.mp
	[bumpObject configDelegate:self];
    if (function==0) {
        [bumpObject configParentView:friendsListViewController.view];
    }
    else if (function==1){
        [bumpObject configParentView:timelineScrollViewController.view];
    }
    else if (function==2){
        [bumpObject configParentView:eventListController.view];
    }
    else if (function==3)
    {
        [bumpObject configParentView:addEventsViewController.view];

    }
	[bumpObject configActionMessage:@"Bump with your friend to start."];
}

- (void) startBump{
	[self configBump];
	[bumpObject requestSession];
}

- (void) stopBump{
	[bumpObject endSession];
}

#pragma mark -
#pragma mark Private Methods

// for Debug -- prints contents of NSDictionary
-(void)printDict:(NSDictionary *)ddict {
	NSLog(@"---printing Dictionary---");
	NSArray *keys = [ddict allKeys];
	for (id key in keys) {
		NSLog(@"   key = %@     value = %@",key,[ddict objectForKey:key]);
	}	
}

#pragma mark -
#pragma mark Public Methods
- (void) sendDetails{
	//Create a dictionary describing the message to the other client.
	//We chose to send a dictionary for our communications for this example,
	//But you can use any type of data you like, as long as you convert it to an NSData object.
	
	//get the user profile
    [self loadAppData];
    [[appDelegate myDetailsManager] initShareDic];
    
	NSMutableDictionary *myDetails = [NSMutableDictionary dictionaryWithDictionary:[[appDelegate myDetailsManager] shareDic]];
	
	
	//level up
	
	//send it via bump
	NSMutableDictionary *userDict = [[NSMutableDictionary alloc] initWithCapacity:2];
	[userDict setObject:myDetails forKey:@"myDetails"];
	
    
	//Now we need to package our message dictionary up into an NSData object so we can send it up to Bump.
	//We'll do that with with an NSKeyedArchiver.
	NSData *userChunk = [NSKeyedArchiver archivedDataWithRootObject:userDict];
	
	//[self printDict:moveDict];
	
	//Calling send will have bump send the data up to the other user's mailbox.
	//The other user will get a bumpDataReceived: callback with an identical NSData* chunk shortly.
//	packetsAttempted++;
	[bumpObject sendData:userChunk];
}

#pragma mark Utility
-(void) quickAlert:(NSString *)titleText msgText:(NSString *)msgText{
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:titleText message:msgText delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
	[alert show];
}

#pragma mark -
#pragma mark BumpAPIDelegate methods

- (void) bumpDataReceived:(NSData *)chunk{
	//The chunk was packaged by the other user using an NSKeyedArchiver, so we unpackage it here with our NSKeyedUnArchiver
	NSDictionary *responseDictionary = [NSKeyedUnarchiver unarchiveObjectWithData:chunk];
	//[self printDict:responseDictionary];
	
	//responseDictionary no contains an Identical dictionary to the one that the other user sent us
	NSDictionary *friend = [responseDictionary objectForKey:@"myDetails"];
    friendDic=[[NSMutableDictionary alloc] initWithDictionary:friend];
    
	friendToken=[friend objectForKey:@"deviceToken"];
	//NSLog(@"user name and email are %@, %@", userName, email);
	
	//add it to the friend manager
	if ([[appDelegate friendsManager] addFriends:friend]){
		NSMutableString *alertText = [NSMutableString stringWithString:[friend objectForKey:@"userName"]];
		[alertText appendString:@" was added successfully to your contacts."];
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"New Contact Added" message:alertText delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[alert show];        
	} else {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Contact Already Exists" message:@"Contact already exists or couldn't be added at this time." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[alert show];
    }
	
	timelineScrollViewController.bumpKumulosHandler.friendToken=[NSString stringWithFormat:@"%@",friendToken];

	
	//refresh the table
    if (function==0) {
        [friendsListViewController viewWillAppear:NO];
    }
    else if(function==1) {

        Kumulos *k=[[Kumulos alloc] init];
        [k setDelegate:timelineScrollViewController.bumpKumulosHandler];
        NSLog(@"upload to server");
        
        [k createPostWithTextValue:[NSString stringWithFormat:@"%@ is invited to this event",[friend objectForKey:@"userName"]] andFunction:1 andDrinksDetail:nil andPhotoDetail:nil andUserID:[[friend objectForKey:@"userDBID"] intValue] andEventID:self.eventID];
        [k inviteFriendsWithRole:[NSString stringWithFormat:@"Member"] andIsConfirm:1 andIsHome:0 andEventID:[self eventID] andUserID:[[friendDic objectForKey:@"userDBID"] intValue]];

//        [appDelegate sendNotificationWithFriendsList:friendsArray Content:@"Invitation,join event have more fun." UserID:[[[appDelegate myDetailsManager] userInfoDic] objectForKey:@"userDBID"] EventID:[[[theResults objectAtIndex:0] objectForKey:@"eventID"] objectForKey:@"eventDBID"] function:1];
        

        //update tableview
        [[appDelegate eventsManager] updateFriendsListByEventDBID:[NSString stringWithFormat:@"%d",[self eventID]] function:0];

    }
    else if(function==2) {
        [self.eventListController reloadAllevents:nil];
    }
    else if (function==3)
    {

        NSLog(@"upload to server");
        Kumulos *k=[[Kumulos alloc] init];
        [k setDelegate:timelineScrollViewController.bumpKumulosHandler];

        [k createPostWithTextValue:[NSString stringWithFormat:@"%@ is invited to this event",[friend objectForKey:@"userName"]] andFunction:1 andDrinksDetail:nil andPhotoDetail:nil andUserID:[[friend objectForKey:@"userDBID"] intValue] andEventID:self.eventID];
        [k inviteFriendsWithRole:[NSString stringWithFormat:@"Member"] andIsConfirm:1 andIsHome:0 andEventID:[self eventID] andUserID:[[friendDic objectForKey:@"userDBID"] intValue]];


        //update tableview
        [[appDelegate eventsManager] updateFriendsListByEventDBID:[NSString stringWithFormat:@"%d",[self eventID]] function:0];
        ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    }
//    [[[[appDelegate eventsManager] getEventDictionaryByEventID:[NSString stringWithFormat:@"%d",[self eventID]]] objectForKey:@"eventFriends"] addObject:friend];
    
    //stop bump
    [self stopBump];
    

}

- (void) bumpSessionStartedWith:(Bumper*)otherBumper{
	[self sendDetails];
}

- (void) bumpSessionEnded:(BumpSessionEndReason)reason {
	NSString *alertText;
	switch (reason) {
		case END_LOST_NET:
			alertText = @"Connection to Bump server was lost.";
			break;
		case END_OTHER_USER_LOST:
			alertText = @"Connection to other user was lost.";
			break;
		case END_USER_QUIT:
			alertText = @"You have been disconnected.";
			break;
		default:
			alertText = @"You have been disconnected.";
			break;
	}
	
	if(reason != END_USER_QUIT){ 
		//if the local user initiated the quit,restarting the app is already being handled
		//other wise we'll restart here
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Disconnected" message:alertText delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[alert show];
	}
}

- (void) bumpSessionFailedToStart:(BumpSessionStartFailedReason)reason {
	
	NSString *alertText;
	switch (reason) {
		case FAIL_NETWORK_UNAVAILABLE:
			alertText = @"Please check your network settings and try again.";
			break;
		case FAIL_INVALID_AUTHORIZATION:
			//the user should never see this, since we'll pass in the correct API auth strings.
			//just for debug.
			alertText = @"Failed to connect to the Bump service. Auth error.";
			break;
		default:
			alertText = @"Failed to connect to the Bump service.";
			break;
	}
	
	if(reason != FAIL_USER_CANCELED){
		//if the user canceled they know it and they don't need a popup.
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Connection Failed" message:alertText delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[alert show];
	}
}
@end