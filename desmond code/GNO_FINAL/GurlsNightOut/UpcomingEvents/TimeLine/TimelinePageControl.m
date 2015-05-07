//
//  TimelinePageControl.m
//  gno
//
//  Created by calvin on 5/06/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TimelinePageControl.h"

@implementation TimelinePageControl

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code

    }
    return self;
}

-(void) updateDots
{
    activeImage = [UIImage imageNamed:@"active_page_image.png"];
    inactiveImage = [UIImage imageNamed:@"inactive_page_image.png"];
    for (int i = 0; i < [self.subviews count]; i++)
    {
        UIImageView* dot = [self.subviews objectAtIndex:i];
        if (i == self.currentPage) dot.image = activeImage;
        else dot.image = inactiveImage;
    }
}

-(void) setCurrentPage:(NSInteger)page
{
    [super setCurrentPage:page];
//    [self updateDots];
}


@end
