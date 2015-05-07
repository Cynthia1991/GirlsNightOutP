//
//  AddTimelineTextViewController.m
//  GurlsNightOut
//
//  Created by calvin on 21/05/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AddTimelineTextViewController.h"

@interface AddTimelineTextViewController ()

@end

@implementation AddTimelineTextViewController
@synthesize tvContent;
@synthesize btDone;
@synthesize eventID,userID,eventMainPageViewController,postID,function,eventMainPageTableCell,eventMainPageHTableCell,eventMainPagePTableCell;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void)viewWillAppear:(BOOL)animated
{
    [tvContent becomeFirstResponder];
    [self.navigationController setNavigationBarHidden:NO];
    [self.navigationController.navigationBar setTintColor:[UIColor colorWithRed:64/255.0 green:0/255.0 blue:128/255.0 alpha:1]];

}
- (void)viewDidLoad
{
    [super viewDidLoad];
    appDelegate=(AppDelegate*)[[UIApplication sharedApplication] delegate];
    
    friendsList=[[[appDelegate eventsManager] getEventDictionaryByEventID:eventID] objectForKey:@"eventFriends"];
}

- (void)viewDidUnload
{
    [self setTvContent:nil];
    [self setBtDone:nil];
    [super viewDidUnload];
}


#pragma mark - button action
- (IBAction)DoneAction:(id)sender {
    [btDone setEnabled:NO];
    
    if (function==0) {
        Kumulos *k=[[Kumulos alloc] init];
        [k setDelegate:self];
        [k createPostWithTextValue:[self.tvContent text] andFunction:1 andDrinksDetail:nil andPhotoDetail:nil andUserID:[self.userID intValue] andEventID:[self.eventID intValue]];
    }
    else if (function==1)
    {
        Kumulos *k=[[Kumulos alloc] init];
        [k setDelegate:self];
        [k createPostCommentWithComment:[self.tvContent text] andUserID:[[self userID] intValue] andPostID:[[self postID] intValue] andEventID:[[self eventID] intValue]];
    }

}

- (IBAction)CancelAction:(id)sender {
    [self dismissModalViewControllerAnimated:YES];
}

#pragma mark - Kumulos delegate
- (void) kumulosAPI:(Kumulos *)kumulos apiOperation:(KSAPIOperation *)operation createPostCommentDidCompleteWithResult:(NSNumber *)newRecordID
{
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"eventPostDBID like %@", self.postID];
    NSArray *abc = [[appDelegate.timelineManager.timelineDic objectForKey:self.eventID] filteredArrayUsingPredicate:predicate];
    
    [appDelegate sendNotificationWithFriendsList:[[NSMutableArray alloc] initWithArray:abc] Content:[NSString stringWithFormat:@"Comment %@",[self.tvContent text]] UserID:userID EventID:[self eventID] function:0];
    
    if (eventMainPageTableCell!=nil) {
        eventMainPageTableCell.lbCommentDisplay.text=[NSString stringWithFormat:@"%d",[eventMainPageTableCell.lbCommentDisplay.text intValue]+1];
    }
    else if (eventMainPageHTableCell!=nil)
    {
        eventMainPageHTableCell.lbCommentDisplay.text=[NSString stringWithFormat:@"%d",[eventMainPageHTableCell.lbCommentDisplay.text intValue]+1];
    }
    else if (eventMainPagePTableCell!=nil)
    {
        eventMainPagePTableCell.lbCommentDisplay.text=[NSString stringWithFormat:@"%d",[eventMainPagePTableCell.lbCommentDisplay.text intValue]+1];
    }
    [self dismissModalViewControllerAnimated:YES];

}

- (void) kumulosAPI:(Kumulos *)kumulos apiOperation:(KSAPIOperation *)operation createPostDidCompleteWithResult:(NSNumber *)newRecordID
{
    eventMainPageViewController.addPost++;
    [self dismissModalViewControllerAnimated:YES];
    
    
    NSDateFormatter *dateTimeFormat = [[NSDateFormatter alloc] init];
    [dateTimeFormat setDateFormat:@"yyyyMMddHHmmss"]; //24 hrs
    NSDate *now=[[NSDate alloc] init];
    NSString *nowStr=[dateTimeFormat stringFromDate:now];
    NSLog(@"%@",nowStr);
    
    [appDelegate sendNotificationForTimelineWithFriendsList:friendsList Content:[NSString stringWithFormat:@"%@",[self.tvContent text]] UserID:userID EventID:[self eventID] function:0 PostFunction:1 eventPostDBID:[newRecordID intValue] timeCreated:nowStr photoDBID:nil drinkID:nil];
}
-(void) kumulosAPI:(kumulosProxy *)kumulos apiOperation:(KSAPIOperation *)operation didFailWithError:(NSString *)theError
{
    [btDone setEnabled:YES];
}


@end
