//
//  EventMainPagePTableCell.m
//  gno
//
//  Created by Calvin on 31/07/12.
//
//

#import "EventMainPagePTableCell.h"

@implementation EventMainPagePTableCell
@synthesize ivIcon,lbName,lbPostContent,lbPostTime,ivPhoto,btCommentDisplay,btLikeDisplay,btComment,btLike,postID,eventID,timelineCellKumulos,lbLikeDisplay,lbCommentDisplay,userID,commentArray,likeArray,vCommentDisplay,vLikeDisplay,ivBackground1;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)LikeAction:(id)sender
{
    [self.timelineCellKumulos createLike];
    self.btLike.enabled=NO;
}

- (IBAction)CommentAction:(id)sender
{
    NSMutableDictionary *dic=[[NSMutableDictionary alloc] init];
    [dic setObject:[self userID] forKey:@"userID"];
    [dic setObject:[self postID] forKey:@"postID"];
    [dic setObject:[self eventID] forKey:@"eventID"];
    [dic setObject:[NSString stringWithFormat:@"2"] forKey:@"cellType"];
    [dic setObject:self forKey:@"cell"];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"popup add comment view" object:dic];

}
- (void)initKumulos
{
    self.timelineCellKumulos=[[TimelineCellKumulos alloc] initByEventPostID:self.postID EventID:self.eventID];
    
    self.ivPhoto.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImageFunction:)];
    tapRecognizer.numberOfTouchesRequired = 1;
    
    [self.ivPhoto addGestureRecognizer:tapRecognizer];
    
}
- (IBAction)CommentDetailsAction:(id)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"view comment detail" object:commentArray];
}
- (IBAction)LikeDetailsAction:(id)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"view like detail" object:likeArray];
}

-(void)tapImageFunction:(UITapGestureRecognizer *)recognizer//long press detect
{
    if(UIGestureRecognizerStateBegan == recognizer.state) {
        NSLog(@"UIGestureRecognizerStateBegan");
    }
    
    if(UIGestureRecognizerStateChanged == recognizer.state) {
        // Do repeated work here (repeats continuously) while finger is down
        NSLog(@"UIGestureRecognizerStateChanged");
    }
    
    if(UIGestureRecognizerStateEnded == recognizer.state) {
        // Do end work here when finger is lifted
        NSLog(@"UIGestureRecognizerStateEnded");
        UIImageView *imgView=[[UIImageView alloc] initWithImage:self.ivPhoto.image];
        CGRect rr = [self.superview.superview convertRect:self.ivPhoto.frame fromView:self];
        imgView.frame=rr;
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"pop timeline image" object:imgView];
    }
    
    
}
@end
