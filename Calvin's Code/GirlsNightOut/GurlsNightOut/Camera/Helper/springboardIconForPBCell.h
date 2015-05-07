//
//  springboardIconCell.h
//  photoBooth
//
//  Created by Desmond on 11/08/12.
//
//

#import <UIKit/UIKit.h>
#import "AQGridViewCell.h"

@interface springboardIconForPBCell : AQGridViewCell
{
    UIImageView * _iconView;
}

@property (nonatomic, retain) UIImage * icon;
@property (nonatomic, retain) UILabel * title;

@end

