//
//  AddTimelineTextViewController.h
//  GurlsNightOut
//
//  Created by calvin on 21/05/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Kumulos.h"
#import "EventMainPageViewController.h"
#import "AppDelegate.h"
#import "EventMainPageTableCell.h"
#import "EventMainPageHTableCell.h"
#import "EventMainPagePTableCell.h"

@interface AddTimelineTextViewController : UIViewController<KumulosDelegate>
{
    NSMutableData *receivedData;
    
    AppDelegate *appDelegate;
    NSMutableArray *friendsList;
}
@property (nonatomic,strong) NSString *postID;
@property (nonatomic, retain) NSString *eventID;
@property (nonatomic, retain) NSString *userID;
@property (nonatomic) NSInteger function;
@property (nonatomic, retain) EventMainPageViewController *eventMainPageViewController;
@property (nonatomic, retain) EventMainPageTableCell *eventMainPageTableCell;
@property (nonatomic, retain) EventMainPageHTableCell *eventMainPageHTableCell;
@property (nonatomic, retain) EventMainPagePTableCell *eventMainPagePTableCell;

@property (strong, nonatomic) IBOutlet UITextView *tvContent;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *btDone;

- (IBAction)DoneAction:(id)sender;
- (IBAction)CancelAction:(id)sender;
@end
