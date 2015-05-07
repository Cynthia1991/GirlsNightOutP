//
//  photoBoothViewController.h
//  photoBooth
//
//  Created by Desmond on 28/06/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "MBProgressHUD.h"
#import "Kumulos.h"
#import "AppDelegate.h"
#import "AFPhotoEditorController.h"

@interface photoBoothViewController : UIViewController <UIGestureRecognizerDelegate,UIAlertViewDelegate,KumulosDelegate,MBProgressHUDDelegate,AFPhotoEditorControllerDelegate>
{    
    CGFloat lastScale;
	CGFloat lastRotation;
    
	CGFloat firstX;
	CGFloat firstY;
    
    
    BOOL saved;
    
    AppDelegate *appDelegate;
}
@property (strong,nonatomic) MBProgressHUD *HUD;

//overlay image view
@property (weak, nonatomic) IBOutlet UIImageView *imageOverlay;

@property (strong, nonatomic) UIImage *imageCaptured;

@property (strong, nonatomic) UIImage *savedImage;
@property (strong, nonatomic) NSString *savedImageFrame;

//passing image captured to img view
@property (weak, nonatomic) IBOutlet UIImageView *imgView;


//@property (weak, nonatomic) IBOutlet UIImageView *baseImgView;

//saving image button
@property (weak, nonatomic) IBOutlet UIButton *saveImage;

//scroll view for image saving
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

//saving view
@property (weak, nonatomic) IBOutlet UIView *viewForImg;
@property (strong,nonatomic)NSString *selectedOverlay;

- (IBAction)saveImage:(id)sender;
- (IBAction)cancelBut:(id)sender;
- (void)saveSuccess;
- (void)pushToSuccess;
- (void)pushToFail;
- (void)rotate:(UIRotationGestureRecognizer *)recognizer;
- (void)scale:(UIPinchGestureRecognizer *)recognizer;
- (void)move:(UIPanGestureRecognizer *)recognizer;
- (UIImage*) maskImage:(UIImageView *)image withMask:(UIImageView *)cropImage;
- (void)setUpImageGuesture;
- (void) dismissMySelf:(NSNotification*) notification;


@end
