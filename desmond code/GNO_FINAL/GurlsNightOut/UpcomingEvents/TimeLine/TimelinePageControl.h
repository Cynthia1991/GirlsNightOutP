//
//  TimelinePageControl.h
//  gno
//
//  Created by calvin on 5/06/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TimelinePageControl : UIPageControl
{
    UIImage* activeImage;
    UIImage* inactiveImage;
}
-(void) updateDots;

@end
