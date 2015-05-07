//
//  imageCaptureViewController.m
//  ARD-D photo booth
//
//  Created by Desmond on 28/06/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "imageCaptureViewController.h"

@interface imageCaptureViewController ()
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo;
@end

@implementation imageCaptureViewController
@synthesize cameraOverlayView,irisView,previewOverlayView,overlayImgView;
@synthesize captureManager;
@synthesize takePhoto,cancelPhoto,retakePhoto,usePhoto,capturedImage,scanningLabel,changeCamera,selectedOverlay;
@synthesize HUD;


#pragma mark - Image Capture
-(void)showImagePreview
{   
    [HUD hide:YES];
    
    //[self.scanningLabel setHidden:YES];
    
    self.cancelPhoto.hidden= YES;
    self.takePhoto.hidden = YES;
    self.cameraOverlayView.hidden = YES;
    self.irisView.hidden = YES;
    
    self.usePhoto.hidden = NO;
    self.retakePhoto.hidden = NO;
    self.previewOverlayView.hidden = NO;
    
    [[captureManager captureSession] stopRunning];
    
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    
    //load an image to show in the overlay
    //UIImageView *overlayImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 480)];
    
    //add a simple button to the overview
    self.retakePhoto = [UIButton buttonWithType:UIButtonTypeCustom];        
    UIImage *retakePhotoButtonNormal;
    UIImage *retakePhotoButtonPress;
    
    self.usePhoto = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *usePhotoButtonNormal;
    UIImage *usePhotoPhotoButtonPress;
    
    if (orientation == UIDeviceOrientationPortrait ) {
        
//        [self.captureManager.previewLayer setOrientation:AVCaptureVideoOrientationPortrait];
        [self.captureManager.previewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];

        //Portrait
        
        [self.retakePhoto  setFrame:CGRectMake(210, 415, 101, 41)];
        [self.retakePhoto setBackgroundColor:[UIColor clearColor]];
        
        retakePhotoButtonNormal = [UIImage imageNamed:@"retake-dormant.png"];
        retakePhotoButtonPress = [UIImage imageNamed:@"retake-active.png"];
        
        [self.usePhoto setFrame:CGRectMake(5, 415, 101, 41)];
        [self.usePhoto setBackgroundColor:[UIColor clearColor]];
        
        usePhotoButtonNormal = [UIImage imageNamed:@"use-dormant.png"];
        usePhotoPhotoButtonPress = [UIImage imageNamed:@"use-active.png"];     
    }
       
    if (frontCam) 
    {   
        if (orientation == UIInterfaceOrientationPortrait) 
        {
            UIImage * flippedImage = [UIImage imageWithCGImage:[[self captureManager] stillImage].CGImage scale:[[self captureManager] stillImage].scale orientation:UIImageOrientationLeftMirrored];
            self.capturedImage.image = flippedImage;
            //[self.capturedImage setContentMode:UIViewContentModeScaleAspectFit];
            
        }
    }
    else 
    {
        self.capturedImage.image = [[self captureManager] stillImage];
    }
    
    [retakePhoto setBackgroundImage:retakePhotoButtonNormal forState:UIControlStateNormal];
    [retakePhoto setBackgroundImage:retakePhotoButtonPress forState:UIControlStateHighlighted];
    [retakePhoto addTarget:self action:@selector(retakePhotoAgain) forControlEvents:UIControlEventTouchUpInside];
    
    [usePhoto setBackgroundImage:usePhotoButtonNormal forState:UIControlStateNormal];
    [usePhoto setBackgroundImage:usePhotoPhotoButtonPress forState:UIControlStateHighlighted];
    [usePhoto addTarget:self action:@selector(usingPhoto) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *toolBar=[[UIView alloc] initWithFrame:CGRectMake(0, 410, 320,70)];
    [toolBar setBackgroundColor:[UIColor blackColor]];
    
    [self.previewOverlayView addSubview:self.capturedImage];
    [self.previewOverlayView addSubview:overlayImgView];
    [self.previewOverlayView addSubview:toolBar];
    [self.previewOverlayView addSubview:retakePhoto];   
    [self.previewOverlayView addSubview:usePhoto];  

    [self.view addSubview:self.previewOverlayView];
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"captureToPhotoBooth"]) 
    {
        NSLog(@"imgView %.2f ,%.2f",self.capturedImage.image.size.width, self.capturedImage.image.size.height);  

        photoBoothViewController *imageChall = [segue destinationViewController];
        imageChall.imageCaptured = self.capturedImage.image;
        imageChall.selectedOverlay=[NSString stringWithFormat:@"%@",[self selectedOverlay]];
    }
}

