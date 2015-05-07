//
//  springboardIconCell.h
//  LEH
//
//  Created by Desmond on 25/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AQGridViewCell.h"

@interface springboardIconCell : AQGridViewCell
{
    UIImageView * _iconView;
}

@property (nonatomic, retain) UIImage * icon;
@property (nonatomic, retain) UILabel * title;

@end
