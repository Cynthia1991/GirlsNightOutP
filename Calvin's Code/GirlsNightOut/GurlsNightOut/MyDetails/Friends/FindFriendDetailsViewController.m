//
//  FindFriendDetailsViewController.m
//  gno
//
//  Created by Calvin on 6/09/12.
//
//

#import "FindFriendDetailsViewController.h"
#import "UIImage+Dsp.h"

@interface FindFriendDetailsViewController ()

@end

@implementation FindFriendDetailsViewController
@synthesize friendsImage;
@synthesize lbFriendsName;
@synthesize ivIconBackground;
@synthesize friendName,friendIcon,friendPhotoDBID,friendUserDBID,friendDic;

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
	// Do any additional setup after loading the view.
    self.lbFriendsName.text=[self friendName];
    appdelegate=(AppDelegate*)[[UIApplication sharedApplication] delegate];
    
    self.friendsImage.layer.masksToBounds = YES; //没这句话它圆不起来
    self.friendsImage.layer.cornerRadius = 5.0; //设置图片圆角的尺度。
    

}
- (void)viewWillAppear:(BOOL)animated
{
    self.friendIcon=[appdelegate.photoManager getPhotoByPhotoDBID:self.friendPhotoDBID];
    if (friendIcon==nil) {
        if ([self.friendPhotoDBID intValue]!=0) {
            Kumulos *k=[[Kumulos alloc] init];
            [k setDelegate:self];
            [k getPhotoWithPhotosDBID:[self.friendPhotoDBID intValue]];
        }
        else{
            self.friendIcon=[UIImage imageNamed:@"Persondot.png"];
            
            UIImage *img=[self.friendIcon imageByApplyingGaussianBlurOfSize:5 withSigmaSquared:90.0];
            ivIconBackground.image=img;
            self.friendsImage.image=self.friendIcon;
        }
    }
    else
    {
        UIImage *img=[self.friendIcon imageByApplyingGaussianBlurOfSize:5 withSigmaSquared:90.0];
        ivIconBackground.image=img;
        self.friendsImage.image=self.friendIcon;
    }
}
- (void)viewDidUnload
{
    [self setFriendsImage:nil];
    [self setLbFriendsName:nil];
    [self setIvIconBackground:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}


- (IBAction)addFirendAction:(id)sender {
    Kumulos *k=[[Kumulos alloc] init];
    [k setDelegate:self];
    [k checkFriendsWithUserDBID:[[appdelegate.myDetailsManager.userInfoDic objectForKey:@"userDBID"] intValue] andFriendsUserDBID:[self.friendUserDBID intValue]];
}

- (IBAction)backAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) kumulosAPI:(Kumulos *)kumulos apiOperation:(KSAPIOperation *)operation getPhotoDidCompleteWithResult:(NSArray *)theResults
{
    if ([theResults count]!=0) {
        [[appdelegate photoManager] addPhoto:[[theResults objectAtIndex:0] objectForKey:@"photoValue"] text:[[theResults objectAtIndex:0] objectForKey:@"textValue"] PhotoDBID:[[theResults objectAtIndex:0] objectForKey:@"photosDBID"]];
        self.friendIcon=[appdelegate.photoManager getPhotoByPhotoDBID:self.friendPhotoDBID];
        
        UIImage *img=[self.friendIcon imageByApplyingGaussianBlurOfSize:5 withSigmaSquared:90.0];
        ivIconBackground.image=img;
        
        self.friendsImage.image=self.friendIcon;
    }
    else{
        self.friendIcon=[UIImage imageNamed:@"Persondot.png"];
        
        UIImage *img=[self.friendIcon imageByApplyingGaussianBlurOfSize:5 withSigmaSquared:90.0];
        ivIconBackground.image=img;
        self.friendsImage.image=self.friendIcon;
    }
}
- (void) kumulosAPI:(Kumulos *)kumulos apiOperation:(KSAPIOperation *)operation checkFriendsDidCompleteWithResult:(NSArray *)theResults
{
    if ([theResults count]==0) {
        Kumulos *k=[[Kumulos alloc] init];
        [k setDelegate:self];
        [k createFriendsWithFriendsName:self.friendName andUserDBID:[[appdelegate.myDetailsManager.userInfoDic objectForKey:@"userDBID"] intValue] andFriendsUserDBID:[self.friendUserDBID intValue]];
    }
    else
    {
        NSString *notificationContent=[NSString stringWithFormat:@"%@ has been your friend!",[[theResults objectAtIndex:0] objectForKey:@"friendsName"]];
        [appdelegate sendStatusBarNotificationWithContent:notificationContent];
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}
- (void) kumulosAPI:(Kumulos *)kumulos apiOperation:(KSAPIOperation *)operation createFriendsDidCompleteWithResult:(NSNumber *)newRecordID
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"reload Friends List Data" object:nil];
    
    NSString *notificationContent=[NSString stringWithFormat:@"%@ has been your friend!",[self.friendDic objectForKey:@"userName"]];
    [appdelegate sendStatusBarNotificationWithContent:notificationContent];
    
    NSMutableArray *arr=[[NSMutableArray alloc] init];
    NSMutableDictionary *dic=[[NSMutableDictionary alloc] init];
    [dic setObject:self.friendDic forKey:@"userID"];
    [arr addObject:dic];
    
    [appdelegate sendNotificationWithFriendsList:arr Content:[NSString stringWithFormat:@"Add as friends"] UserID:[appdelegate.myDetailsManager.userInfoDic objectForKey:@"userDBID"] EventID:nil function:2];
    [self dismissViewControllerAnimated:YES completion:nil];

}
@end
