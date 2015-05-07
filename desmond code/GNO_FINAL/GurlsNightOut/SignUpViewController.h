//
//  SignUpViewController.h
//  GurlsNightOut
//
//  Created by calvin on 1/05/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Kumulos.h"
#import "AppDelegate.h"

@interface SignUpViewController : UIViewController<KumulosDelegate,UITextFieldDelegate>
{
    AppDelegate *appDelegate;
    
}
@property (strong, nonatomic) IBOutlet UITextField *tfUserID;
@property (strong, nonatomic) IBOutlet UITextField *tfPassword;
@property (strong, nonatomic) IBOutlet UITextField *tfConfirmPW;
@property (strong, nonatomic) IBOutlet UITextField *tfUserName;
@property (strong, nonatomic) IBOutlet UITextField *tfPhoneNumber;
@property (strong, nonatomic) IBOutlet UIScrollView *myScollView;

- (IBAction)SignUpAction:(id)sender;
- (IBAction)backButtonAction:(id)sender;
- (IBAction)textfieldReturn:(id)sender;

@end
