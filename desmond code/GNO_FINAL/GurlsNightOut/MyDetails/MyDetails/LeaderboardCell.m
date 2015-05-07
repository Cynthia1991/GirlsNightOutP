//
//  LeaderboardCell.m
//  GurlsNightOut
//
//  Created by Calvin on 8/05/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "LeaderboardCell.h"

@implementation LeaderboardCell
@synthesize lbFirst,lbSecond,lbThird,lbFirstPoint,lbSecondPoint,lbThirdPoint;

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
