//
//  FindFriendDetailsViewController.h
//  gno
//
//  Created by Calvin on 6/09/12.
//
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface FindFriendDetailsViewController : UIViewController<KumulosDelegate>
{
    AppDelegate *appdelegate;
}
@property (strong, nonatomic) NSString *friendName;
@property (strong, nonatomic) NSString *friendUserDBID;
@property (strong, nonatomic) NSString *friendPhotoDBID;
@property (strong, nonatomic) NSMutableDictionary *friendDic;
@property (strong, nonatomic) UIImage *friendIcon;

@property (strong, nonatomic) IBOutlet UIImageView *friendsImage;
@property (strong, nonatomic) IBOutlet UILabel *lbFriendsName;
@property (weak, nonatomic) IBOutlet UIImageView *ivIconBackground;
- (IBAction)addFirendAction:(id)sender;
- (IBAction)backAction:(id)sender;
@end
