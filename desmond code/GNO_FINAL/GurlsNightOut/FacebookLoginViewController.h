//
//  FacebookLoginViewController.h
//  gno
//
//  Created by calvin on 24/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "Kumulos.h"
@interface FacebookLoginViewController : UIViewController<KumulosDelegate,UIActionSheetDelegate>
{
    AppDelegate *appDelegate;
    NSString *userID;
    NSString *userName;
    UIImage *userIcon;
    
    NSString *userPhotoDBID;
    NSData *userPhotoData;
    
    NSInteger uploadPhotoFuction;
}
@property (strong, nonatomic) MBProgressHUD *HUD;

- (IBAction)facebookLoginAction:(id)sender;
@end
