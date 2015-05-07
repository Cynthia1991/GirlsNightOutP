//
//  CaptureSessionManager.m
//  photoBooth
//
//  Created by Desmond on 28/06/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//
#import "CaptureSessionManager.h"

@implementation CaptureSessionManager

@synthesize captureSession;
@synthesize previewLayer;
@synthesize stillImage,stillImageOutput,imageExifDict;

#pragma mark Capture Session Configuration

- (id)init {
	if ((self = [super init])) {
		[self setCaptureSession:[[AVCaptureSession alloc] init]];
        
        [[self captureSession]setSessionPreset:AVCaptureSessionPresetPhoto];
	}
	return self;
}

- (void)addVideoPreviewLayer {
	[self setPreviewLayer:[[AVCaptureVideoPreviewLayer alloc] initWithSession:[self captureSession]]];
    //[[self previewLayer] setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    [[self previewLayer] setVideoGravity:AVLayerVideoGravityResizeAspectFill];

    
}

- (void)addVideoInput 
{   
    NSError *error = nil;
    
    NSArray *devices = [AVCaptureDevice devices];
    AVCaptureDevice *frontCamera;
    AVCaptureDevice *backCamera;
    
    for (AVCaptureDevice *device in devices) {
        
        //NSLog(@"Device name: %@", [device localizedName]);
        
        if ([device hasMediaType:AVMediaTypeVideo]) {
            
            if ([device position] == AVCaptureDevicePositionBack) {
                //NSLog(@"Device position : back");
                backCamera = device;
            }
            else {
                //NSLog(@"Device position : front");
                frontCamera = device;
            }
        }
    }
    
    if ([frontCamera isFocusModeSupported:AVCaptureFocusModeContinuousAutoFocus] && [frontCamera lockForConfiguration:&error]) {
        [frontCamera setFocusMode:AVCaptureFocusModeContinuousAutoFocus];
        [frontCamera unlockForConfiguration];
    }
    if ([backCamera isFocusModeSupported:AVCaptureFocusModeContinuousAutoFocus] && [backCamera lockForConfiguration:&error]) {
        [backCamera setFocusMode:AVCaptureFocusModeContinuousAutoFocus];
        [backCamera unlockForConfiguration];
    }
    
    
    
    AVCaptureDeviceInput *frontFacingCameraDeviceInput = [AVCaptureDeviceInput deviceInputWithDevice:frontCamera error:&error];
    if (!error) {
        if ([[self captureSession] canAddInput:frontFacingCameraDeviceInput])
            [[self captureSession] addInput:frontFacingCameraDeviceInput];
        else {
            //NSLog(@"Couldn't add front facing video input");
        }
    }
    
}


- (AVCaptureDevice *)cameraWithPosition : (AVCaptureDevicePosition) position
{
    NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    for (AVCaptureDevice *device in devices )
        if ( device.position == position )
        {
            return device;
        }
    return nil ;
}

-(void)changeView
{   
    
    //assumes session is running
    NSArray *inputs = self.captureSession.inputs; 
    for ( AVCaptureDeviceInput *captureDeviceInput in inputs ) 
    {
        AVCaptureDevice *device = captureDeviceInput.device;
        
        if ( [device hasMediaType:AVMediaTypeVideo ] ) 
        {
            AVCaptureDevicePosition position = device.position;
            AVCaptureDevice *newCamera = nil ;
            AVCaptureDeviceInput *newInput = nil ;
            
            if (position == AVCaptureDevicePositionFront)
            {
                newCamera = [self cameraWithPosition:AVCaptureDevicePositionBack];
            }
            else
            {
                newCamera = [self cameraWithPosition:AVCaptureDevicePositionFront];
            }
            //[self initializeCaptureDevice:newCamera];
            newInput = [AVCaptureDeviceInput deviceInputWithDevice:newCamera error:nil];
            
            // beginConfiguration ensures that pending changes are not applied immediately
            [self.captureSession beginConfiguration ];
            
            [self.captureSession removeInput:captureDeviceInput]; //remove current
            [self.captureSession addInput:newInput]; //add new
            
            // Changes take effect once the outermost commitConfiguration is invoked.
            [self.captureSession commitConfiguration];
            break ;
        }
    }
}


- (void)addStillImageOutput
{
    [self setStillImageOutput:[[AVCaptureStillImageOutput alloc] init]];
    NSDictionary *outputSettings = [[NSDictionary alloc] initWithObjectsAndKeys:AVVideoCodecJPEG,AVVideoCodecKey,nil];
    [[self stillImageOutput] setOutputSettings:outputSettings];
    
    AVCaptureConnection *videoConnection = nil;
    for (AVCaptureConnection *connection in [[self stillImageOutput] connections]) {
        for (AVCaptureInputPort *port in [connection inputPorts]) {
            if ([[port mediaType] isEqual:AVMediaTypeVideo] ) {
                videoConnection = connection;
                break;
            }
        }
        if (videoConnection) {
            break;
        }
    }
    
    [[self captureSession] addOutput:[self stillImageOutput]];
}

- (void)captureStillImage
{
	AVCaptureConnection *videoConnection = nil;
	for (AVCaptureConnection *connection in [[self stillImageOutput] connections]) {
		for (AVCaptureInputPort *port in [connection inputPorts]) {
			if ([[port mediaType] isEqual:AVMediaTypeVideo]) {
				videoConnection = connection;
				break;
			}
		}
        
        if([videoConnection isVideoOrientationSupported]) 
        {
            UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
            
            if (orientation == UIInterfaceOrientationPortrait ) {
                
                
                [videoConnection setVideoOrientation:AVCaptureVideoOrientationPortrait];
            }
            
        }
		if (videoConnection) {
            break;
        }
	}
    
	//NSLog(@"about to request a capture from: %@", [self stillImageOutput]);
	[[self stillImageOutput] captureStillImageAsynchronouslyFromConnection:videoConnection
                                                         completionHandler:^(CMSampleBufferRef imageSampleBuffer, NSError *error) {
                                                             CFDictionaryRef exifAttachments = CMGetAttachment(imageSampleBuffer, kCGImagePropertyExifDictionary, NULL);
                                                             if (exifAttachments) {
                                                                 ////NSLog(@"attachements: %@", exifAttachments);
                                                             } else {
                                                                 //NSLog(@"no attachments");
                                                             }
                                                             NSData *imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageSampleBuffer];
                                                             
                                                             UIImage *image = [[UIImage alloc] initWithData:imageData];
                                                             
                                                             //NSData *jpgImageData = UIImageJPEGRepresentation(image, 0.9);
                                                             
                                                             //UIImage *jpgImage = [[UIImage alloc]initWithData:jpgImageData];
                                                             
                                                             [self setStillImage:image];
                                                             
                                                             self.imageExifDict = (__bridge NSDictionary *)exifAttachments;
                                                             
                                                             ////NSLog(@"NSdictionary from CFDict %@",self.imageExifDict);
                                                             //                                                          
                                                             [[NSNotificationCenter defaultCenter] postNotificationName:kImageCapturedSuccessfully object:nil];
                                                         }];
}


@end
