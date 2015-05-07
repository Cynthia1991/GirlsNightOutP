//
//  EventListCell.m
//  GurlsNightOut
//
//  Created by Calvin on 7/04/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "EventListCell.h"

@implementation EventListCell
@synthesize title,time,location,tfDetail,ivIndicator,ivEventPhoto;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void) initCell
{
    UIImageView *cellBgImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"CellBackground.png"]];
    [self setBackgroundView:cellBgImageView];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

@end
