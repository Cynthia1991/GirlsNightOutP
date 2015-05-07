//
//  imageCaptureViewController.h
//  ARD-D photo booth
//
//  Created by Desmond on 28/06/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CaptureSessionManager.h"
#import <AVFoundation/AVFoundation.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "photoBoothViewController.h"

@interface imageCaptureViewController : UIViewController
{
    BOOL frontCam;
    
    
}
@property (strong,nonatomic)MBProgressHUD *HUD;

//for camera view
@property CaptureSessionManager *captureManager;
@property (strong,nonatomic) UIView *cameraOverlayView;
@property (strong,nonatomic) UIView *previewOverlayView;
@property (weak,nonatomic) IBOutlet UIView *irisView;
@property (strong,nonatomic) UIImageView *capturedImage;
@property (strong,nonatomic) UIImageView *overlayImgView;
@property (strong,nonatomic) UIButton *takePhoto;
@property (strong,nonatomic) UIButton *cancelPhoto;
@property (strong,nonatomic) UIButton *changeCamera;
@property (strong,nonatomic) UIButton *retakePhoto;
@property (strong,nonatomic) UIButton *usePhoto;
@property (weak,nonatomic) UILabel *scanningLabel;
@property (strong,nonatomic)NSString *selectedOverlay;

-(void)changeCam;
-(void)initCameraOverlay;
-(void)showImagePreview;

-(void)cancelTakingPhoto;
-(void)takingPhoto;

-(void)usingPhoto;
-(void)retakePhotoAgain;
-(void)pushToEditing;
 

@end
