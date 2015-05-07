//
//  TimelineScrollViewController.h
//  gno
//
//  Created by calvin on 31/05/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "TimelinePageControl.h"
#import "BumpConnector.h"
#import "BumpKumulosHandler.h"

@interface TimelineScrollViewController : UIViewController <UIActionSheetDelegate,UIScrollViewDelegate,KumulosDelegate,UIAlertViewDelegate>
{
    AppDelegate *appDelegate;
    
    IBOutlet UIView *menuBackgroundView;
    IBOutlet UIView *homeButtonView;

    IBOutlet UIView *quickDialView;
    IBOutlet UIView *addFriendsView;
    IBOutlet UIView *addTextView;
    IBOutlet UIView *dismissView;
    IBOutlet UIView *popUpView;
    IBOutlet UIView *addPhotoView;
    IBOutlet UIView *iAmHomeView;
    
    NSInteger menuButtonFunction;
    IBOutlet UIImageView *animationImg;
    
    IBOutlet TimelinePageControl *myPageControl;
    CALayer *transformed;    
    CALayer *imageLayer;
    
    BumpConnector *bumpConn;

    NSInteger scollViewDirection;
}
@property (nonatomic, retain) NSString *eventID;
@property (strong, nonatomic) IBOutlet UIScrollView *myScrollView;
@property (weak, nonatomic) IBOutlet UIView *myScrollViewRootView;
@property (strong, nonatomic) IBOutlet UIScrollView *scvTimelineInstruction;
@property (strong, nonatomic) UINavigationController *timelineNavigationController;
@property (strong, nonatomic) UINavigationController *addDrinksNavigationController;
@property (strong, nonatomic) UINavigationController *quickDialNavigationController;
@property (strong, nonatomic) IBOutlet UIButton *menuButton;
@property (nonatomic,strong) NSMutableArray *friendsList;
@property (nonatomic,strong) BumpKumulosHandler *bumpKumulosHandler;

@property (nonatomic) Boolean isActivity;//0=current,1=pass

- (IBAction)homeAction:(UIButton*)sender;
- (void) ann:(NSInteger) y View:(UIView*) view Time:(float) time;
- (IBAction)dismissAction:(id)sender;
- (IBAction)addTextAction:(id)sender;
- (IBAction)touchMenuBackgroudViewAction:(id)sender;
- (IBAction)pageClick:(id)send;
- (IBAction)addFriendsAction:(id)sender;
- (IBAction)quickDialAction:(id)sender;
- (IBAction)addPhotosAction:(id)sender;
- (IBAction)iAmHomeAction:(id)sender;

- (void) addTextActionFunction:(NSNotification*)notification;
-(void)callGameView;

//Edited by Desmond//
//Game View

@property (strong, nonatomic) UINavigationController *gameNavigationController;


@end
