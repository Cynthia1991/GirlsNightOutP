//
//  ViewController.h
//  drinkTable
//
//  Created by Desmond on 1/06/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "DrinkListViewController.h"
#import "Drinks.h"
#import "AppDelegate.h"
#import "Kumulos.h"
#import "EventMainPageViewController.h"

@interface DrinkTableViewController : UIViewController<KumulosDelegate>

@property (nonatomic,strong) AppDelegate *aDelegate;
@property (nonatomic,strong) UIScrollView *myScrollView;
@property (nonatomic,strong) EventMainPageViewController *eventMainPageViewController;
@property (nonatomic) int eventDBID;
@property (nonatomic) int userDBID;
@property (nonatomic) NSInteger addDrinksFunction;
@property (weak, nonatomic) IBOutlet UILabel *lbDrinkName;
@property (weak, nonatomic) IBOutlet UILabel *lbDrinkContent;
@property (strong, nonatomic) IBOutlet UIButton *btBlackboard;

@property (nonatomic) Boolean isActivity;//0=current,1=pass

-(void)addImgView:(UITapGestureRecognizer *)recognizer;
//-(void)handlePan1:(UIPanGestureRecognizer *)recognizer;
-(void)addImgViewAfterPopTime:(float) x Y:(float)y;

@end
