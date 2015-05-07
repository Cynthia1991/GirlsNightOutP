//
//  MainPageController.m
//  GurlsNightOut
//
//  Created by calvin on 5/04/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MainPageController.h"

@interface MainPageController ()

@end

@implementation MainPageController
@synthesize mainBackgroud;
@synthesize btStart;
@synthesize ivStars1;
@synthesize ivStars2;
@synthesize ivStars3;
@synthesize svInstruction;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

#pragma mark - View life
- (void) viewWillAppear:(BOOL)animated
{
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    appDelegate=(AppDelegate*)[[UIApplication sharedApplication] delegate];
    if ([[appDelegate.instructionManager.instructionDic objectForKey:@"mainPage"] boolValue]) {
        [svInstruction setHidden:YES];
    }
    else
    {
        [svInstruction setHidden:NO];
    }
	// Do any additional setup after loading the view.
    svInstruction.contentSize=CGSizeMake(320*3, 460);
    [svInstruction setContentOffset:CGPointMake(0, 0)];
    
    NSString *userInfoDicPath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"userInfoDicPath"];
    NSDictionary *userInfoDic=[NSDictionary dictionaryWithContentsOfFile:userInfoDicPath];
    if ([userInfoDic count]==0) {
        [self presentModalViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"LoginNavController"] animated:NO];
    }
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:nil action:nil];
	[[self navigationItem] setBackBarButtonItem:backButton];
    //////////////////////////////////////////////
    [UIView beginAnimations:@"mainBackground" context:nil];
    [UIView setAnimationDuration:3.0];
    
    CGRect ntViewFrame=[mainBackgroud frame];
    ntViewFrame.origin.y=-420;
    mainBackgroud.frame=ntViewFrame;
        
    [UIView commitAnimations];
    
    ivStars1.hidden=NO;
    ivStars2.hidden=NO;
    ivStars3.hidden=NO;

    [NSTimer scheduledTimerWithTimeInterval:0.5f
                                     target:self
                                   selector:@selector(changeStartButtonBackground)
                                   userInfo:nil
                                    repeats:NO];
}


- (void)viewDidUnload
{
    [self setMainBackgroud:nil];
    [self setBtStart:nil];
    [self setIvStars1:nil];
    [self setIvStars2:nil];
    [self setIvStars3:nil];
    [self setSvInstruction:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

#pragma mark - sky animation
- (void)changeStartButtonBackground
{
    if (isOnStartButton==0) {
        btStart.imageView.image=[UIImage imageNamed:@"StartButtonON.png"];
        isOnStartButton=1;
        [NSTimer scheduledTimerWithTimeInterval:0.5f
                                         target:self
                                       selector:@selector(changeStartButtonBackground)
                                       userInfo:nil
                                        repeats:NO];
    }
    else {
        btStart.imageView.image=[UIImage imageNamed:@"StartButtonOFF.png"];
        isOnStartButton=0;
        [NSTimer scheduledTimerWithTimeInterval:0.5f
                                         target:self
                                       selector:@selector(changeStartButtonBackground)
                                       userInfo:nil
                                        repeats:NO];
    }
}

#pragma mark - scrollView Delegate
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    if (scrollView.contentOffset.x>640) {
        [UIView animateWithDuration:0.5
                         animations:^{
                             [svInstruction setAlpha:0.0];
                             
                         }
                         completion:^(BOOL finished){
                             [svInstruction setHidden:YES];
                             [appDelegate.instructionManager setInstructionDicWithValue:YES Key:[NSString stringWithFormat:@"mainPage"]];
                         }];
    }
}
@end
