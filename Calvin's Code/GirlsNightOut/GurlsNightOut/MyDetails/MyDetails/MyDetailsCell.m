//
//  MyDetailsCell.m
//  GurlsNightOut
//
//  Created by Calvin on 5/05/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MyDetailsCell.h"

@implementation MyDetailsCell
@synthesize lbTitle,tfInput,ivShare,ivTitleIcon;

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

@end
