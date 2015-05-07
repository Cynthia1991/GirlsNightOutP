//
//  MyDetailsDisplayViewController.m
//  GurlsNightOut
//
//  Created by calvin on 3/05/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MyDetailsDisplayViewController.h"
#import "MyDetailsCell.h"
#import "LeaderboardCell.h"
#import <MobileCoreServices/UTCoreTypes.h>
#import "EditMyDetailsViewController.h"
#import "UIImage+Dsp.h"

//@interface MyDetailsDisplayViewController ()
//
//@end

@implementation MyDetailsDisplayViewController
@synthesize btMyDetail;
@synthesize btMyFriends;
@synthesize maskView;
@synthesize _tableView;
@synthesize myIconBackground;
@synthesize ivIcon;
@synthesize btPhoto;
@synthesize lbUserName;
@synthesize friendsDetialDic,function;

 
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:YES];
    
    if (function==0) {// my details
        btMyDetail.hidden=NO;
        btMyFriends.hidden=NO;
        btPhoto.enabled=YES;
        [maskView setAlpha:0.0];

        lbUserName.text=[[[appDelegate myDetailsManager] userInfoDic] objectForKey:@"userName"];
        if ([[[[appDelegate myDetailsManager] userInfoDic] objectForKey:@"photosDBID"] intValue]!=0) {
            

            
            [ivIcon setImage:[[appDelegate myDetailsManager] userIcon]];
        }
    }
    else//friends details
    {
        btMyDetail.hidden=YES;
        btMyFriends.hidden=YES;
        btPhoto.enabled=NO;

        lbUserName.text=[friendsDetialDic objectForKey:@"userName"];
        if ([[friendsDetialDic objectForKey:@"photosDBID"] intValue]!=0) {
            
            UIImage *img=[[[appDelegate photoManager] getPhotoByPhotoDBID:[friendsDetialDic objectForKey:@"photosDBID"]] imageByApplyingGaussianBlurOfSize:5 withSigmaSquared:90.0];
            [myIconBackground setImage:img];
            [maskView setAlpha:0.3];
            
            [ivIcon setImage:[[appDelegate photoManager] getPhotoByPhotoDBID:[friendsDetialDic objectForKey:@"photosDBID"]]];
        }
    }
    


    [self._tableView reloadData];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    if ([[appDelegate.instructionManager.instructionDic objectForKey:@"profileInstruction"] boolValue]) {
        [self.scvInstruction setHidden:YES];
    }
    else
    {
        [self.scvInstruction setHidden:NO];
    }
	// Do any additional setup after loading the view.
    self.scvInstruction.contentSize=CGSizeMake(320*2, 460);
    [self.scvInstruction setContentOffset:CGPointMake(0, 0)];
    
    
    if (function==0) {
        [appDelegate initMyDetailsManager];
        
        Kumulos *k=[[Kumulos alloc] init];
        [k setDelegate:self];
        [k getUserInfoByDBIDWithUserDBID:[[[[appDelegate myDetailsManager] userInfoDic] objectForKey:@"userDBID"] intValue]];
    }

    [self._tableView setBackgroundColor:[UIColor clearColor]];

}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
//    [self updateDisplay];
}
- (void)viewDidUnload
{
    [self setBtPhoto:nil];
    [self setLbUserName:nil];
    [self set_tableView:nil];
    [self setMyIconBackground:nil];
    [self setBtMyDetail:nil];
    [self setBtMyFriends:nil];
    [self setIvIcon:nil];
    [self setMaskView:nil];
    [self setScvInstruction:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"pushEditDetail"])
    {
        EditMyDetailsViewController *editMyDetailsViewController = [segue destinationViewController];
        if (function==0) {
            editMyDetailsViewController.function=0;
        }
        else if (function==1)
        {
            editMyDetailsViewController.function=1;
            editMyDetailsViewController.friendInfoDic=friendsDetialDic;
        }
    }
    else if ([segue.identifier isEqualToString:@"addPhotoSegueForDetails"]) {
        NSUserDefaults *userPreferences = [NSUserDefaults standardUserDefaults];
        [userPreferences setObject:[NSString stringWithFormat:@"1"] forKey:@"addPhotosFunction"];
        [userPreferences synchronize];
    }
    else if ([segue.identifier isEqualToString:@"pushMyDetails"])
    {
        MyDetailsDisplayViewController *myDetailsDisplayViewController=[segue destinationViewController];
        myDetailsDisplayViewController.function=0;
    }
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if (section==0) {
        return 2;
    }


    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
