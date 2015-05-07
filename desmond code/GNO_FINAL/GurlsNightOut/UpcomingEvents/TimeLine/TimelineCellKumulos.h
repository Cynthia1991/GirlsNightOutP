//
//  TimelineCellKumulos.h
//  gno
//
//  Created by Calvin on 7/08/12.
//
//

#import <Foundation/Foundation.h>
#import "Kumulos.h"
#import "AppDelegate.h"
@interface TimelineCellKumulos : NSObject <KumulosDelegate>
{
    AppDelegate *appDelegate;
}
@property (nonatomic,strong) NSString *eventPostID;
@property (nonatomic,strong) NSString *eventID;

- (id) initByEventPostID:(NSString *)eventPostID1 EventID:(NSString *)eventID1;
- (void) createLike;
- (void) createCommentWithComment:(NSString*) comment;

@end
