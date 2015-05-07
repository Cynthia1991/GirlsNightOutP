//
//  BumpKumulosHandler.m
//  gno
//
//  Created by Calvin on 10/09/12.
//
//

#import "BumpKumulosHandler.h"
#import "EventMainPageViewController.h"
#import "TimelineScrollViewController.h"

@implementation BumpKumulosHandler
@synthesize eventID,timelineScrollViewController,friendToken;

- (void) kumulosAPI:(Kumulos *)kumulos apiOperation:(KSAPIOperation *)operation createPostDidCompleteWithResult:(NSNumber *)newRecordID
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadFromAddFriends" object:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"hideEventListHUD" object:nil];
    
    //    [[NSNotificationCenter defaultCenter] postNotificationName:@"GetAllPost" object:nil];
    //    if ([[userInfo objectForKey:@"eventID"] intValue]==[[self eventID] intValue]) {
//    appDelegate.timelineManager=[[TimelineManager alloc] initByEventID:[NSString stringWithFormat:@"%d",self.eventID] function:0 loadingTimes:0];
    [appDelegate.timelineManager reloadPostByEventID:[NSString stringWithFormat:@"%d",self.eventID]];
    //    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadFromAppleNotification" object:nil];
}
- (void) kumulosAPI:(Kumulos *)kumulos apiOperation:(KSAPIOperation *)operation inviteFriendsDidCompleteWithResult:(NSNumber *)newRecordID
{
    
    NSString *content=[NSString stringWithFormat:@"Add a new event"];
    content=[content stringByReplacingOccurrencesOfString:@" " withString:@"!@"];
    NSString *urlStr=[NSString stringWithFormat:@"http://calvin.gotoip2.com/sentNotification.jsp?eventID=%d&content=%@&badge=1&function=1&productionFunction=0&deviceTokens=%@",[self eventID],content,friendToken];
    NSURL *url=[NSURL URLWithString:urlStr];
    
    // Create the request.
    NSURLRequest *theRequest=[NSURLRequest requestWithURL:url
                                              cachePolicy:NSURLRequestUseProtocolCachePolicy
                                          timeoutInterval:20.0];
    
    NSURLConnection *theConnection=[[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
    [theConnection start];
    
    if (theConnection) {
        receivedData = [NSMutableData data];
    } else {
        //        NSLog(@"Connection failed.");
    }
    
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadFromAddFriends" object:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"hideEventListHUD" object:nil];
    
    NSLog(@"invite friend successful");
}

#pragma mark - NSURLConnection delegate
-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
	[receivedData setLength: 0];
    //	NSLog(@"connection: didReceiveResponse:1");
}
-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
	[receivedData appendData:data];
    //	NSLog(@"connection: didReceiveData:2");
	
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    //	NSLog(@"ERROR with theConenction");
    
}
-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    //	NSLog(@"3 DONE. Received Bytes: %d", [receivedData length]);
    NSString *result = [[NSString alloc] initWithBytes: [receivedData mutableBytes] length:[receivedData length] encoding:NSUTF8StringEncoding];
    
    
    
    if (result!=nil) {
        NSLog(@"%@",result);
        if (timelineScrollViewController!=nil) {
            EventMainPageViewController *rootViewController = (EventMainPageViewController *)[timelineScrollViewController.timelineNavigationController topViewController];
            [rootViewController reloadTableViewDataSource];
        }
    }
    
}

@end
