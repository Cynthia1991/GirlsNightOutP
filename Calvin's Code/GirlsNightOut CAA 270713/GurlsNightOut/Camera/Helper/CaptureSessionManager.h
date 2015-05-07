//
//  CaptureSessionManager.h
//  photoBooth
//
//  Created by Desmond on 28/06/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//


#import <CoreMedia/CoreMedia.h>
#import <AVFoundation/AVFoundation.h>
#import <ImageIO/ImageIO.h>


#define kImageCapturedSuccessfully @"imageCapturedSuccessfully"

@interface CaptureSessionManager : NSObject {
    
}

@property  AVCaptureVideoPreviewLayer *previewLayer;
@property  AVCaptureSession *captureSession;

- (void)addVideoPreviewLayer;
- (void)addVideoInput;

@property AVCaptureStillImageOutput *stillImageOutput;
@property (nonatomic) UIImage *stillImage;
@property (nonatomic) NSDictionary *imageExifDict;

- (void)addStillImageOutput;
- (void)captureStillImage;
-(void)changeView;
@end

