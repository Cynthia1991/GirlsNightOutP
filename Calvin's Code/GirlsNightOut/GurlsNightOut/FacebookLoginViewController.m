//
//  FacebookLoginViewController.m
//  gno
//
//  Created by calvin on 24/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "FacebookLoginViewController.h"

@interface FacebookLoginViewController ()

@end

@implementation FacebookLoginViewController

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
    [[NSNotificationCenter defaultCenter]  addObserver:self selector:@selector(loginToServer:) name:@"loginToServer" object:nil];
    [[NSNotificationCenter defaultCenter]  addObserver:self selector:@selector(loginToServerGetphotos:) name:@"loginToServerGetphotos" object:nil];
        [[NSNotificationCenter defaultCenter]  addObserver:self selector:@selector(loginToServergetProfile:) name:@"loginToServergetProfile" object:nil];
    [[NSNotificationCenter defaultCenter]  addObserver:self selector:@selector(getProfile:) name:@"getProfile" object:nil];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}


- (IBAction)facebookLoginAction:(id)sender {
    [appDelegate facebookLogout];

    [appDelegate facebookLogin];
    
}

#pragma mark - Login Function

- (void)getProfile:(NSNotification*) notification///////////////////////////////////////////////
{
    NSLog(@"c1111111alled!!!!!!!!!!!!!!!");
    
    NSMutableDictionary *result=[notification object];
    NSString * PPdata = [result objectForKey:@"source"];
    NSLog(@"source %@",PPdata );
    
    NSString *iconPath=PPdata;
    NSURL *url = [NSURL URLWithString:iconPath];
    NSData *data = [NSData dataWithContentsOfURL:url];
    userIcon = [UIImage imageWithData:data];
    
    Kumulos *k=[[Kumulos alloc] init];
    [k setDelegate:self];
    [k getUserDBByFacebookIDWithUserID:userID];
}

- (void) loginToServergetProfile:(NSNotification*) notification///////////////////////////////////////////////
{
    NSLog(@"called!!!!!!!!!!!!!!!");
    
     NSMutableDictionary *result=[notification object];
    NSString * cover_photoID = [result objectForKey:@"cover_photo"];
    NSLog(@"cover_photo %@",cover_photoID );
    
    [appDelegate getProfilePics:cover_photoID];

}


- (void) loginToServerGetphotos:(NSNotification*) notification///////////////////////////////////////////////get
{
    NSMutableDictionary *result=[notification object];
    
    NSMutableArray * data = [result objectForKey:@"data"];
    for (int i=0; i<[data count]; i++)
    {
        NSDictionary *tempDICT = [data  objectAtIndex:i];
        NSString *name = [tempDICT objectForKey:@"name"];
        if ([name isEqualToString:@"Profile Pictures"])
        {
            //NSString *webLink = [tempDICT objectForKey:@"link"];
            NSString *webid = [tempDICT objectForKey:@"id"];
            
            [appDelegate CallToFindProfilePics:webid];
        }
    }
}
- (void) loginToServer:(NSNotification*) notification///////////////////////////////////////////////get
{
    self.HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
	self.HUD.dimBackground = YES;
	self.HUD.labelText = @"Loading...";
    
    
    NSMutableDictionary *result=[notification object];
    NSLog(@"result %@",result);
    userID = [result objectForKey:@"id"];
    userName = [result objectForKey:@"name"];
    
//    NSString *iconPath=[NSString stringWithFormat:@"http://graph.facebook.com/%@/picture?type=large",[result objectForKey:@"username"]];
//    NSURL *url = [NSURL URLWithString:iconPath];
//    NSData *data = [NSData dataWithContentsOfURL:url];
//    userIcon = [UIImage imageWithData:data];
    
    
    
    
//    NSString *icp=[NSString stringWithFormat:@"https://graph.facebook.com/%@/albums?access_token=AAAAAAITEghMBAEEFq5JTf4F68pAjnNKhy0LZAMGhz7oZC03vrz3UDVmDUNhksxfZAZBBxOA6xz5q6IgMaG08cAgOB9rDVP4ZALTNDlrsZATgZDZD",[result objectForKey:@"username"]];
    
    //NSLog(@"UTC String %@",UTCString);
//    NSURL *updateDataURL = [NSURL URLWithString:icp];
//    NSString *checkValue = [NSString stringWithContentsOfURL:updateDataURL encoding:NSASCIIStringEncoding error:Nil];
     
//    Kumulos *k=[[Kumulos alloc] init];
//    [k setDelegate:self];
//    [k getUserDBByFacebookIDWithUserID:userID];
}
#pragma mark - actionSheet delegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==0) {
        userPhotoData = UIImageJPEGRepresentation(userIcon, 1.0);
        [appDelegate.photoManager deletePhotoWithPhotoDBID:userPhotoDBID];
        
        Kumulos *k=[[Kumulos alloc] init];
        [k setDelegate:self];
        [k deleteIconWithPhotosDBID:[userPhotoDBID intValue]];
    }
    else if(buttonIndex==1){
        //already download in appDelegate
//        [self loadPhotoFromServer:[userPhotoDBID intValue]];
        
//        userPhotoData = UIImageJPEGRepresentation(userIcon, 1.0);
//        [[appDelegate photoManager] addPhoto:userPhotoData text:@"1" PhotoDBID:userPhotoDBID];
        [self dismissModalViewControllerAnimated:YES];
    }
}
#pragma mark - load photo from server
- (void) loadPhotoFromServer:(int) photoDBID
{
    Kumulos *k=[[Kumulos alloc] init];
    [k setDelegate:self];
    [k getPhotoWithPhotosDBID:photoDBID];
}

