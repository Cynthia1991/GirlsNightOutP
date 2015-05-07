//
//  MainPageController.h
//  GurlsNightOut
//
//  Created by calvin on 5/04/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
@interface MainPageController : UIViewController<UIScrollViewDelegate>
{
    AppDelegate *appDelegate;
    NSInteger isOnStartButton;
    NSInteger starsViewChange;
}
@property (strong, nonatomic) IBOutlet UIImageView *mainBackgroud;
@property (strong, nonatomic) IBOutlet UIButton *btStart;
@property (strong, nonatomic) IBOutlet UIImageView *ivStars1;
@property (strong, nonatomic) IBOutlet UIImageView *ivStars2;
@property (strong, nonatomic) IBOutlet UIImageView *ivStars3;
@property (strong, nonatomic) IBOutlet UIScrollView *svInstruction;
@end
