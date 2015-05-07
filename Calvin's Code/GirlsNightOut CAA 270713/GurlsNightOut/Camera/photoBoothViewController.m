//
//  photoBoothViewController.m
//  photoBooth
//
//  Created by Desmond on 28/06/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "photoBoothViewController.h"

@interface photoBoothViewController ()

@end

@implementation photoBoothViewController

@synthesize imageOverlay;
@synthesize imageCaptured;

@synthesize imgView;
@synthesize saveImage;
@synthesize scrollView;
@synthesize viewForImg;
@synthesize savedImage,savedImageFrame,selectedOverlay;
@synthesize HUD;

#pragma mark - View lifecycle

- (IBAction)cancelBut:(id)sender
{
    [self pushToFail];
    
}


-(void)pushToFail
{
    
    [self performSelector:@selector(pushToSuccess) withObject:nil afterDelay:0.1];

}


-(void)viewWillAppear:(BOOL)animated
{
    
    if(![self.selectedOverlay isEqualToString:@"OverLay00.png"])
    {
        self.imageOverlay.image = [UIImage imageNamed:self.selectedOverlay];///////////////////////////////////selected overlay put here
    }
}

- (void)viewDidLoad
{   saved =0;
    [super viewDidLoad];
    [self setUpImageGuesture];
    [self.imgView setContentMode:UIViewContentModeScaleAspectFit];
    [self.imgView setImage:self.imageCaptured];
    [self.imgView setFrame:CGRectMake(-3, -3, 323, 429)];
    
    //NSLog(@"From Sample ? %i",fromSample);
    NSLog(@"imgView ? ? %@",self.imageCaptured);  
    NSLog(@"imgView ? ? %@",self.imgView);
    
    appDelegate=(AppDelegate*)[[UIApplication sharedApplication] delegate];
    [[NSNotificationCenter defaultCenter]  addObserver:self selector:@selector(dismissMySelf:) name:@"dismiss my detail photo" object:nil];

}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

-(void)viewDidDisappear:(BOOL)animated
{
    //    [self setImageOverlay:nil];
    //    self.imageCaptured=nil;
    //    self.savedImage=nil;
    //    self.imgView=nil;
    //    self.baseImgView=nil;
    //    self.saveImage=nil;
    //    self.scrollView=nil;
    //    self.viewForImg=nil;
    [super viewDidDisappear:animated];
}

- (void)viewDidUnload
{
    [self setImageOverlay:nil];
    self.imageCaptured=nil;
    self.savedImage=nil;
    self.imgView=nil;
    self.saveImage=nil;
    self.scrollView=nil;
    self.viewForImg=nil;
    
    [super viewDidUnload];
    // Release any retained subviews of the main view.   
}

#pragma mark - Saving Image

- (IBAction)saveImage:(id)sender {
    ////////////////////////////////////////////
    self.imageOverlay.alpha = 1;
    self.savedImage = [self maskImage:self.imgView withMask:self.imageOverlay];
    if (self.savedImage.size.width>self.savedImage.size.height) {
        self.savedImageFrame=[NSString stringWithFormat:@"2"];
    }
    else {
        self.savedImageFrame=[NSString stringWithFormat:@"1"];
    }
    ////////////////////////////////////////////
    AFPhotoEditorController *editorController = [[AFPhotoEditorController alloc] initWithImage:self.savedImage];
    [editorController setDelegate:self];
    [self.navigationController pushViewController:editorController animated:YES];
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"dismiss my detail photo" object:nil];


}
- (void)photoEditor:(AFPhotoEditorController *)editor finishedWithImage:(UIImage *)image
{
    self.savedImage=image;
    [self.navigationController popViewControllerAnimated:YES];
    // Handle the result image here
    ////////////////////////////////////////////
    
    if (HUD)
    {
        [HUD removeFromSuperview];
        HUD = nil;
    }
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:HUD];
    [self.view bringSubviewToFront:HUD];
    HUD.delegate = self;
    HUD.labelText = @"It's saving!";
    [HUD show:YES];
    [HUD hide:YES afterDelay:30];
    
    ////////////////////////////////////////////
    NSData *largeImageData = UIImageJPEGRepresentation(self.savedImage, 1.0);
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([[defaults objectForKey:@"addPhotosFunction"] intValue]==1) {
        
        ///////////////////////////
        UIImage *shrunkenLargeImage;
        shrunkenLargeImage = shrinkImage(self.savedImage, CGSizeMake(200, 200),0);
        ///////////////////////////
        [[appDelegate myDetailsManager] saveUserIconByImage:shrunkenLargeImage];
    }
    else if ([[defaults objectForKey:@"addPhotosFunction"] intValue]==2){
        NSString *eventDBID=[NSString stringWithFormat:@"%@",[defaults objectForKey:@"addPhotoByEventDBID"]];
        [[appDelegate eventsManager] saveEventImage:self.savedImage EventDBID:[eventDBID intValue]];
    }
    else{
        Kumulos *k=[[Kumulos alloc] init];
        [k setDelegate:self];
        [k uploadPhotosWithPhotoValue:largeImageData andTextValue:self.savedImageFrame andLargePhotoValue:nil];
        
    }
    
    ////////////////////////////////
    UIImageWriteToSavedPhotosAlbum(self.savedImage, self, @selector(imageSavedToPhotosAlbum: didFinishSavingWithError: contextInfo:), nil);
}