//    static NSString *CellIdentifierFriends = @"CellFriends";
//    static NSString *CellIdentifierLeaderboard = @"CellLeaderboard";

    
    // Configure the cell...
    if (function==0) {//my details
        if ([indexPath section]==0) {
            
            MyDetailsCell *cellMyDetails = [_tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            UIImage *img;
            
            if ([indexPath row]==0) {
                cellMyDetails.lbTitle.text=[NSString stringWithFormat:@"Phone:"];
                cellMyDetails.ivTitleIcon.image=[UIImage imageNamed:@"myDetailPhone.png"];
                
                
                if ([[[[appDelegate myDetailsManager] userPersonalInfoDic] objectForKey:@"mobilePhone"] length]!=0) {
                    cellMyDetails.tfInput.text=[NSString stringWithFormat:@"%@",[[[appDelegate myDetailsManager] userPersonalInfoDic] objectForKey:@"mobilePhone"]];
                    if ([[[[appDelegate myDetailsManager] isShareDic] objectForKey:@"mobilePhone"] boolValue]) {
                        img=[UIImage imageNamed:@"sharing.png"];
                    }
                    else {
                        img=[UIImage imageNamed:@"not sharing.png"];
                    }
                }
                else
                {
                    cellMyDetails.tfInput.text=[NSString stringWithFormat:@""];
                    cellMyDetails.tfInput.placeholder=[NSString stringWithFormat:@"Mobile Number"];
                    img=nil;
                }
                
            }
            else if ([indexPath row]==1)
            {
                cellMyDetails.lbTitle.text=[NSString stringWithFormat:@"Facebook:"];
                cellMyDetails.ivTitleIcon.image=[UIImage imageNamed:@"myDetailFacebook.png"];

                
                if ([[[[appDelegate myDetailsManager] userPersonalInfoDic] objectForKey:@"facebook"] length]!=0) {
                    cellMyDetails.tfInput.text=[NSString stringWithFormat:@"%@",[[[appDelegate myDetailsManager] userPersonalInfoDic] objectForKey:@"facebook"]];
                    if ([[[[appDelegate myDetailsManager] isShareDic] objectForKey:@"facebook"] boolValue]) {
                        img=[UIImage imageNamed:@"sharing.png"];
                    }
                    else {
                        img=[UIImage imageNamed:@"not sharing.png"];
                    }
                }
                else
                {
                    cellMyDetails.tfInput.text=[NSString stringWithFormat:@""];
                    cellMyDetails.tfInput.placeholder=[NSString stringWithFormat:@"Email or Facebook Email"];
                    img=nil;
                }
            }
            
            cellMyDetails.ivShare.image=img;
            cellMyDetails.backgroundColor=[UIColor grayColor];
            [self setCellSelectedBackgroundImage:nil TableViewCell:cellMyDetails];

            return cellMyDetails;
        }
//        else if([indexPath section]==1)
//        {
//            LeaderboardCell *cellLeaderboard = [_tableView dequeueReusableCellWithIdentifier:CellIdentifierLeaderboard];
//            cellLeaderboard.lbFirst.text=[NSString stringWithFormat:@"#1 Alice"];
//            cellLeaderboard.lbSecond.text=[NSString stringWithFormat:@"#2 Queenie"];
//            cellLeaderboard.lbThird.text=[NSString stringWithFormat:@"#3 Alice"];
//            
//            cellLeaderboard.lbFirstPoint.text=[NSString stringWithFormat:@"6435"];
//            cellLeaderboard.lbSecondPoint.text=[NSString stringWithFormat:@"4678"];
//            cellLeaderboard.lbThirdPoint.text=[NSString stringWithFormat:@"2467"];
//            return cellLeaderboard;
//        }
//        else if([indexPath section]==2)
//        {
//            UITableViewCell *cellFriends = [_tableView dequeueReusableCellWithIdentifier:CellIdentifierFriends];
//            cellFriends.textLabel.text=@"Manage Friends";
//            return cellFriends;
//        }
    }
    else if (function==1)//friends details
    {
        if ([indexPath section]==0) {
            
            MyDetailsCell *cellMyDetails = [_tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            [cellMyDetails.tfInput setFrame:CGRectMake(cellMyDetails.tfInput.frame.origin.x, cellMyDetails.tfInput.frame.origin.y, 200, cellMyDetails.tfInput.frame.size.height)];
            UIImage *img;
            
            if ([indexPath row]==0) {
                cellMyDetails.lbTitle.text=[NSString stringWithFormat:@"Phone:"];
                cellMyDetails.ivTitleIcon.image=[UIImage imageNamed:@"myDetailPhone.png"];

                if ([[friendsDetialDic objectForKey:@"mobilePhone"] length]!=0) {
                    cellMyDetails.tfInput.text=[NSString stringWithFormat:@"%@",[friendsDetialDic objectForKey:@"mobilePhone"]];
                }
                else
                {
                    cellMyDetails.tfInput.text=[NSString stringWithFormat:@""];
                    cellMyDetails.tfInput.placeholder=[NSString stringWithFormat:@"Your Friends did not share"];
                    img=nil;
                }
                
            }
            else if ([indexPath row]==1)
            {
                cellMyDetails.lbTitle.text=[NSString stringWithFormat:@"Facebook:"];
                cellMyDetails.ivTitleIcon.image=[UIImage imageNamed:@"myDetailFacebook.png"];

                if ([[friendsDetialDic objectForKey:@"facebook"] length]!=0) {
                    cellMyDetails.tfInput.text=[NSString stringWithFormat:@"%@",[friendsDetialDic objectForKey:@"facebook"]];
                }
                else
                {
                    cellMyDetails.tfInput.text=[NSString stringWithFormat:@""];
                    cellMyDetails.tfInput.placeholder=[NSString stringWithFormat:@"Your Friends did not share"];
                    img=nil;
                }
            }
            
            cellMyDetails.ivShare.image=img;
            [self setCellSelectedBackgroundImage:nil TableViewCell:cellMyDetails];

            return cellMyDetails;
        }

    }
        
    return nil;
}
- (void)setCellSelectedBackgroundImage:(NSString*)imageName TableViewCell:(UITableViewCell*) tableViewCell
{
    UIView *imageView= [[UIView alloc] initWithFrame:tableViewCell.frame];
    imageView.backgroundColor = [UIColor blackColor];
    imageView.alpha=0.5;
    tableViewCell.selectedBackgroundView = imageView;
}
- (NSString* ) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *titleSection;
    if (section==0) {
//        titleSection=[NSString stringWithFormat:@"My details"];
    }
    else if (section==1) {
        titleSection=[NSString stringWithFormat:@"Leaderboard"];
    }
    else if (section==2) {
        titleSection=[NSString stringWithFormat:@"My friends"];
    }
    else if (section==3) {
        titleSection=[NSString stringWithFormat:@"Faverite drinks"];
    }
    else if (section==4) {
        titleSection=[NSString stringWithFormat:@"Faverite places"];
    }
    
    return titleSection;
}