#pragma mark - Kumulos delegate
- (void) kumulosAPI:(Kumulos *)kumulos apiOperation:(KSAPIOperation *)operation deleteIconDidCompleteWithResult:(NSNumber *)affectedRows
{
    userPhotoData = UIImageJPEGRepresentation(userIcon, 1.0);
    Kumulos *k=[[Kumulos alloc] init];
    [k setDelegate:self];
    uploadPhotoFuction=1;
    [k uploadPhotosWithPhotoValue:userPhotoData andTextValue:@"1" andLargePhotoValue:nil];
}
- (void) kumulosAPI:(Kumulos *)kumulos apiOperation:(KSAPIOperation *)operation getPhotoDidCompleteWithResult:(NSArray *)theResults
{
    if ([theResults count]!=0) {
        [[appDelegate photoManager] addPhoto:[[theResults objectAtIndex:0] objectForKey:@"photoValue"] text:[[theResults objectAtIndex:0] objectForKey:@"textValue"] PhotoDBID:[[theResults objectAtIndex:0] objectForKey:@"photosDBID"]];
    }
    [self dismissModalViewControllerAnimated:YES];
}

- (void) kumulosAPI:(Kumulos *)kumulos apiOperation:(KSAPIOperation *)operation getUserDBByFacebookIDDidCompleteWithResult:(NSArray *)theResults
{
    if ([theResults count]==0) {
        ///////////////////////////////////////////!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!check userName valid first!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
        userPhotoData = UIImageJPEGRepresentation(userIcon, 1.0);
        Kumulos *k=[[Kumulos alloc] init];
        [k setDelegate:self];
        uploadPhotoFuction=0;
        [k uploadPhotosWithPhotoValue:userPhotoData andTextValue:@"1" andLargePhotoValue:nil];
    }
    else {
        //save the user info in local
        [[NSNotificationCenter defaultCenter] postNotificationName:@"save user detail to app" object:theResults];
        
        [self.HUD hide:YES afterDelay:0.3];
        
        userPhotoDBID=[NSString stringWithFormat:@"%@",[[theResults objectAtIndex:0] objectForKey:@"photosDBID"]];
        UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                      initWithTitle:@"Personal Photo"         //Title
                                      delegate:self                  //delegate
                                      cancelButtonTitle:nil
                                      destructiveButtonTitle:nil
                                      otherButtonTitles:@"Using Facebook photo", @"No", nil];  //button
        [actionSheet showInView:self.view];/////////////////////////////////////////////////////////interesting,not in tabbar has somge problem
    }
}
- (void) kumulosAPI:(Kumulos *)kumulos apiOperation:(KSAPIOperation *)operation updateUserIconDidCompleteWithResult:(NSNumber *)affectedRows
{
    [self dismissModalViewControllerAnimated:YES];
}
- (void) kumulosAPI:(Kumulos *)kumulos apiOperation:(KSAPIOperation *)operation uploadPhotosDidCompleteWithResult:(NSNumber *)newRecordID
{
    NSData *imageData=UIImageJPEGRepresentation(userIcon, 1.0);
    [appDelegate.photoManager addPhoto:imageData text:@"1" PhotoDBID:[NSString stringWithFormat:@"%@", newRecordID]];
    if (uploadPhotoFuction==1) {
        [[appDelegate photoManager] addPhoto:imageData text:@"1" PhotoDBID:[NSString stringWithFormat:@"%@", newRecordID]];
        Kumulos *k=[[Kumulos alloc] init];
        [k setDelegate:self];
        [k updateUserIconWithPhotosDBID:[[NSString stringWithFormat:@"%@", newRecordID] intValue] andUserDBID:[[appDelegate.myDetailsManager.userInfoDic objectForKey:@"userDBID"] intValue]];
    }
    else if (uploadPhotoFuction==0)
    {
        /////////////////////////////////////////////////////////////////////////////////////////////
        NSString *deviceTokenPath=[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"deviceTokenPath"];
        NSString *deviceToken=[NSString stringWithContentsOfFile:deviceTokenPath encoding:NSASCIIStringEncoding error:nil];
        NSLog(@"%@",deviceToken);
        
        Kumulos *k=[[Kumulos alloc] init];
        [k setDelegate:self];
        [k createUserAPIWithUserID:userID andUserName:userName andUserPassword:0 andPhotosDBID:[newRecordID intValue] andLatitude:0 andLongitude:0 andDeviceToken:deviceToken andBadgeNumber:0 andLoginType:0];
    }
    
}
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
        //save the user info in local
        [[NSNotificationCenter defaultCenter] postNotificationName:@"save user detail to app" object:theResults];
        
        
        [self dismissModalViewControllerAnimated:YES];
    }
    else {
        //exist
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"User Login Fail",@"User Login Fail") message:NSLocalizedString(@"User Login Fail, please enter again.",@"User Login Fail, please enter again.") delegate:self cancelButtonTitle:NSLocalizedString(@"Okay", @"Okay") otherButtonTitles:nil];
        [alert show];
    }
//    [self dismissModalViewControllerAnimated:YES];
    
}

- (void) kumulosAPI:(kumulosProxy *)kumulos apiOperation:(KSAPIOperation *)operation didFailWithError:(NSString *)theError
{
    NSLog(@"kumulos error: %@",theError);
}
@end