- (void)photoEditorCanceled:(AFPhotoEditorController *)editor
{
    // Handle cancelation here
    [self dismissModalViewControllerAnimated:YES];
}

-(void)saveSuccess
{
    [self performSelector:@selector(pushToSuccess) withObject:nil afterDelay:0.1];
    
}

-(void)pushToSuccess
{
    
    [UIView transitionWithView:self.navigationController.view duration:0.5
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:^{
                        [self.navigationController popToRootViewControllerAnimated:NO];
                    }
                    completion:^(BOOL  completed)
     {     
         if (completed) 
         {
             return ;
         }
         //[sourceVC.navigationController pushViewController:destinationVC animated:NO];
     }                      
     ];

    
    
    
    self.imageCaptured = nil;
    
    self.savedImage = nil;
    
    self.imgView = nil;
    
    self.imageOverlay = nil;    
    
}

-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 12) 
    {        
        if (buttonIndex == 0) 
        {	
            //NSLog(@"11111");
            [[NSNotificationCenter defaultCenter] postNotificationName:                     
             @"UIApplicationMemoryWarningNotification" object:[UIApplication sharedApplication]];
            
            self.imageCaptured = nil;
            
            self.savedImage = nil;
            
            self.imgView = nil;
            
            self.imageOverlay = nil;
        }       
    }
}


- (void)imageSavedToPhotosAlbum:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    
    NSString *message;
    NSString *title;
    
    if (!error) {
        title = NSLocalizedString(@"Save Success", @"");
        message = NSLocalizedString(@"Save Success Message", @"");
        
        if (HUD)
        {
            [HUD removeFromSuperview];
            HUD = nil;
        }
        HUD = [[MBProgressHUD alloc] initWithView:self.view];
        [self.view addSubview:HUD];
        [self.view bringSubviewToFront:HUD];
        HUD.delegate = self;
        HUD.labelText = @"Uploading";
        [HUD show:YES];
        [HUD hide:YES afterDelay:30];

       
        saved =1;
        self.imageOverlay.alpha =0.85;
        
        
    } else 
    {
        title = NSLocalizedString(@"Save Failed", @"");
        message = [error description];
        NSLog(@"error %@",message);
        
        if (HUD)
        {
            [HUD removeFromSuperview];
            HUD = nil;
        }
        HUD = [[MBProgressHUD alloc] initWithView:self.view];
        [self.view addSubview:HUD];
        [self.view bringSubviewToFront:HUD];
        HUD.delegate = self;
        HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"sad_face.png"]];
        HUD.mode = MBProgressHUDModeCustomView;
        HUD.labelText = @"Error! Try saving photo again :p";
        [HUD show:YES];
        [HUD hide:YES afterDelay:30];

        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error Saving Done"
                                                        message:message
                                                       delegate:self
                                              cancelButtonTitle:@"ok" 
                                              otherButtonTitles:nil];
        [alert show];       
        
    }
}

