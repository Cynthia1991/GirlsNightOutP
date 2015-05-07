//
//  ACStatusBarOverlayWindow.h
//  gno
//
//  Created by Calvin on 30/08/12.
//
//

#import <UIKit/UIKit.h>

@protocol ACStatusBarOverlayWindowDelegate;


@interface ACStatusBarOverlayWindow : UIWindow
{
    UIView *backgroundView;
    UIView *view;
}
@property (nonatomic, unsafe_unretained) id<ACStatusBarOverlayWindowDelegate> delegate;

- (void) setHide;
- (void)contentViewClicked:(UITapGestureRecognizer *)gestureRecognizer;


@end

@protocol ACStatusBarOverlayWindowDelegate <NSObject>
@optional
// is called, when a gesture on the overlay is recognized
- (void)statusBarOverlayDidRecognizeGesture:(UIGestureRecognizer *)gestureRecognizer;
@end