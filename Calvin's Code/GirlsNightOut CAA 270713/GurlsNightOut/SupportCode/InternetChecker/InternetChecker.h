//
//  InternetChecker.h
//  QUT Mobile
//
//  Created by calvin on 9/12/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Reachability.h"
#import "AppDelegate.h"

@interface InternetChecker : NSObject
{
    NSMutableData *receivedData;
    NSInteger connectionFunction;
    NSInteger updateArrayNumber;
    AppDelegate *appDelegate;
}
-(BOOL) internetCheck;
//-(void) updateInNetwork;
//-(void) updateForEach:(NSMutableArray *) arrayCompleted SaveResult:(NSString *) completedUpdateResultPath;

@end