#pragma mark - Table view delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([indexPath section]==1) {
        return 98;
    }
    return 44;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([indexPath section]==0) {
        if ([indexPath row]==0) {
            if ([[[[appDelegate myDetailsManager] isShareDic] objectForKey:@"mobilePhone"] boolValue]) {
                [[appDelegate myDetailsManager] changeIsShareDicInFile:[NSString stringWithFormat:@"0"] KeyInDic:@"mobilePhone"];
            }
            else {
                [[appDelegate myDetailsManager] changeIsShareDicInFile:[NSString stringWithFormat:@"1"] KeyInDic:@"mobilePhone"];
            }
        }
        else if ([indexPath row]==1)
        {
            if ([[[[appDelegate myDetailsManager] isShareDic] objectForKey:@"facebook"] boolValue]) {
                [[appDelegate myDetailsManager] changeIsShareDicInFile:[NSString stringWithFormat:@"0"] KeyInDic:@"facebook"];
            }
            else {
                [[appDelegate myDetailsManager] changeIsShareDicInFile:[NSString stringWithFormat:@"1"] KeyInDic:@"facebook"];
            }
        }
        
        [[appDelegate myDetailsManager] initShareDic];
        
        [self._tableView reloadData];
    }
}

#pragma mark - button action
- (IBAction)btBackAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)btPhotoAction:(id)sender {
    NSLog(@"take photo");
//    [self getMediaFromSource:UIImagePickerControllerSourceTypeCamera];
    [self performSegueWithIdentifier:@"addPhotoSegueForDetails" sender:self];

}


