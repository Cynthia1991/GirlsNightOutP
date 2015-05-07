//
//  BumpKumulosHandler.h
//  gno
//
//  Created by Calvin on 10/09/12.
//
//

#import <Foundation/Foundation.h>
#import "Kumulos.h"
#import "AppDelegate.h"
@class TimelineScrollViewController;

@interface BumpKumulosHandler : NSObject<KumulosDelegate>
{
    

    NSMutableData *receivedData;
    AppDelegate *appDelegate;
    
}
@property (nonatomic) NSInteger eventID;
@property (nonatomic) NSString *friendToken;
@property (nonatomic, retain) TimelineScrollViewController *timelineScrollViewController;

@end
