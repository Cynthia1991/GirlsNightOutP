//
//  ACStatusBarOverlayWindow.m
//  gno
//
//  Created by Calvin on 30/08/12.
//
//

#import "ACStatusBarOverlayWindow.h"

@implementation ACStatusBarOverlayWindow
@synthesize delegate;
- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        // Place the window on the correct level and position
        self.windowLevel = UIWindowLevelStatusBar+1.0f;
        self.frame = [[UIApplication sharedApplication] statusBarFrame];
        
        // Create an image view with an image to make it look like a status bar.
//        UIImageView *backgroundImageView = [[UIImageView alloc] initWithFrame:self.frame];
//        backgroundImageView.image = [[UIImage imageNamed:@"statusBarBackgroundGrey.png"] stretchableImageWithLeftCapWidth:2.0f topCapHeight:0.0f];
        backgroundView=[[UIView alloc] initWithFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, self.frame.size.height)];
        [backgroundView setBackgroundColor:[UIColor clearColor]];

        
//        view=[[UIView alloc] initWithFrame:CGRectMake(320, self.frame.origin.y, self.frame.size.width/2-20, self.frame.size.height)];
//        [view setBackgroundColor:[UIColor redColor]];
//        
//        [UIView beginAnimations:@"describeView" context:nil];
//        [UIView setAnimationDuration:0.5];
//        [view setFrame:CGRectMake(320/2+20, self.frame.origin.y, self.frame.size.width/2-20, self.frame.size.height)];
//        [UIView commitAnimations];
        
        
        UITapGestureRecognizer *hideTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(contentViewClicked:)];
        hideTapRecognizer.numberOfTouchesRequired = 1;
        [backgroundView addGestureRecognizer:hideTapRecognizer];
        
//        [backgroundView addSubview:view];
        [self addSubview:backgroundView];
        
        // TODO: Insert subviews (labels, imageViews, etc...)
    }
    return self;
}

- (void) setHide
{
    [UIView animateWithDuration:0.5
                     animations:^{
                         [view setFrame:CGRectMake(320, self.frame.origin.y, self.frame.size.width/2-20, self.frame.size.height)];
                     }
                     completion:^(BOOL finished){
                         [self setHidden:YES];

                     }
     ];

}

- (void)contentViewClicked:(UITapGestureRecognizer *)gestureRecognizer {
	if (gestureRecognizer.state == UIGestureRecognizerStateEnded) {        
		if ([self.delegate respondsToSelector:@selector(statusBarOverlayDidRecognizeGesture:)]) {
			[self.delegate statusBarOverlayDidRecognizeGesture:gestureRecognizer];
		}
	}
}
@end
