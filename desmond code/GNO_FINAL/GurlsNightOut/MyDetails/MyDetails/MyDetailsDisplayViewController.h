//
//  MyDetailsDisplayViewController.h
//  GurlsNightOut
//
//  Created by calvin on 3/05/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "MyDetailsManager.h"
#import "AppDelegate.h"
#import <MediaPlayer/MediaPlayer.h>
#import "Kumulos.h"


@interface MyDetailsDisplayViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,KumulosDelegate,UIScrollViewDelegate>
{
    AppDelegate *appDelegate;
    
    //take photo
    MPMoviePlayerController *moviePlayerController;
    UIImage *image;
    NSString *lastChosenMediaType;
    CGRect imageFrame;
    Boolean isUpload;
    
    
}
@property (strong, nonatomic) IBOutlet UIButton *btPhoto;
@property (strong, nonatomic) IBOutlet UILabel *lbUserName;
@property (strong, nonatomic) IBOutlet UITableView *_tableView;
@property (strong, nonatomic) IBOutlet UIImageView *myIconBackground;
@property (weak, nonatomic) IBOutlet UIImageView *ivIcon;
@property (strong, nonatomic) NSMutableDictionary *friendsDetialDic;
@property (nonatomic) NSInteger function;//0=my details,1=friends
@property (weak, nonatomic) IBOutlet UIButton *btMyDetail;
@property (weak, nonatomic) IBOutlet UIButton *btMyFriends;
@property (weak, nonatomic) IBOutlet UIView *maskView;
@property (strong, nonatomic) IBOutlet UIScrollView *scvInstruction;

- (IBAction)btBackAction:(id)sender;
- (IBAction)btPhotoAction:(id)sender;
- (void)updateDisplay;
- (void)getMediaFromSource:(UIImagePickerControllerSourceType)sourceType;
static UIImage *shrinkImage(UIImage *original, CGSize size, NSInteger function);

@end