//retake photo hide preview
-(void)retakePhotoAgain
{
    //NSLog(@"retake Photo");
    self.irisView.hidden = NO;
    
    [self initCameraOverlay];
    
//    self.usePhoto.hidden = YES;
//    self.retakePhoto.hidden = YES;
//    self.previewOverlayView.hidden = YES;
    
    self.cancelPhoto.hidden= NO;
    self.takePhoto.hidden = NO;
    self.cameraOverlayView.hidden = NO;
    
    [[captureManager captureSession] startRunning];
    
    //[self initCameraOverlay];
}

//use photo push to image merge
-(void)usingPhoto
{   
    HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
	HUD.dimBackground = YES;
    HUD.labelText = @"Yeah yeah it's coming";
    
    
    [self saveImageToPhotoAlbum];
    [self performSelector:@selector(pushToEditing) withObject:nil afterDelay:3];
    //NSLog(@"usingPhoto");
}

-(void)pushToEditing
{        
    [self performSegueWithIdentifier:@"captureToPhotoBooth" sender:self];
    [HUD hide:YES];
    self.capturedImage = nil;
        
}

-(void)popView
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)saveImageToPhotoAlbum
{   
    if (frontCam) 
    {
       
            UIImage * flippedImage = [UIImage imageWithCGImage:[[self captureManager] stillImage].CGImage scale:[[self captureManager] stillImage].scale orientation:UIImageOrientationLeftMirrored];
            UIImageWriteToSavedPhotosAlbum(flippedImage, self, @selector(image:didFinishSavingWithError:contextInfo:), nil); 
            
        //UIImageWriteToSavedPhotosAlbum([[self captureManager] stillImage], self, @selector(image:didFinishSavingWithError:contextInfo:), nil);

    }
    else 
    {
        UIImageWriteToSavedPhotosAlbum([[self captureManager] stillImage], self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
    }
    
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    if (error != NULL) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error!" message:@"Image couldn't be saved" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
        
        NSLog(@"error %@",error);
    }
    else 
    {
        //[[self scanningLabel] setHidden:YES];
    }
}

-(void)initCameraOverlay
{    
    [self setCaptureManager:[[CaptureSessionManager alloc] init]];    
    [[self captureManager] addStillImageOutput];    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showImagePreview) name:kImageCapturedSuccessfully object:nil];    
	[[self captureManager] addVideoInput];    
	[[self captureManager] addVideoPreviewLayer];
	//CGRect layerRect = [[[self view] layer] bounds];
    CGRect layerRect = CGRectMake(0, 0, 320, 430);//425
	[[[self captureManager] previewLayer] setBounds:layerRect];
	[[[self captureManager] previewLayer] setPosition:CGPointMake(CGRectGetMidX(layerRect),
                                                                  CGRectGetMidY(layerRect))];    
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation; 
    
    //load an image to show in the overlay
    //UIImageView *overlayImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 480)];  
    
    //add a simple button to the overview
    self.takePhoto = [UIButton buttonWithType:UIButtonTypeCustom];        
    UIImage *takePhotoButtonNormal;
    UIImage *takePhotoButtonPress;
    
    self.cancelPhoto = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *cancelButtonNormal;
    UIImage *cancelPhotoButtonPress;
    
    self.changeCamera = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *changeCamButtonNormal;
    
    if (orientation == UIDeviceOrientationPortrait ) 
    {
        
        NSLog(@"UIDeviceOrientationPortrait");
//        [self.captureManager.previewLayer setOrientation:AVCaptureVideoOrientationPortrait];
        [self.captureManager.previewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
        
        //Portrait
                    
        [takePhoto  setFrame:CGRectMake(125, 415, 193, 41)];
        [takePhoto setBackgroundColor:[UIColor clearColor]];
        
        takePhotoButtonNormal = [UIImage imageNamed:@"take-photo-dormant.png"];
        takePhotoButtonPress = [UIImage imageNamed:@"take-photo-active.png"];
        
        [cancelPhoto setFrame:CGRectMake(5, 415, 101, 41)];
        [cancelPhoto setBackgroundColor:[UIColor clearColor]];
        
        cancelButtonNormal = [UIImage imageNamed:@"cancel-dormant.png"];
        cancelPhotoButtonPress = [UIImage imageNamed:@"cancel-active.png"];
        
        [changeCamera setFrame:CGRectMake(250, 20, 67, 34)];
        [changeCamera setBackgroundColor:[UIColor clearColor]];
        
        changeCamButtonNormal = [UIImage imageNamed:@"camera-flip.png"];
    }
    
    
    [[[self cameraOverlayView] layer] addSublayer:[[self captureManager] previewLayer]];
    
    [takePhoto setBackgroundImage:takePhotoButtonNormal forState:UIControlStateNormal];
    //[takePhoto setBackgroundImage:takePhotoButtonPress forState:UIControlStateHighlighted];
    [takePhoto addTarget:self action:@selector(takingPhoto) forControlEvents:UIControlEventTouchUpInside];
    
    [cancelPhoto setBackgroundImage:cancelButtonNormal forState:UIControlStateNormal];
    //[cancelPhoto setBackgroundImage:cancelPhotoButtonPress forState:UIControlStateHighlighted];
    [cancelPhoto addTarget:self action:@selector(cancelTakingPhoto) forControlEvents:UIControlEventTouchUpInside];
    
    [changeCamera setBackgroundImage:changeCamButtonNormal forState:UIControlStateNormal];
    [changeCamera addTarget:self action:@selector(changeCam) forControlEvents:UIControlEventTouchUpInside];  
    
    UIView *toolBar=[[UIView alloc] initWithFrame:CGRectMake(0, 410, 320,70)];
    [toolBar setBackgroundColor:[UIColor blackColor]];
    [self.cameraOverlayView addSubview:toolBar];
    
    [self.cameraOverlayView addSubview:overlayImgView];
    [self.cameraOverlayView addSubview:changeCamera];
    [self.cameraOverlayView addSubview:takePhoto];   
    [self.cameraOverlayView addSubview:cancelPhoto];

    [self.view addSubview:cameraOverlayView];
    [[captureManager captureSession] startRunning];
    //[[self view] addSubview:scanningLabel];
}