- (void) kumulosAPI:(Kumulos *)kumulos apiOperation:(KSAPIOperation *)operation getUserInfoByDBIDDidCompleteWithResult:(NSArray *)theResults
{
    if ([theResults count]!=0) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"save user detail to app" object:theResults];
    }
    
}
#pragma mark - button action
- (void)getMediaFromSource:(UIImagePickerControllerSourceType)sourceType {
    NSArray *mediaTypes = [UIImagePickerController
						   availableMediaTypesForSourceType:sourceType];
    if ([UIImagePickerController isSourceTypeAvailable:
         sourceType] && [mediaTypes count] > 0) {
        NSArray *mediaTypes = [UIImagePickerController
							   availableMediaTypesForSourceType:sourceType];
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.mediaTypes = mediaTypes;
        picker.delegate = self;
        picker.allowsEditing = YES;
        picker.sourceType = sourceType;
        [self presentModalViewController:picker animated:YES];
    }
    else {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"Error accessing media"
                              message:@"Device doesn’t support that media source."
                              delegate:nil
                              cancelButtonTitle:@"Drat!"
                              otherButtonTitles:nil];
        [alert show];
    }
}


#pragma mark - UIImagePickerController delegate methods
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    lastChosenMediaType = [info objectForKey:UIImagePickerControllerMediaType];
    if ([lastChosenMediaType isEqual:(NSString *)kUTTypeImage]) {
        
        UIImage *chosenImage = [info objectForKey:UIImagePickerControllerEditedImage];
        ////////////////////////////////////////////////////////////////////////////////////
        UIImage *shrunkenImage;
        if (chosenImage.size.width<chosenImage.size.height) {
            imageFrame=CGRectMake(0, 0, 200, 200);
            shrunkenImage = shrinkImage(chosenImage, imageFrame.size,1);
        }
        else {
            imageFrame=CGRectMake(0, 0, 460, 320);
            shrunkenImage = shrinkImage(chosenImage, imageFrame.size,2);
        }
        image = shrunkenImage;
        
        ////////////////////////////////////////////////////////////////////////////////////
        //        UIImage *shrunkenLargeImage;
        //        if (chosenImage.size.width<chosenImage.size.height) {
        //            imageFrame=CGRectMake(0, 0, 960, 1280);
        //            imageView.frame=CGRectMake(0, 0, 200, 266);
        //            shrunkenLargeImage = shrinkImage(chosenImage, imageFrame.size,1);
        //        }
        //        else {
        //            imageFrame=CGRectMake(0, 0, 1280, 960);
        //            imageView.frame=CGRectMake(0, 0, 200, 150);
        //            shrunkenLargeImage = shrinkImage(chosenImage, imageFrame.size,2);
        //        }
        //        self.largeImage=shrunkenLargeImage;
        ////////////////////////////////////////////////////////////////////////////////////
        isUpload=TRUE;
        
    }
    [picker dismissModalViewControllerAnimated:YES];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissModalViewControllerAnimated:YES];
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
- (void)updateDisplay {
    if ([lastChosenMediaType isEqual:(NSString *)kUTTypeImage]) {
        [UIView animateWithDuration:0.2
                         animations:^{
                             [ivIcon setAlpha:0.0];
                         }
                         completion:^(BOOL finished){
                             [ivIcon setImage:image];
                             [UIView animateWithDuration:0.2
                                              animations:^{
                                                  [ivIcon setAlpha:1.0];
                                              }
                                              completion:^(BOOL finished){
                                              }];
                         }];
    }
    
    if (isUpload) {
        [[appDelegate myDetailsManager] saveUserIconByImage:image];
        isUpload=false;
    }
    
    
}



#pragma mark - scrollView Delegate
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    if (scrollView.contentOffset.x>320) {
        [UIView animateWithDuration:0.5
                         animations:^{
                             [self.scvInstruction setAlpha:0.0];
                             
                         }
                         completion:^(BOOL finished){
                             [self.scvInstruction setHidden:YES];
                             [appDelegate.instructionManager setInstructionDicWithValue:YES Key:[NSString stringWithFormat:@"profileInstruction"]];
                         }];
    }
}


@end
