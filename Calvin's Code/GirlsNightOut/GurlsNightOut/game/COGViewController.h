//
//  COGViewController.h
//  GNOdare
//
//  Created by Desmond on 22/11/12.
//  Copyright (c) 2012 QUT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BumpKumulosHandler.h"
#import <QuartzCore/QuartzCore.h>


@interface COGViewController : UIViewController <KumulosDelegate,UIAlertViewDelegate>
{
    AppDelegate *appDelegate;
   
}

@property (nonatomic,weak) IBOutlet UIImageView *COGView;
@property (nonatomic,weak) IBOutlet UIImageView *iconImg;
@property (nonatomic,weak) IBOutlet UIImageView *stampImg;
@property (nonatomic,weak) IBOutlet UILabel *header;
@property (nonatomic,weak) IBOutlet UILabel *details;
@property (nonatomic, strong) NSString *eventID;
@property (nonatomic, strong) NSString *userID;

@property (nonatomic,strong)  UIImage *TCOGView;
@property (nonatomic,strong)  UIImage *TiconImg;
@property (nonatomic,strong)  NSString *Theader;
@property (nonatomic,strong)  NSString *Tdetails;
 @property (nonatomic) BOOL COGcompleted;


- (UIImage*) COG:(UIImageView *)COGI icon:(UIImageView *)iconI stamp:(UIImageView *)stampI hLabel:(UILabel *)headerL dlabel:(UILabel *)detailL;
@end
