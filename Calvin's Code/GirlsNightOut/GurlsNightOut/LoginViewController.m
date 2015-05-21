//
//  LoginViewController.m
//  GurlsNightOut
//
//  Created by calvin on 1/05/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "LoginViewController.h"

@interface LoginViewController ()

@end

@implementation LoginViewController
@synthesize tfUserID;
@synthesize tfPassword;
@synthesize myScollView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    appDelegate=(AppDelegate*)[[UIApplication sharedApplication] delegate];
    
    self.myScollView.frame=CGRectMake(0, 0, 320, [[UIScreen mainScreen] bounds].size.height-20);
    self.myScollView.contentSize=CGSizeMake(320, [[UIScreen mainScreen] bounds].size.height-20);
    [self.contentView setFrame:CGRectMake(0, 0, 320, [[UIScreen mainScreen] bounds].size.height-20)];
    

}

- (void)viewDidUnload
{
    [self setTfUserID:nil];
    [self setTfPassword:nil];
    [self setMyScollView:nil];
    [self setContentView:nil];
    [super viewDidUnload];
}
- (void)viewWillAppear:(BOOL)animated
{
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



#pragma mark - button action
- (IBAction)TextTouchDownAction:(id)sender {
    // 发送resignFirstResponder.
    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
}

- (IBAction)LoginAction:(id)sender {    
    NSString *userEmail=[NSString stringWithFormat:@"%@",tfUserID.text];
    NSString *userPassword=[NSString stringWithFormat:@"%@",tfPassword.text];
    
    
    Kumulos *k=[[Kumulos alloc] init];    
    [k setDelegate:self];
    [k getUserDBWithUserID:userEmail andUserPassword:userPassword];
}

- (IBAction)textfieldReturn:(id)sender {
    // hide current keyboard
	[tfUserID resignFirstResponder];
	[tfPassword resignFirstResponder];
    
    self.myScollView.frame=CGRectMake(0, 0, 320, [[UIScreen mainScreen] bounds].size.height);
}

- (IBAction)backButtonAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - Kumulos delegate
////////////////////////
-(void) kumulosAPI:(Kumulos *)kumulos apiOperation:(KSAPIOperation *)operation getUserDBDidCompleteWithResult:(NSArray *)theResults
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
}
@end
