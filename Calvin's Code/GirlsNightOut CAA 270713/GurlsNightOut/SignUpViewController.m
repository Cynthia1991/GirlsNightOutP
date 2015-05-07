//
//  SignUpViewController.m
//  GurlsNightOut
//
//  Created by calvin on 1/05/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SignUpViewController.h"
#import "CommonCell.h"

@interface SignUpViewController ()

@end

@implementation SignUpViewController
@synthesize tfPhoneNumber;
@synthesize tfConfirmPW;
@synthesize tfUserID,tfPassword,tfUserName,myScollView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void)viewWillAppear:(BOOL)animated
{
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    appDelegate=(AppDelegate*)[[UIApplication sharedApplication] delegate];
    [self.contentView setFrame:CGRectMake(0, 0, 320, [[UIScreen mainScreen] bounds].size.height-20)];

}

- (void)viewDidUnload
{
    [self setTfUserName:nil];
    [self setTfConfirmPW:nil];
    [self setTfPhoneNumber:nil];
    [self setContentView:nil];
    [super viewDidUnload];
}


#pragma mark - Table view data source

- (IBAction)backButtonAction:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)textfieldReturn:(id)sender{
    // hide current keyboard
    [tfUserID resignFirstResponder];
    [tfPassword resignFirstResponder];
    [tfUserName resignFirstResponder];
    [tfConfirmPW resignFirstResponder];
    [tfPhoneNumber resignFirstResponder];
    
    self.myScollView.frame=CGRectMake(0, 0, 320, [[UIScreen mainScreen] bounds].size.height-20);
}
#pragma mark - textField delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	// hide current keyboard
	[textField resignFirstResponder];
    
    self.myScollView.frame=CGRectMake(0, 0, 320, [[UIScreen mainScreen] bounds].size.height-20);
	return YES;
}
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [UIView beginAnimations:@"ResizeForKeyBoard" context:nil];
    [UIView setAnimationDuration:0.5f];
    
    self.myScollView.frame=CGRectMake(0, 0, 320, [[UIScreen mainScreen] bounds].size.height-20-196);
    self.myScollView.contentSize=CGSizeMake(320, [[UIScreen mainScreen] bounds].size.height-20);
    [self.contentView setFrame:CGRectMake(0, 0, 320, [[UIScreen mainScreen] bounds].size.height-20)];
    [self.myScollView setContentOffset:CGPointMake(0, 140) animated:YES];
    [UIView commitAnimations];
}
#pragma mark - sign up button action
- (IBAction)SignUpAction:(id)sender {
    if ([tfPassword.text isEqualToString:tfConfirmPW.text]) {
        NSString *userEmail=[NSString stringWithFormat:@"%@",tfUserID.text];
        NSString *userPassword=[NSString stringWithFormat:@"%@",tfPassword.text];
        NSString *userName=[NSString stringWithFormat:@"%@",tfUserName.text];
        
        ///////////////////////////////////////////!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!check userName valid first!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
        NSString *deviceTokenPath=[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"deviceTokenPath"];
        NSString *deviceToken=[NSString stringWithContentsOfFile:deviceTokenPath encoding:NSASCIIStringEncoding error:nil];
        NSLog(@"%@",deviceToken);
        
        [appDelegate.myDetailsManager.userPersonalInfoDic setObject:[NSString stringWithFormat:@"%@", tfPhoneNumber.text] forKey:@"mobilePhone"];
        [appDelegate.myDetailsManager rewriteUserPersonalInfoDic];
        
        Kumulos *k=[[Kumulos alloc] init];
        [k setDelegate:self];
        [k createUserAPIWithUserID:userEmail andUserName:userName andUserPassword:userPassword andPhotosDBID:0 andLatitude:0 andLongitude:0 andDeviceToken:deviceToken andBadgeNumber:0 andLoginType:1];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No match in password" message:@"The confirm password is not match" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
}

#pragma mark - Kumulos delegate
- (void) kumulosAPI:(Kumulos *)kumulos apiOperation:(KSAPIOperation *)operation createUserAPIDidCompleteWithResult:(NSNumber *)newRecordID
{   
    //save the user info in local
    Kumulos *k=[[Kumulos alloc] init];    
    [k setDelegate:self];
    [k getUserInfoByDBIDWithUserDBID:[newRecordID intValue]];
}
- (void) kumulosAPI:(Kumulos*)kumulos apiOperation:(KSAPIOperation*)operation getUserInfoByDBIDDidCompleteWithResult:(NSArray*)theResults
{
    if ([theResults count]!=0) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"save user detail to app" object:theResults];
        [self dismissModalViewControllerAnimated:YES];
    }
    else {
        //exist
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"User Login Fail",@"User Login Fail") message:NSLocalizedString(@"User Login Fail, please enter again.",@"User Login Fail, please enter again.") delegate:self cancelButtonTitle:NSLocalizedString(@"Okay", @"Okay") otherButtonTitles:nil];
        [alert show]; 
    }
    [self dismissModalViewControllerAnimated:YES];

}

- (void) kumulosAPI:(kumulosProxy *)kumulos apiOperation:(KSAPIOperation *)operation didFailWithError:(NSString *)theError
{
    NSLog(@"kumulos error: %@",theError);
}
@end
