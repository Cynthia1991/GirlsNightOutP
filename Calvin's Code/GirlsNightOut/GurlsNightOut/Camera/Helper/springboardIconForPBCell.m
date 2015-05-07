//
//  springboardIconCell.m
//  photoBooth
//
//  Created by Desmond on 11/08/12.
//
//

#import "springboardIconForPBCell.h"

@implementation springboardIconForPBCell

@synthesize title;

- (id) initWithFrame: (CGRect) frame reuseIdentifier:(NSString *) reuseIdentifier
{
    self = [super initWithFrame: frame reuseIdentifier: reuseIdentifier];
    if ( self == nil )
        return ( nil );
    
    //    UIBezierPath * path = [UIBezierPath bezierPathWithRoundedRect: CGRectMake(0.0, 0.0, 72.0, 72.0)
    //                                                     cornerRadius: 18.0 125 180];
    
    _iconView = [[UIImageView alloc] initWithFrame: CGRectMake(13.0, 12.0, 125,180)];
    _iconView.contentMode = UIViewContentModeScaleAspectFit;
    _iconView.backgroundColor = [UIColor clearColor];
    _iconView.opaque = NO;
    //    _iconView.layer.shadowPath = path.CGPath;
    //    _iconView.layer.shadowRadius = 20.0;
    //    _iconView.layer.shadowOpacity = 0.4;
    //    _iconView.layer.shadowOffset = CGSizeMake( 20.0, 20.0 );
    
    [self.contentView addSubview: _iconView];
	
	title = [[UILabel alloc] initWithFrame: CGRectMake(10.0, 81.0, 70.0, 16.0)];
	title.textColor = [UIColor whiteColor];
	title.font = [UIFont boldSystemFontOfSize:14.0];
    title.adjustsFontSizeToFitWidth = YES;
	title.textAlignment = UITextAlignmentCenter;
	title.backgroundColor = [UIColor clearColor];
	[self.contentView addSubview:title];
    
    self.contentView.backgroundColor = [UIColor clearColor];
    self.backgroundColor = [UIColor scrollViewTexturedBackgroundColor];
    
    self.contentView.opaque = NO;
    self.opaque = NO;
    
    self.selectionStyle = AQGridViewCellSelectionStyleNone;
    
    return ( self );
}

- (UIImage *) icon
{
    return ( _iconView.image );
}

- (void) setIcon: (UIImage *) anIcon
{
    _iconView.image = anIcon;
}

- (CALayer *) glowSelectionLayer
{
    return ( _iconView.layer );
}

- (void) layoutSubviews
{
    [super layoutSubviews];
    
    CGSize imageSize = _iconView.image.size;
    CGRect frame = _iconView.frame;
    CGRect bounds = self.contentView.bounds;
    
    if ( (imageSize.width <= bounds.size.width) &&
		(imageSize.height <= bounds.size.height) )
    {
        return;
    }
    
    // scale it down to fit
    CGFloat hRatio = bounds.size.width / imageSize.width;
    CGFloat vRatio = bounds.size.height / imageSize.height;
    CGFloat ratio = MAX(hRatio, vRatio);
    
    frame.size.width = floorf(imageSize.width * ratio);
    frame.size.height = floorf(imageSize.height * ratio);
    frame.origin.x = floorf((bounds.size.width - frame.size.width) * 0.5);
    frame.origin.y = floorf((bounds.size.height - frame.size.height) * 0.5);
    _iconView.frame = frame;
}

@end