//change front or back camera
-(void)changeCam
{   
    //NSLog(@"before frontCam %i",frontCam);
    frontCam = !frontCam;
    
    //NSLog(@"after frontCam %i",frontCam);    
    
    [captureManager changeView];
}

//take photo
-(void)takingPhoto
{   
    NSLog(@"pict called");
    //[[self scanningLabel] setHidden:NO];
    [[self captureManager] captureStillImage];
    if (!frontCam) 
    {
        HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        HUD.dimBackground = YES;
        HUD.labelText = @"Prepare to save captain!";        
    }
        
}

//cancel taking go back to scanner
-(void)cancelTakingPhoto
{
    //NSLog(@"cancelTakingPhoto");
    [[captureManager captureSession] stopRunning];    
    captureManager.previewLayer=nil;
    captureManager.captureSession =nil;
    
    
    [UIView transitionWithView:self.navigationController.view duration:0.5
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:^{
                        [self.navigationController popViewControllerAnimated:NO];
                    }
                    completion:^(BOOL  completed)
     {     
         if (completed) 
         {
             return ;
         }
     }                      
     ];

    
    
    
   
       NSLog(@"called");    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    frontCam =1;
    
    //NSLog(@"From Sample ? %i",fromSample);
    
	// Do any additional setup after loading the view.
    self.cameraOverlayView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 460)];
    self.previewOverlayView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 460)];
    self.capturedImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 430)];
    [self.capturedImage setContentMode:UIViewContentModeScaleAspectFill];
       
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(detectOrientation) name:@"UIDeviceOrientationDidChangeNotification" object:nil];   
    if(![self.selectedOverlay isEqualToString:@"OverLay00.png"])
    {
        self.overlayImgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 410)];
        self.overlayImgView.image = [UIImage imageNamed:self.selectedOverlay];///////////////////////////////////selected overlay put here
    }

    [self performSelector:@selector(initCameraOverlay) withObject:nil afterDelay:0.1];
    
}

-(void)viewDidDisappear:(BOOL)animated
{
    [[captureManager captureSession] stopRunning];
    
    self.captureManager.previewLayer=nil;
    self.captureManager.captureSession =nil;
    
    self.cameraOverlayView=nil;
    self.previewOverlayView=nil;
    self.irisView=nil;
    self.capturedImage=nil;
    self.takePhoto=nil;
    self.cancelPhoto=nil;
    self.changeCamera=nil;
    self.retakePhoto=nil;
    self.usePhoto=nil;
    self.scanningLabel=nil;
    //NSLog(@"img capture view viewDidDisappear");  
    [super viewDidDisappear:animated];
    
    
}

- (void)viewDidUnload
{
    // Release any retained subviews of the main view.
    [[captureManager captureSession] stopRunning];
    
    self.captureManager.previewLayer=nil;
    self.captureManager.captureSession =nil;
    
    self.cameraOverlayView=nil;
    self.previewOverlayView=nil;
    self.irisView=nil;
    self.capturedImage=nil;
    self.takePhoto=nil;
    self.cancelPhoto=nil;
    self.changeCamera=nil;
    self.retakePhoto=nil;
    self.usePhoto=nil;
    self.scanningLabel=nil;
    //NSLog(@"img capture view viewDidUnload");
    [super viewDidUnload];
    
    
    
}


#pragma mark -
#pragma mark MBProgressHUDDelegate methods

- (void)hudWasHidden:(MBProgressHUD *)hud {
    // Remove HUD from screen when the HUD was hidded
    [HUD removeFromSuperview];
	HUD = nil;
}

@end
