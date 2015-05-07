//
//  EventMainPageTableCell.m
//  gno
//
//  Created by Calvin on 31/07/12.
//
//

#import "EventMainPageTableCell.h"

@implementation EventMainPageTableCell
@synthesize ivIcon,lbName,lbPostContent,lbPostTime,ivBackground1,btCommentDisplay,btLikeDisplay,btComment,btLike,postID,eventID,timelineCellKumulos,lbLikeDisplay,lbCommentDisplay,userID,commentArray,likeArray,vCommentDisplay,vLikeDisplay,vBottom;

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
    [timelineCellKumulos createLike];
    self.btLike.enabled=NO;
}

- (IBAction)CommentAction:(id)sender
{
    NSMutableDictionary *dic=[[NSMutableDictionary alloc] init];
    [dic setObject:[self userID] forKey:@"userID"];
    [dic setObject:[self postID] forKey:@"postID"];
    [dic setObject:[self eventID] forKey:@"eventID"];
    [dic setObject:[NSString stringWithFormat:@"0"] forKey:@"cellType"];
    [dic setObject:self forKey:@"cell"];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"popup add comment view" object:dic];

}
- (void)initKumulos
{
    timelineCellKumulos=[[TimelineCellKumulos alloc] initByEventPostID:self.postID EventID:self.eventID];
}
- (IBAction)CommentDetailsAction:(id)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"view comment detail" object:commentArray];
}
- (IBAction)LikeDetailsAction:(id)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"view like detail" object:likeArray];
}
@end
