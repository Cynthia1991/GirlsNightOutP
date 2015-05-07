//
//  DrinkingView.h
//  GNO
//
//  Created by Calvin on 29/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Drinks.h"
#import "Kumulos.h"
#import "AppDelegate.h"

@interface DrinkingView : UIView<KumulosDelegate,UIAlertViewDelegate>
{
    NSInteger isUpdate;
    AppDelegate *appDelegate;
}
@property (nonatomic,strong) Drinks *drink;
@property (nonatomic,strong) NSString *drinkID;
@property (nonatomic,strong) NSString *postID;
@property (nonatomic,strong) NSString *userID;
@property (nonatomic,strong) NSString *eventID;
@property (nonatomic,strong) UILabel *timeStamp;
- (id)initWithFrame:(CGRect)frame Date:(NSDate*)drinkDate Drink:(Drinks*) drink1;

@end