- (UIImage*) maskImage:(UIImageView *)maskImage withMask:(UIImageView *)cropImage
{
    
    //UIImage *image = nil;
    //UIImage *imagePNG = nil;
    NSLog(@"image width:%.2f, heigh:%.2f", maskImage.frame.size.width, maskImage.frame.size.height);
    NSLog(@"layer width:%.2f, heigh:%.2f", cropImage.frame.size.width, cropImage.frame.size.height);
    NSLog(@"crop Img value %@",cropImage);
    NSLog(@"mask Img value %@",maskImage);
    
    //CGSize newImageSize = CGSizeMake(cropImage.frame.size.width, cropImage.frame.size.height);
    CGSize newImageSize = CGSizeMake(320, 415);//////////////////////////////////////////////////////////////////////////////////////created photo size
    NSLog(@"CGSize %@",NSStringFromCGSize(newImageSize));
    
    UIGraphicsBeginImageContextWithOptions(newImageSize, NO, 0.0); //retina res
    [self.viewForImg.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();  
    
    NSData *imgData =  UIImageJPEGRepresentation(image, 0.9); //UIImagePNGRepresentation ( image ); // get JPEG representation
    UIImage * imagePNG = [UIImage imageWithData:imgData]; // wrap UIImage around PNG representation
    
    UIGraphicsEndImageContext();  
    return imagePNG;
}

#pragma mark -
#pragma mark gesture

-(void)setUpImageGuesture
{    
    // -----------------------------
    // Two finger rotate
    // -----------------------------
    UIRotationGestureRecognizer *twoFingersRotate =
    [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(rotate:)];
    twoFingersRotate.delegate =self;
    [self.scrollView addGestureRecognizer:twoFingersRotate];
    
    
    // -----------------------------
    // Two finger pinch
    // -----------------------------
    UIPinchGestureRecognizer *twoFingerPinch =
    [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(scale:)];
    twoFingersRotate.delegate=self;
    [self.scrollView addGestureRecognizer:twoFingerPinch];
    
    // -----------------------------
    // one finger Move
    // -----------------------------
    
    UIPanGestureRecognizer *panRecognizer = 
    [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(move:)];
    panRecognizer.delegate=self;
    [panRecognizer setMinimumNumberOfTouches:1];
    [panRecognizer setMaximumNumberOfTouches:1];
    //[panRecognizer setDelegate:self];
    [self.scrollView addGestureRecognizer:panRecognizer];
    
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    
	return ![gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]];
}

- (void)rotate:(UIRotationGestureRecognizer *)recognizer
{   saved =0;
    // Convert the radian value to show the degree of rotation
    //NSLog(@"Rotation in degrees since last change: %f", [recognizer rotation] * (180 / M_PI));
    
	if([(UIRotationGestureRecognizer*)recognizer state] == UIGestureRecognizerStateEnded) {
        
		lastRotation = 0.0;
		return;
	}
    
	CGFloat rotation = 0.0 - (lastRotation - [(UIRotationGestureRecognizer*)recognizer rotation]);
    
	CGAffineTransform currentTransform = [(UIPinchGestureRecognizer*)recognizer view].transform;
	CGAffineTransform newTransform = CGAffineTransformRotate(currentTransform,rotation);
    
	[[(UIRotationGestureRecognizer*)recognizer view] setTransform:newTransform];
    
	lastRotation = [(UIRotationGestureRecognizer*)recognizer rotation];
}

/*--------------------------------------------------------------
 * Two finger zoom
 *-------------------------------------------------------------*/
- (void)scale:(UIPinchGestureRecognizer *)recognizer
{   
    saved =0;
    //NSLog(@"Pinch scale: %f", recognizer.scale);
    
    //[self.view bringSubviewToFront:[(UIPinchGestureRecognizer*)recognizer view]];
    
	if([(UIPinchGestureRecognizer*)recognizer state] == UIGestureRecognizerStateEnded) {
        
		lastScale = 1.0;
		return;
	}
    
	CGFloat scale = 1.0 - (lastScale - [(UIPinchGestureRecognizer*)recognizer scale]);
    
	CGAffineTransform currentTransform = [(UIPinchGestureRecognizer*)recognizer view].transform;
	CGAffineTransform newTransform = CGAffineTransformScale(currentTransform, scale, scale);
    
	[[(UIPinchGestureRecognizer*)recognizer view] setTransform:newTransform];
    
	lastScale = [(UIPinchGestureRecognizer*)recognizer scale];
    
}

/*--------------------------------------------------------------
 * one finger move
 *-------------------------------------------------------------*/
-(void)move:(UIPanGestureRecognizer *)recognizer
{   
    saved =0;
    CGPoint translation = [recognizer translationInView:self.view];
    recognizer.view.center = CGPointMake(recognizer.view.center.x + translation.x,
                                         recognizer.view.center.y + translation.y);
    [recognizer setTranslation:CGPointMake(0, 0) inView:self.view];
    
}

