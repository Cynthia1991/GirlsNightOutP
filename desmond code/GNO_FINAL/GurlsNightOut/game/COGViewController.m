//
//  COGViewController.m
//  GNOdare
//
//  Created by Desmond on 22/11/12.
//  Copyright (c) 2012 QUT. All rights reserved.
//

#import "COGViewController.h"

@interface COGViewController ()

@end

@implementation COGViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    NSLog(@"Event log %@",self.eventID);
        NSLog(@"user ID log %@",self.userID);
    
    appDelegate=(AppDelegate*)[[UIApplication sharedApplication] delegate];
    
    NSLog(@"%@",self.Theader);
    NSLog(@"%@",self.Tdetails);
    NSLog(@"%@",self.TiconImg);
    NSLog(@"%@",self.TCOGView);
    
    self.header.backgroundColor = [UIColor clearColor];
    self.header.textAlignment = UITextAlignmentCenter;
    self.header.lineBreakMode = UILineBreakModeWordWrap;
    self.header.numberOfLines = 0;
    self.header.textColor = [UIColor darkGrayColor];
    //headerLabel.adjustsFontSizeToFitWidth = YES;
    self.header.font = [UIFont fontWithName:@"SorbetLTD" size:20];
    
    self.details.backgroundColor = [UIColor clearColor];
    self.details.textAlignment = UITextAlignmentCenter;
    self.details.lineBreakMode = UILineBreakModeWordWrap;
    self.details.numberOfLines = 0;
    self.details.textColor = [UIColor darkGrayColor];
    self.details.font = [UIFont fontWithName:@"SorbetLTD" size:17];
    // detailsLabel.adjustsFontSizeToFitWidth = YES;
    
    
    if (self.COGcompleted)
    {
        self.stampImg.image = [UIImage imageNamed:@"stamp_completed.png"];
    }
    else
    {
        self.stampImg.image = [UIImage imageNamed:@"stamp_givenup.png"];
    }    
    
    NSString *tempString = self.Theader;
    
    if ([tempString isEqualToString:@"-"])
    {
        self.header.text = @"";
    }
    else
    {
        self.header.text = self.Theader;
    }
    
    self.details.text = self.Tdetails;
    
    
    self.iconImg.backgroundColor = [UIColor clearColor];
    self.iconImg.contentMode = UIViewContentModeScaleAspectFit;
    self.iconImg.image = self.TiconImg;
    
    self.COGView.backgroundColor = [UIColor clearColor];
    self.COGView.contentMode = UIViewContentModeScaleAspectFit;
    self.COGView.image = self.TCOGView;
    //iconImg.alpha = 0.5;
    
    UIImage *tempImg = [self COG:self.COGView icon:self.iconImg stamp:self.stampImg hLabel:self.header dlabel:self.details];
    
    
    [self uploadToTimeline:tempImg];
    UIImageWriteToSavedPhotosAlbum(tempImg, self, @selector(imageSavedToPhotosAlbum: didFinishSavingWithError: contextInfo:), nil);
    
   

}

-(void)uploadToTimeline:(UIImage *)stpImg
{
    ////////////////////////////////////////////
    NSData *largeImageData = UIImageJPEGRepresentation(stpImg, 1.0);
        
    Kumulos *k=[[Kumulos alloc] init];
        [k setDelegate:self];
        [k uploadPhotosWithPhotoValue:largeImageData andTextValue:@"1" andLargePhotoValue:nil];
        
    ////////////////////////////////

    
}

-(void)backToSpinView
{
//   [self performSegueWithIdentifier:@"backToSpinView" sender:self];
    
    NSLog(@"called here");
    [UIView transitionWithView:self.navigationController.view duration:0.5
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:^{
                        [self.navigationController popViewControllerAnimated:NO];
                    }
                    completion:NULL];
}


