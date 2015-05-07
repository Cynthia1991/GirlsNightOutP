//
//  ViewController.h
//  GNOdare
//
//  Created by Desmond on 15/10/12.
//  Copyright (c) 2012 QUT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "iCarousel.h"
#import "AsyncImageView.h"
#import <AudioToolbox/AudioServices.h>
#import <AVFoundation/AVAudioPlayer.h>
#import <QuartzCore/QuartzCore.h>
#import "gameTask.h"
#import "COGViewController.h"
#import "AppDelegate.h"
#import "BumpKumulosHandler.h"

@interface spinViewController : UIViewController <iCarouselDataSource, iCarouselDelegate,AVAudioPlayerDelegate,KumulosDelegate>
{
     AppDelegate *appDelegate;
    
   
    
    BOOL spinned;
    BOOL truth;
    BOOL dare;
    BOOL pulledDown;
    BOOL isCompleted;
    CGRect imageLocation;
    int firstScroll;
    int slowDownScroll;
    int endingScroll;
    
    int firstTODScroll;
    int slowDownTODScroll;
    int endingTODScroll;
    
    int leverStage;
    
    UIPanGestureRecognizer *panRecog;
    UITapGestureRecognizer *tapRecog;
    
}

@property (nonatomic,strong) BumpKumulosHandler *bumpKumulosHandler;

 @property (nonatomic,strong) NSMutableArray *friendsArray;
//player spinner
@property (nonatomic, weak) IBOutlet iCarousel *carouselView;
@property (nonatomic, strong) NSString *eventID;
@property (nonatomic,strong)  NSString *userID;
@property (nonatomic,weak) IBOutlet UILabel *nameTag;

@property (nonatomic,weak) IBOutlet UIButton *exitButton;
//@property (nonatomic,weak) IBOutlet UIButton *active;
@property (nonatomic, strong) NSMutableArray *picsURLArray;
@property (nonatomic, strong) NSMutableArray *picsLocalArray;
@property (nonatomic, strong) NSMutableArray *nameArray;
@property (nonatomic, strong) NSMutableArray *userIDArray;
@property (nonatomic, assign) NSTimer *scrollTimer;
@property (nonatomic, assign) NSTimer *scrollTimer2;
@property (nonatomic, assign) NSTimeInterval lastTime;
@property (nonatomic,weak) IBOutlet UIView *alphaOverlay;
@property (nonatomic,strong) UIImageView *largeImgView;
@property (nonatomic,weak) IBOutlet UIView *largeImageView;
@property (nonatomic,strong) IBOutlet UIImageView *crosshairView;

-(void)setupData; //name
-(void)setupDataURL; //image URL
-(void)setupDataLocal; //image URL
-(IBAction)spinTheWheel:(id)sender;
- (void)startScrolling;
- (void)stopScrolling;
- (void)scrollStep;
- (void)slowScrolling;
- (void)slowDownScrollStep;
- (void)endingScrolling;
- (void)endingScrollStep;
-(void)enableButton;
-(void)resetSpinner;
-(IBAction)exitSpinner:(id)sender;

//player ToD Spinner

@property (nonatomic, weak) IBOutlet iCarousel *ToDCarouselView;
@property (nonatomic,weak) IBOutlet UIButton *trueButton;
@property (nonatomic,weak) IBOutlet UIButton *dareButton;
@property (nonatomic,weak) IBOutlet UIImageView *TODView;
@property (nonatomic, strong) NSMutableArray *ToDGameArray;

-(void)showTOD;
-(void)hideTOD;
-(IBAction)dareAction:(id)sender;
-(IBAction)trueAction:(id)sender;
-(void)setTimerForSpinner;
-(void)setupTODData;
-(void)removePlayerSpinner;
-(void)removeTODSpinner;

- (void)startTODScrolling;
- (void)stopTODScrolling;
- (void)TODScrollStep;
- (void)slowTODScrolling;
- (void)slowDownTODScrollStep;
- (void)endingTODScrolling;
- (void)endingTODScrollStep;

//round corner
-(UIImage *)makeRoundCornerImage : (UIImage*) img : (int) cornerWidth : (int) cornerHeight;

//game task card
@property (strong, nonatomic)gameTask *dareGameTaskPlist;
@property (strong, nonatomic)gameTask *truthGameTaskPlist;
@property (nonatomic, strong) NSMutableArray *headerGameNameArray;
@property (nonatomic, strong) NSMutableArray *detailGameNameArray;
@property (nonatomic, strong) NSMutableArray *gameIconArray;
@property (nonatomic,weak) IBOutlet UIImageView *COGView;

@property (nonatomic,weak) IBOutlet UIButton *giveUpButton;
@property (nonatomic,weak) IBOutlet UIButton *completeButton;

-(IBAction)giveUpAction:(id)sender;
-(IBAction)completeAction:(id)sender;

-(void)showDoneOrFail;
-(void)hideDoneOrFail;

@property (nonatomic, strong) AVAudioPlayer *spinningSound;
@property (nonatomic, strong) AVAudioPlayer *taskCardSound;
@property (nonatomic, strong) AVAudioPlayer *selectedSound;
-(void)doVolumeFade;
-(void)spinVolumeFade;



//level
@property (nonatomic,weak) IBOutlet UIImageView *levelImgView;
-(void)setUpLever;
-(void)leverFullAnimation;
-(void)leverBackAnimation;
-(void)completeAnimation:(NSNumber*)lever;
-(void)setImgbackTofirst;
-(void)handlePan:(UIPanGestureRecognizer *)recognizer;
-(void)handleTap:(UITapGestureRecognizer *)recognizer;

@property (nonatomic, strong) NSArray *fullArray;
@property (nonatomic, strong) NSArray *halfArray;
@property (nonatomic, strong) NSMutableArray *upCompleteArray;
@property (nonatomic, strong) NSMutableArray *downCompleteArray;


@end