#pragma mark -
#pragma mark MBProgressHUDDelegate methods

- (void)hudWasHidden:(MBProgressHUD *)hud {
    // Remove HUD from screen when the HUD was hidded
    [HUD removeFromSuperview];
	HUD = nil;
}

#pragma mark - Kumulos Delegate methods
-(void) kumulosAPI:(Kumulos *)kumulos apiOperation:(KSAPIOperation *)operation uploadPhotosDidCompleteWithResult:(NSNumber *)newRecordID
{
    NSString *currentEventID= [[NSUserDefaults standardUserDefaults] stringForKey:@"currentEventID"];
    NSString *currentUserID= [[NSUserDefaults standardUserDefaults] stringForKey:@"currentUserID"];
    
    NSMutableDictionary *dic=[[NSMutableDictionary alloc] init];
    [dic setObject:newRecordID forKey:@"photoDBID"];
    [dic setObject:self.savedImageFrame forKey:@"text"];
    NSLog(@"%@",dic);
    
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:dic];
	NSDictionary *myDictionary = [NSKeyedUnarchiver unarchiveObjectWithData:data];

    
//    NSMutableData *data = [[NSMutableData alloc] init];
//    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
//    [archiver encodeObject:dic forKey:@"PhotoDetail"];
//    [archiver finishEncoding];
    
//    NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
//    NSMutableDictionary *myDictionary = [unarchiver decodeObjectForKey:@"PhotoDetail"];
//    [unarchiver finishDecoding];
    
    NSLog(@"%@",myDictionary);
    
    Kumulos *k=[[Kumulos alloc] init];
    [k setDelegate:self];
    [k createPostWithTextValue:nil andFunction:2 andDrinksDetail:nil andPhotoDetail:data andUserID:[currentUserID intValue] andEventID:[currentEventID intValue]];

}
-(void) kumulosAPI:(Kumulos *)kumulos apiOperation:(KSAPIOperation *)operation createPostDidCompleteWithResult:(NSNumber *)newRecordID
{
    NSLog(@"newRecordID: %@",newRecordID);
    
  
    [self performSelector:@selector(saveSuccess) withObject:nil afterDelay:2];

    NSString *massege=[NSString stringWithFormat:@"Add a photo"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadTimelineTableView" object:massege];
    if (HUD)
    {
        [HUD removeFromSuperview];
        HUD = nil;
    }
    [self dismissModalViewControllerAnimated:YES];
}

- (void) dismissMySelf:(NSNotification*) notification
{
    [self dismissModalViewControllerAnimated:YES];
}

#pragma mark  -
static inline double radians (double degrees) {return degrees * M_PI/180;}
static UIImage *shrinkImage(UIImage *original, CGSize size, NSInteger function){
    UIImage *final;
    if (function==1) {
        CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
        
        CGContextRef context = CGBitmapContextCreate(NULL, size.width, size.height, 8, 0, colorSpace, kCGImageAlphaPremultipliedFirst);
        
        /////////////////////////////////////////////////////////////////////////////////////////////
        CGContextRotateCTM (context, radians(-90));
        CGContextTranslateCTM(context, -size.height, 0.0f);
        
        CGContextDrawImage(context, CGRectMake(0, 0, size.height, size.width), original.CGImage);
        /////////////////////////////////////////////////////////////////////////////////////////////
        
        
        CGImageRef shrunken = CGBitmapContextCreateImage(context);
        final = [UIImage imageWithCGImage:shrunken];
        
        CGContextRelease(context);
        CGImageRelease(shrunken);
    }
    else {
        CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
        
        CGContextRef context = CGBitmapContextCreate(NULL, size.width, size.height, 8, 0, colorSpace, kCGImageAlphaPremultipliedFirst);
        
        /////////////////////////////////////////////////////////////////////////////////////////////
        //        CGContextRotateCTM (context, radians(-180));
        //        CGContextTranslateCTM(context, -size.width, 0.0f);
        
        CGContextDrawImage(context, CGRectMake(0, 0, size.width, size.height), original.CGImage);
        /////////////////////////////////////////////////////////////////////////////////////////////
        
        
        CGImageRef shrunken = CGBitmapContextCreateImage(context);
        final = [UIImage imageWithCGImage:shrunken];
        
        CGContextRelease(context);
        CGImageRelease(shrunken);
    }
    
    
    return final;
}

@end