//#pragma mark - Kumulos Delegate methods
-(void) kumulosAPI:(Kumulos *)kumulos apiOperation:(KSAPIOperation *)operation uploadPhotosDidCompleteWithResult:(NSNumber *)newRecordID
{
    
    NSMutableDictionary *dic=[[NSMutableDictionary alloc] init];
    [dic setObject:newRecordID forKey:@"photoDBID"];
    [dic setObject:@"1" forKey:@"text"];
    NSLog(@"myDictionary %@",dic);
    
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:dic];
	NSDictionary *myDictionary = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    
    NSLog(@"myDictionary %@",myDictionary);
    
    Kumulos *k=[[Kumulos alloc] init];
    [k setDelegate:self];
    [k createPostWithTextValue:nil andFunction:2 andDrinksDetail:nil andPhotoDetail:data andUserID:[self.userID intValue] andEventID:[self.eventID intValue]];
    
}
-(void) kumulosAPI:(Kumulos *)kumulos apiOperation:(KSAPIOperation *)operation createPostDidCompleteWithResult:(NSNumber *)newRecordID
{
    NSLog(@"newRecordID: %@",newRecordID);
    NSLog(@"call Post");
    NSString *tempStr;
    
    if (self.COGcompleted)
    {
        tempStr = [NSString stringWithFormat:@"%@ Challenge Posted To Timeline",@"Completed"];
    }
    else
    {
        tempStr = [NSString stringWithFormat:@"%@ Challenge Posted To Timeline",@"Given Up"];
    }

    
    
    
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Info"
                                                   message:tempStr
                                                  delegate:self
                                         cancelButtonTitle:@"ok"
                                         otherButtonTitles:nil, nil];
    
    [alert setTag:12];
    
    [alert show];
    
}

-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 12)
    {
        if (buttonIndex == 0)
        {	NSLog(@"11111");
             [[NSNotificationCenter defaultCenter] postNotificationName:@"addPost" object:nil];
            [self performSelector:@selector(backToSpinView) withObject:nil afterDelay:2];
        }
    }
}


//image processing
- (UIImage*) COG:(UIImageView *)COGI icon:(UIImageView *)iconI stamp:(UIImageView *)stampI hLabel:(UILabel *)headerL dlabel:(UILabel *)detailL;
{

        //CGSize newImageSize = CGSizeMake(cropImage.frame.size.width, cropImage.frame.size.height);
        //CGSize newImageSize = CGSizeMake(480, 320);
    
        //CGSize newImageSize = COGI.bounds.size;
    CGSize newImageSize = CGSizeMake(248, 290);
        NSLog(@"CGSize %@",NSStringFromCGSize(newImageSize));
        float scale = [[UIScreen mainScreen] scale];
    
    NSLog(@"scale %f",scale);
    
        UIGraphicsBeginImageContextWithOptions(newImageSize, NO, 0.0); //retina res
        //[COGI.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    CGContextRef contextRef = UIGraphicsGetCurrentContext();
       
    CGRect drawRect = CGRectMake(0,0,248,290);
    CGContextSetRGBFillColor(contextRef, 0.0f/255.0f, 0.0f/255.0f, 0.0f/255.0f, 1.0f);
    CGContextFillRect(contextRef, drawRect);
    
    
        [COGI.image drawInRect:CGRectMake(0, 0, 248, 290)];
        [iconI.image drawInRect:CGRectMake(9, 25, 230, 230)];
        [stampI.image drawInRect:CGRectMake(0, -5, 248, 290)];
        [headerL drawTextInRect:CGRectMake(14, 35, 220, 40)];
        [detailL drawTextInRect:CGRectMake(16, 200, 215, 65)];
    
        
        UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
        NSData *imgData =  UIImageJPEGRepresentation(image, 1.0); //UIImagePNGRepresentation ( image ); // get JPEG representation
        UIImage * imagePNG = [UIImage imageWithData:imgData]; // wrap UIImage around PNG representation
    
        UIGraphicsEndImageContext();
        return imagePNG;
    
}

- (void)imageSavedToPhotosAlbum:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    
  
    
    if (!error)
    {
        NSLog(@"[description] working");
        
    } else
    {
        NSLog(@"[error description] %@;",[error description]);
       
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
