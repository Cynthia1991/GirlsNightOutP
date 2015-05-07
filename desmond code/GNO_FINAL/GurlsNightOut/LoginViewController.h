//
//  LoginViewController.h
//  GurlsNightOut
//
//  Created by calvin on 1/05/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Kumulos.h"
#import "AppDelegate.h"

@interface LoginViewController : UIViewController<UITextFieldDelegate,KumulosDelegate>
{
    AppDelegate *appDelegate;
    
    NSString *userID;
    NSString *userName;
    
}
@property (strong, nonatomic) IBOutlet UITextField *tfUserID;
@property (strong, nonatomic) IBOutlet UITextField *tfPassword;
@property (strong, nonatomic) IBOutlet UIScrollView *myScollView;



- (IBAction)LoginAction:(id)sender;
- (IBAction)textfieldReturn:(id)sender;
- (IBAction)backButtonAction:(id)sender;
@end
