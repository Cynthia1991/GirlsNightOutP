//
//  FriendsListTableCell.m
//  gno
//
//  Created by calvin on 16/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "FriendsListTableCell.h"

@implementation FriendsListTableCell
@synthesize lbTitle,lbSubTitle,ivIcon,checkIcon,ivArrow;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        lbSubTitle.textColor=[UIColor grayColor];
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
