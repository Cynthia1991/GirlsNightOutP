//
//  EventMainPageTableCell.h
//  gno
//
//  Created by Calvin on 31/07/12.
//
//

#import <UIKit/UIKit.h>
#import "TimelineCellKumulos.h"

@interface EventMainPageTableCell : UITableViewCell

@property (nonatomic,strong) IBOutlet UIImageView *ivIcon;
@property (nonatomic,strong) IBOutlet UILabel *lbName;
@property (nonatomic,strong) IBOutlet UILabel *lbPostTime;
@property (nonatomic,strong) IBOutlet UILabel *lbPostContent;
@property (nonatomic,strong) IBOutlet UIImageView *ivBackground1;

@property (nonatomic,strong) IBOutlet UILabel *lbLikeDisplay;
@property (nonatomic,strong) IBOutlet UILabel *lbCommentDisplay;

@property (nonatomic,strong) IBOutlet UIButton *btLikeDisplay;
@property (nonatomic,strong) IBOutlet UIButton *btCommentDisplay;
@property (nonatomic,strong) IBOutlet UIButton *btLike;
@property (nonatomic,strong) IBOutlet UIButton *btComment;
@property (nonatomic,strong) IBOutlet UIView *vCommentDisplay;
@property (nonatomic,strong) IBOutlet UIView *vLikeDisplay;
@property (nonatomic,strong) IBOutlet UIView *vBottom;

@property (nonatomic,strong) NSString *postID;
@property (nonatomic,strong) NSString *userID;
@property (nonatomic,strong) NSString *eventID;

@property (nonatomic,strong) TimelineCellKumulos *timelineCellKumulos;
@property (nonatomic,strong) NSMutableArray *commentArray;
@property (nonatomic,strong) NSMutableArray *likeArray;

- (IBAction)LikeAction:(id)sender;
- (IBAction)CommentAction:(id)sender;
- (IBAction)CommentDetailsAction:(id)sender;
- (IBAction)LikeDetailsAction:(id)sender;
- (void)initKumulos;

@end
