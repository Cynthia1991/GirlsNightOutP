//
//  ViewController.m
//  GNOdare
//
//  Created by Desmond on 15/10/12.
//  Copyright (c) 2012 QUT. All rights reserved.
//

#import "spinViewController.h"

#define SCROLL_SPEED 15 //items per second, can be negative or fractional
#define SCROLL_SPEEDTOD 9 //items per second, can be negative or fractional
#define SCROLL_SPEEDTOD2 1.5 //items per second, can be negative or fractional
#define SCROLL_SPEED1 3 //items per second, can be negative or fractional
#define SCROLL_SPEED2 0.6 //items per second, can be negative or fractional

@interface spinViewController ()

@end

@implementation spinViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //NSLog(@"%@", [UIFont fontNamesForFamilyName:@"SorbetLTD"]);
    
    //NSLog(@"%@", [UIFont familyNames]);
    
    truth = 0;
    dare = 0;
    spinned = 0;
    pulledDown = 0;
    isCompleted = 0;
    //iCarouselTypeRotary
    //iCarouselTypeWheel
    self.carouselView.type = iCarouselTypeWheel;
    self.ToDCarouselView.type = iCarouselTypeRotary;
    self.carouselView.vertical=YES;
    self.nameTag.alpha=0.0;
    self.nameTag.adjustsFontSizeToFitWidth = YES;

    //range x(1) to y(6)
    //[self startScrolling];
    
    //CGAffineTransform newTransform = CGAffineTransformMakeRotation(90 * (M_PI / 180));
    //self.active.transform = newTransform;
    //self.active.titleLabel.transform = newTransform;

	// Do any additional setup after loading the view, typically from a nib.
    
    //[self setTimerForSpinner];
    [self setUpLever];
    
    self.bumpKumulosHandler=[[BumpKumulosHandler alloc] init];
   self.bumpKumulosHandler.eventID=[self.eventID intValue];
    NSLog(@"desmondID %@",self.eventID);
    
    appDelegate=(AppDelegate*)[[UIApplication sharedApplication] delegate];
    
    
    [self setupDataLocal];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)awakeFromNib
{
    self.truthGameTaskPlist = [[gameTask alloc] initWithTruthGameName:@"truth"];
    self.dareGameTaskPlist = [[gameTask alloc] initWithDareGameName:@"dare"];
      
//    for (int i =0; i<[self.truthGameTaskPlist truthgameTaskCount]; i++)
//    {
//        NSLog(@"Truth header %@",[[self.truthGameTaskPlist truthGameItemAtIndex:i] valueForKey:@"header"]);
//    }
    //cell.textLabel.text = [[helpMePlist libraryItemAtIndex:indexPath.row] valueForKey:@"header"];
    //detailsLabel.text=[[helpMePlist libraryItemAtIndex:row] valueForKey:@"details"];
        
    //[self setupData];
    //[self setupDataURL];
    //[self setupDataLocal];
    
}
#pragma round corner

void addRoundedRectToPath(CGContextRef context, CGRect rect, float ovalWidth, float ovalHeight)
{
    float fw, fh;
    if (ovalWidth == 0 || ovalHeight == 0) {
        CGContextAddRect(context, rect);
        return;
    }
    CGContextSaveGState(context);
    CGContextTranslateCTM (context, CGRectGetMinX(rect), CGRectGetMinY(rect));
    CGContextScaleCTM (context, ovalWidth, ovalHeight);
    fw = CGRectGetWidth (rect) / ovalWidth;
    fh = CGRectGetHeight (rect) / ovalHeight;
    CGContextMoveToPoint(context, fw, fh/2);
    CGContextAddArcToPoint(context, fw, fh, fw/2, fh, 1);
    CGContextAddArcToPoint(context, 0, fh, 0, fh/2, 1);
    CGContextAddArcToPoint(context, 0, 0, fw/2, 0, 1);
    CGContextAddArcToPoint(context, fw, 0, fw, fh/2, 1);
    CGContextClosePath(context);
    CGContextRestoreGState(context);
}

-(UIImage *)makeRoundCornerImage : (UIImage*) img : (int) cornerWidth : (int) cornerHeight
{
    UIImage * newImage = nil;
    
    if( nil != img)
    {
        //NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
        int w = img.size.width;
        int h = img.size.height;
        
        CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
        CGContextRef context = CGBitmapContextCreate(NULL, w, h, 8, 4 * w, colorSpace, kCGImageAlphaPremultipliedFirst);
        
        CGContextBeginPath(context);
        CGRect rect = CGRectMake(0, 0, img.size.width, img.size.height);
        addRoundedRectToPath(context, rect, cornerWidth, cornerHeight);
        CGContextClosePath(context);
        CGContextClip(context);
        
        CGContextDrawImage(context, CGRectMake(0, 0, w, h), img.CGImage);
        
        CGImageRef imageMasked = CGBitmapContextCreateImage(context);
        CGContextRelease(context);
        CGColorSpaceRelease(colorSpace);
        
        newImage = [UIImage imageWithCGImage:imageMasked];
        CGImageRelease(imageMasked);
    }
    
    return newImage;
}
    
#pragma mark -
#pragma mark Data

-(IBAction)exitSpinner:(id)sender;
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)resetSpinner
{
    [self removeTODSpinner];
     [self.levelImgView setAlpha:1.0];
    
    self.truthGameTaskPlist = [[gameTask alloc] initWithTruthGameName:@"truth"];
    self.dareGameTaskPlist = [[gameTask alloc] initWithDareGameName:@"dare"];
    
    [self setupDataLocal];

    
    truth = 0;
    dare = 0;
    spinned = 0;
    pulledDown = 0;
    isCompleted = 0;
    //iCarouselTypeRotary
    //iCarouselTypeWheel
    self.carouselView.type = iCarouselTypeWheel;
    self.ToDCarouselView.type = iCarouselTypeRotary;
    self.carouselView.vertical=YES;
    self.nameTag.alpha=0.0;
    self.nameTag.adjustsFontSizeToFitWidth = YES;
    [self.crosshairView setAlpha:0.5];
    [self.largeImgView setImage:nil];
    [self.exitButton setAlpha:1];
    [self setUpLever];

    
}

-(void)setupData
{
    self.nameArray = [[NSMutableArray alloc]init];
    [self.nameArray addObject:@"Andy"]; 
    [self.nameArray addObject:@"Calvin"];
    [self.nameArray addObject:@"Desmond"];
    [self.nameArray addObject:@"Dian"];
    [self.nameArray addObject:@"Ivan"];
    [self.nameArray addObject:@"Jimmy"];
    [self.nameArray addObject:@"Johannes"];
    [self.nameArray addObject:@"Launa"];
    [self.nameArray addObject:@"Michael"];
    [self.nameArray addObject:@"Tony"];
    [self.nameArray addObject:@"Wei"];
    [self.nameArray addObject:@"Zac"];
    [self.carouselView reloadData];
}

-(void)setupDataLocal2 //orignal data
{
    self.picsLocalArray = [[NSMutableArray alloc]init];
    self.nameArray = [[NSMutableArray alloc]init];
    
    
    NSMutableArray *tempNameArray =[[NSMutableArray alloc]init];
    [tempNameArray addObject:@"Andy"];
    [tempNameArray addObject:@"Calvin"];
    [tempNameArray addObject:@"Desmond"];
    [tempNameArray addObject:@"Dian"];
    [tempNameArray addObject:@"Ivan"];
    [tempNameArray addObject:@"Jimmy"];
    [tempNameArray addObject:@"Johannes"];
    [tempNameArray addObject:@"Launa"];
    [tempNameArray addObject:@"Michael"];
    [tempNameArray addObject:@"Tony"];
    [tempNameArray addObject:@"Wei"];
    [tempNameArray addObject:@"Zac"];
    
    NSMutableArray *imageNameSQ =[[NSMutableArray alloc]init];
    [imageNameSQ addObject:@"a.png"];
    [imageNameSQ addObject:@"c.png"];
    [imageNameSQ addObject:@"d.png"];
    [imageNameSQ addObject:@"dian2.png"];
    [imageNameSQ addObject:@"i.png"];
    [imageNameSQ addObject:@"j.png"];
    [imageNameSQ addObject:@"j2.png"];
    [imageNameSQ addObject:@"l.png"];
    [imageNameSQ addObject:@"m.png"];
    [imageNameSQ addObject:@"t.png"];
    [imageNameSQ addObject:@"w.png"];
    [imageNameSQ addObject:@"z.png"];
    
    NSMutableArray *imageName =[[NSMutableArray alloc]init];
    
    for (int i =0; i<[imageNameSQ count]; i++)
    {
        UIImage *original = [UIImage imageNamed:[imageNameSQ objectAtIndex:i]];
        UIImage *rounded = [self makeRoundCornerImage:original :10 :10];
        
        [imageName addObject:rounded];
    }
    
    // NSLog(@"img name count %i",[imageName count]);
    
    NSUInteger count = [imageName count];
    
    for (NSUInteger i = 0; i <count; ++i)
    {
        int nElements = count;
        
        int n = (arc4random_uniform(nElements));
        
        [imageName exchangeObjectAtIndex:i withObjectAtIndex:n];
        
        [tempNameArray exchangeObjectAtIndex:i withObjectAtIndex:n];
        
        //NSLog(@"tempNameArray %@",[tempNameArray objectAtIndex:i]);
        //NSLog(@"imageName %@",[imageName objectAtIndex:i]);
    }
    
    self.nameArray = tempNameArray;
    self.picsLocalArray = imageName;
    
    //NSLog(@"imageName %@",self.picsLocalArray);
    //NSLog(@"tempNameArray %@",self.nameArray);
    
    [self.carouselView reloadData];
}


-(void)setupDataLocal
{
    self.picsLocalArray = [[NSMutableArray alloc]init];
    self.nameArray = [[NSMutableArray alloc]init];
    
    NSLog(@"self.eventID %@",self.eventID);
    
    NSMutableArray *dic=[[appDelegate.eventsManager getEventDictionaryByEventID:self.eventID] objectForKey:@"eventFriends"];
    
    self.friendsArray=[[NSMutableArray alloc] init];
    for (int i=0; i<[dic count]; i++) {
        [self.friendsArray addObject:[[dic objectAtIndex:i] objectForKey:@"userID"]];
    }
    
    NSLog(@"friendsArray %@",self.friendsArray);
    
    
    NSMutableArray *tempNameArray =[[NSMutableArray alloc]init];
    //[tempNameArray addObject:@"Andy"];
    
    NSMutableArray *tempUserIDArray =[[NSMutableArray alloc]init];
    
    NSMutableArray *imageNameSQ =[[NSMutableArray alloc]init];
    //[imageNameSQ addObject:@"a.png"];
    
    
    

    
    
    for (int i=0; i<[self.friendsArray count]; i++)
    {
         UIImage *img=[[appDelegate photoManager] getPhotoByPhotoDBID:[[self.friendsArray objectAtIndex:i] objectForKey:@"photosDBID"]];
        
        [imageNameSQ addObject:img];
    }
    
    for (int i=0; i<[self.friendsArray count]; i++)
    {
         NSString *tempStr =[[self.friendsArray objectAtIndex:i] objectForKey:@"userName"];
        [tempNameArray addObject:tempStr];
    }
    
    for (int i=0; i<[self.friendsArray count]; i++)
    {
        NSString *tempStr =[[self.friendsArray objectAtIndex:i] objectForKey:@"userDBID"];
        [tempUserIDArray addObject:tempStr];
    }
    
       
    NSMutableArray *imageName =[[NSMutableArray alloc]init];
    
    for (int i =0; i<[imageNameSQ count]; i++)
    {
    UIImage *original = [imageNameSQ objectAtIndex:i];
    UIImage *rounded = [self makeRoundCornerImage:original :10 :10];
        
        [imageName addObject:rounded];
    }
    
   // NSLog(@"img name count %i",[imageName count]);
        
    NSUInteger count = [imageName count];
    
    for (NSUInteger i = 0; i <count; ++i)
    {
        int nElements = count;
        
        int n = (arc4random_uniform(nElements));
        
        [imageName exchangeObjectAtIndex:i withObjectAtIndex:n];
        
        [tempNameArray exchangeObjectAtIndex:i withObjectAtIndex:n];
        
        [tempUserIDArray exchangeObjectAtIndex:i withObjectAtIndex:n];
        
        //NSLog(@"tempNameArray %@",[tempNameArray objectAtIndex:i]);
        //NSLog(@"imageName %@",[imageName objectAtIndex:i]);
    }
    
    self.nameArray = tempNameArray;
    self.picsLocalArray = imageName;
    self.userIDArray = tempUserIDArray;
    
    //NSLog(@"imageName %@",self.picsLocalArray);
    //NSLog(@"tempNameArray %@",self.nameArray);

    [self.carouselView reloadData];
}

-(void)setupDataURL
{
    NSMutableArray *imagePaths =[[NSMutableArray alloc]init];
    NSMutableArray *URLs =[[NSMutableArray alloc]init];
    self.picsURLArray = [[NSMutableArray alloc]init];
    
    [imagePaths addObject:@"https://dl.dropbox.com/u/418769/photohead/a.png"];
    [imagePaths addObject:@"https://dl.dropbox.com/u/418769/photohead/c.png"];
    [imagePaths addObject:@"https://dl.dropbox.com/u/418769/photohead/d.png"];
    [imagePaths addObject:@"https://dl.dropbox.com/u/418769/photohead/d2.png"];
    [imagePaths addObject:@"https://dl.dropbox.com/u/418769/photohead/i.png"];
    [imagePaths addObject:@"https://dl.dropbox.com/u/418769/photohead/j.png"];
    [imagePaths addObject:@"https://dl.dropbox.com/u/418769/photohead/j2.png"];
    [imagePaths addObject:@"https://dl.dropbox.com/u/418769/photohead/l.png"];
    [imagePaths addObject:@"https://dl.dropbox.com/u/418769/photohead/m.png"];
    [imagePaths addObject:@"https://dl.dropbox.com/u/418769/photohead/t.png"];
    [imagePaths addObject:@"https://dl.dropbox.com/u/418769/photohead/w.png"];
    [imagePaths addObject:@"https://dl.dropbox.com/u/418769/photohead/z.png"];
    
    for (NSString *path in imagePaths)
    {
        NSURL *URL = [NSURL URLWithString:path];
        if (URL)
        {
            [URLs addObject:URL];
            //NSLog(@"URL %@",URL);
        }
        else
        {
            NSLog(@"'%@' is not a valid URL", path);
        }
    }
    self.picsURLArray = URLs;
    //[self.carouselView reloadData];

    
}

-(void)setupTODData
{
    NSMutableArray *gameCard =[[NSMutableArray alloc]init]; //default Task Card img
    NSMutableArray *gameIcon =[[NSMutableArray alloc]init];
    NSMutableArray *gameHeader =[[NSMutableArray alloc]init]; // header text
    NSMutableArray *gameDetail =[[NSMutableArray alloc]init]; // details text
//    NSMutableArray *gameCardSQ =[[NSMutableArray alloc]init]; // square form awaiting to corner rounding

    
    if (truth)
    {
        NSLog(@"user choosen truth");
                
        for (int i=0; i<[self.truthGameTaskPlist truthgameTaskCount]; i++)
        {
            //[gameCardSQ addObject:@"blank_truth@2x.png"];
            
            UIImage *tImg = [UIImage imageNamed:@"blank_truth.png"];
            [gameCard addObject:tImg];
        }
        
//        for (int i =0; i<[gameCardSQ count]; i++)
//        {
//            UIImage *original = [UIImage imageNamed:[gameCardSQ objectAtIndex:i]];
//            UIImage *rounded = [self makeRoundCornerImage:original :10 :10];
//            [gameCard addObject:rounded];
//        }
        
        for (int i =0; i<[self.truthGameTaskPlist truthgameTaskCount]; i++)
        {
            NSString *tempHStr = [[self.truthGameTaskPlist truthGameItemAtIndex:i]valueForKey:@"header"];
            NSString *tempDStr = [[self.truthGameTaskPlist truthGameItemAtIndex:i]valueForKey:@"details"];
            NSString *tempIconStr = [[self.truthGameTaskPlist truthGameItemAtIndex:i]valueForKey:@"icons"];
            
            [gameHeader addObject:tempHStr];
            [gameDetail addObject:tempDStr];
            [gameIcon addObject:tempIconStr];
            
        }
    }
    else if (dare)
    {
        NSLog(@"user choosen dare");
        
        for (int i=0; i<[self.dareGameTaskPlist dareGameTaskCount]; i++)
        {
            //[gameCardSQ addObject:@"blank_dare@2x.png"];
            UIImage *tImg = [UIImage imageNamed:@"blank_dare.png"];
            [gameCard addObject:tImg];

        }
        
//        for (int i =0; i<[gameCardSQ count]; i++)
//        {
//            UIImage *original = [UIImage imageNamed:[gameCardSQ objectAtIndex:i]];
//            UIImage *rounded = [self makeRoundCornerImage:original :10 :10];
//            
//            [gameCard addObject:rounded];
//        }
        
        for (int i =0; i<[self.dareGameTaskPlist dareGameTaskCount]; i++)
        {
            NSString *tempHStr = [[self.dareGameTaskPlist dareGameItemAtIndex:i]valueForKey:@"header"];
            NSString *tempDStr = [[self.dareGameTaskPlist dareGameItemAtIndex:i]valueForKey:@"details"];
            NSString *tempIconStr = [[self.dareGameTaskPlist dareGameItemAtIndex:i]valueForKey:@"icons"];
            
            [gameHeader addObject:tempHStr];
            [gameDetail addObject:tempDStr];
            [gameIcon addObject:tempIconStr];

        }
    }
        
    self.ToDGameArray = [[NSMutableArray alloc]init];
    self.headerGameNameArray= [[NSMutableArray alloc]init];
    self.detailGameNameArray=[[NSMutableArray alloc]init];
    self.gameIconArray =[[NSMutableArray alloc]init];
    
    NSUInteger count = [gameDetail count];
    
    for (NSUInteger i = 0; i <count; ++i)
    {
        int nElements = count;
        
        int n = (arc4random_uniform(nElements));
        
         [gameHeader exchangeObjectAtIndex:i withObjectAtIndex:n];
         [gameDetail exchangeObjectAtIndex:i withObjectAtIndex:n];
         [gameCard exchangeObjectAtIndex:i withObjectAtIndex:n];
         [gameIcon exchangeObjectAtIndex:i withObjectAtIndex:n];
        //NSLog(@"tempNameArray %@",[tempNameArray objectAtIndex:i]);
        //NSLog(@"imageName %@",[imageName objectAtIndex:i]);
    }
    
    self.ToDGameArray = gameCard;
    self.headerGameNameArray = gameHeader;
    self.detailGameNameArray = gameDetail;
    self.gameIconArray = gameIcon;
    
    NSLog(@"ToDGameArray %@",self.ToDGameArray);
    
    NSLog(@"headerGameNameArray %@",self.headerGameNameArray);
    
     NSLog(@"detailGameNameArray %@",self.detailGameNameArray);
    
         NSLog(@"gameIconArray %@",self.gameIconArray);

    [self.ToDCarouselView reloadData];
}

#pragma mark -
#pragma mark iCarousel methods

- (NSUInteger)numberOfItemsInCarousel:(iCarousel *)carousel
{
    
    //URL
    //////////////////////////////////////////////////////////////////////
    
        //NSLog(@"count %i",[self.picsURLArray count]);
        //return the total number of items in the carousel
        //return [self.picsURLArray count];
    
    //////////////////////////////////////////////////////////////////////
    
    //local
    //////////////////////////////////////////////////////////////////////
    
    //NSLog(@"count %i",[self.picsLocalArray count]);
    //return the total number of items in the carousel 
        
       
    if (carousel == self.carouselView)
    {
        return [self.picsLocalArray count];
    }
    else
    {
        return [self.ToDGameArray count];
    }
    
    //////////////////////////////////////////////////////////////////////

    
}

- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSUInteger)index reusingView:(UIView *)view
{
    //create new view if no view is available for recycling
    if (view == nil)
    {
        //don't do anything specific to the index within
        //this `if (view == nil) {...}` statement because the view will be
        //recycled and used with other index values later
        
        if (carousel ==self.carouselView)
        {
        //load from local
        view = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 250, 250.0f)];
        //((UIImageView *)view).image = [UIImage imageNamed:[self.picsLocalArray objectAtIndex:index]];
             view.contentMode = UIViewContentModeScaleAspectFit;
            view.backgroundColor = [UIColor clearColor];
            
        }
        else
        {
            view = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 248.0f, 290.0f)];
             view.contentMode = UIViewContentModeScaleAspectFit;
            view.backgroundColor = [UIColor clearColor];
        }
        //load from URL
        //view = [[[AsyncImageView alloc] initWithFrame:CGRectMake(0, 0, 250, 250.0f)] autorelease];
       
        
    }
    
    //Load URL
    //////////////////////////////////////////////////////////////////////
    //cancel any previously loading images for this view
    //[[AsyncImageLoader sharedLoader] cancelLoadingImagesForTarget:view];
    
    //set image URL. AsyncImageView class will then dynamically load the image
    //((AsyncImageView *)view).imageURL = [self.picsURLArray objectAtIndex:index];
    //////////////////////////////////////////////////////////////////////


    if (carousel ==self.carouselView)
    {
    //////////////////////////////////////////////////////////////////////
    //load Local
        //NSLog(@"nameArray %@",[self.nameArray objectAtIndex:index]);
        //NSLog(@"picsLocalArray %@",[self.picsLocalArray objectAtIndex:index]);
    //((UIImageView *)view).frame =CGRectMake(0, 0, 140, 140.0f);
    ((UIImageView *)view).image = [self.picsLocalArray objectAtIndex:index];//[UIImage imageNamed:[self.picsLocalArray objectAtIndex:index]];
    
    //////////////////////////////////////////////////////////////////////
    }
    else
    {
    ((UIImageView *)view).image = [self.ToDGameArray objectAtIndex:index];//[UIImage imageNamed:[self.ToDGameArray objectAtIndex:index]];
        
        UILabel *headerLabel = [[UILabel alloc]initWithFrame:CGRectMake(14, 35, 220, 40)];
        headerLabel.backgroundColor = [UIColor clearColor];
        headerLabel.textAlignment = UITextAlignmentCenter;
        headerLabel.lineBreakMode = UILineBreakModeWordWrap;
        headerLabel.numberOfLines = 0;
        headerLabel.textColor = [UIColor darkGrayColor];
        //headerLabel.adjustsFontSizeToFitWidth = YES;
        headerLabel.font = [UIFont fontWithName:@"SorbetLTD" size:20];
        
        UILabel *detailsLabel = [[UILabel alloc]initWithFrame:CGRectMake(16, 200, 215, 65)];
       detailsLabel.backgroundColor = [UIColor clearColor];
       detailsLabel.textAlignment = UITextAlignmentCenter;
       detailsLabel.lineBreakMode = UILineBreakModeWordWrap;
       detailsLabel.numberOfLines = 0;
       detailsLabel.textColor = [UIColor darkGrayColor];
       detailsLabel.font = [UIFont fontWithName:@"SorbetLTD" size:17];
       // detailsLabel.adjustsFontSizeToFitWidth = YES;
        

        NSString *tempString = [self.headerGameNameArray objectAtIndex:index];
        
        if ([tempString isEqualToString:@"-"])
        {
        headerLabel.text = @"";
        }
        else
        {
            headerLabel.text = [self.headerGameNameArray objectAtIndex:index];
        }
        
        detailsLabel.text = [self.detailGameNameArray objectAtIndex:index];

        UIImageView *iconImg = [[UIImageView alloc] initWithFrame:CGRectMake(9,25, 230, 230)];
        iconImg.image = [UIImage imageNamed:[self.gameIconArray objectAtIndex:index]];
        iconImg.backgroundColor = [UIColor clearColor];
        iconImg.contentMode = UIViewContentModeScaleAspectFit;
        //iconImg.alpha = 0.5;
        
        

       [view addSubview:headerLabel];
        [view addSubview:detailsLabel];
        [view addSubview:iconImg];

        
    }
    return view;
}

- (CGFloat)carousel:(iCarousel *)carousel valueForOption:(iCarouselOption)option withDefault:(CGFloat)value
{
    //NSLog(@"value %f",value);
    
    switch (option)
    {
        case iCarouselOptionArc:
        {
            return 2 * M_PI * 1;
        }
        case iCarouselOptionRadius:
        {
            return value * 1.15;
        }
            
        case iCarouselOptionSpacing:
            return value * 1.25;
        default:
            return value;
    }
}

- (void)carouselWillBeginDragging:(iCarousel *)carousel
{
    
    [self.scrollTimer invalidate];
    self.scrollTimer = nil;
    self.nameTag.text = @"";
    spinned = 1;
    self.exitButton.enabled = NO;
}

- (void)carouselWillBeginDecelerating:(iCarousel *)carousel
{
    NSLog(@"called here");
}

- (void)carouselDidEndScrollingAnimation:(iCarousel *)car
{
    [car scrollToItemAtIndex:car.currentItemIndex animated:YES];
    if (spinned ==0)
    {
        self.nameTag.text = @"";
    }
    else if(spinned ==1)
    {
        //self.nameTag.text = [self.nameArray objectAtIndex:car.currentItemIndex];
        //self.active.enabled =YES;
    }
}

#pragma mark -
#pragma mark Truth or Dare Actions

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"stampView"])
    {
        COGViewController *mView = (COGViewController *)[segue destinationViewController];
       
       mView.TCOGView = [self.ToDGameArray objectAtIndex:self.ToDCarouselView.currentItemIndex];
       mView.TiconImg = [UIImage imageNamed:[self.gameIconArray objectAtIndex:self.ToDCarouselView.currentItemIndex]];
        
        mView.Theader = [self.headerGameNameArray objectAtIndex:self.ToDCarouselView.currentItemIndex];
        
       mView.Tdetails = [self.detailGameNameArray objectAtIndex:self.ToDCarouselView.currentItemIndex];
        
        if (isCompleted)
        {
            mView.COGcompleted = YES;
        }
        else
        {
            mView.COGcompleted = NO;
        }
        
        mView.eventID = self.eventID;
        mView.userID = self.userID;

        
    }
    //mView.hidesBottomBarWhenPushed = YES;
    //NSLog(@"text scanner %@",qrToText.textFromScanner);
}

-(IBAction)completeAction:(id)sender
{
    NSLog(@"Completed");
    isCompleted = 1;
    [self performSelector:@selector(hideDoneOrFail) withObject:nil afterDelay:1];
}

-(IBAction)giveUpAction:(id)sender
{
    NSLog(@"i gave up");
    isCompleted = 0;
        [self performSelector:@selector(hideDoneOrFail) withObject:nil afterDelay:1];
}

-(void)showTOD
{
    
    [UIView animateWithDuration:0.6
                     animations:^{
                         
                         if (isPhone568)
                         {
                             self.trueButton.frame = CGRectMake(30,501,97,44);
                             self.dareButton.frame = CGRectMake(215,500,79,46);
                             self.TODView.frame = CGRectMake(0,474,320,74);
                             NSLog(@"iphone 5 show");
                         }
                         else
                         {
                             self.trueButton.frame = CGRectMake(19,415,97,44);
                             self.dareButton.frame = CGRectMake(219,414,79,46);
                             self.TODView.frame = CGRectMake(0,386,320,74);
                             NSLog(@"iphone 4 show");
                         }
                     }
                     completion:^(BOOL  completed)
     {
         //if (completed)
         //[self hideTOD];
         [self removePlayerSpinner];
         
     }
     ];
}

-(void)hideTOD
{
    
    [UIView animateWithDuration:1.0
                     animations:^{
                         
                         if (isPhone568)
                         {
                             self.trueButton.frame = CGRectMake(30,605,118,69);
                             self.dareButton.frame = CGRectMake(184,605,116,68);
                             self.TODView.frame = CGRectMake(0,546,320,167);
                             
                             NSLog(@"iphone 5 hide");
                         }
                         else
                         {
                             self.trueButton.frame = CGRectMake(19,574,97,44);
                             self.dareButton.frame = CGRectMake(219,573,79,46);
                             self.TODView.frame = CGRectMake(0,547,320,74);
                             NSLog(@"iphone 4 hide");
                             
                         }
                     }
     
                     completion:^(BOOL  completed)
     {
         if (completed)
             NSLog(@"hide done");
         [self performSelector:@selector(startTODScrolling) withObject:nil afterDelay:1.5];
         
         NSError *error;
         NSURL *soundurl   = [[NSBundle mainBundle] URLForResource: @"breakbeat_mid" withExtension: @"mp3"];
         self.taskCardSound =[[AVAudioPlayer alloc] initWithContentsOfURL:soundurl error:&error];
         self.taskCardSound .volume=0.5f; //between 0 and 1
         [self.taskCardSound prepareToPlay];
         self.taskCardSound.numberOfLoops=0; //or more if needed
         [self.taskCardSound play];
     }
     ];
    
    
}

-(IBAction)dareAction:(id)sender
{
    truth = 0;
    dare = 1;
    
    [self hideLargeImage];
    [self hideTOD];
}

-(IBAction)trueAction:(id)sender
{
    truth = 1;
    dare = 0;
    
    [self hideLargeImage];
    [self hideTOD];
    
}

-(void)showDoneOrFail
{
    
    [UIView animateWithDuration:0.7
                     animations:^{
                         
//                         if (isPhone568)
//                         {
//                             self.giveUpButton.frame = CGRectMake(20,444,118,69);
//                             self.completeButton.frame = CGRectMake(184,444,116,68);
//                             self.TODView.frame = CGRectMake(0,385,320,167);
//                             NSLog(@"iphone 5 show");
//                         }
//                         else
//                         {
//                             self.giveUpButton.frame = CGRectMake(20,415,102,39);
//                             self.completeButton.frame = CGRectMake(190,414,130,41);
//                             self.COGView.frame = CGRectMake(0,385,320,74);
//                             NSLog(@"iphone 4 show");
//                         }
                         self.giveUpButton.frame = CGRectMake(20,[[UIScreen mainScreen] bounds].size.height-65,102,39);
                         self.completeButton.frame = CGRectMake(190,[[UIScreen mainScreen] bounds].size.height-66,130,41);
                         self.COGView.frame = CGRectMake(0,[[UIScreen mainScreen] bounds].size.height-95,320,74);
                     }
     
      completion:^(BOOL  completed)
        {
    
        }
     ];
    
    //[self.taskCardSound stop];
    
    [self doVolumeFade];

}

-(void)hideDoneOrFail
{
    
    [UIView animateWithDuration:0.7
                     animations:^{
                         
//                         if (isPhone568)
//                         {
//                             self.giveUpButton.frame = CGRectMake(20,444,118,69);
//                             self.completeButton.frame = CGRectMake(184,444,116,68);
//                             self.TODView.frame = CGRectMake(0,385,320,167);
//                             NSLog(@"iphone 5 show");
//                         }
//                         else
//                         {
//                             self.giveUpButton.frame = CGRectMake(20,488,102,39);
//                             self.completeButton.frame = CGRectMake(190,487,130,41);
//                             self.COGView.frame = CGRectMake(0,458,320,74);
//                             NSLog(@"iphone 4 show");
//                         }
                         self.giveUpButton.frame = CGRectMake(20,[[UIScreen mainScreen] bounds].size.height+8,102,39);
                         self.completeButton.frame = CGRectMake(190,[[UIScreen mainScreen] bounds].size.height+7,130,41);
                         self.COGView.frame = CGRectMake(0,[[UIScreen mainScreen] bounds].size.height-22,320,74);
                     }
     
                     completion:^(BOOL  completed)
                    {
                        [self performSegueWithIdentifier:@"stampView" sender:nil];
                        [self performSelector:@selector(resetSpinner) withObject:nil afterDelay:3];
                        
                        
                    }
     ];
    
    //[self.taskCardSound stop];
    
    [self doVolumeFade];
    
}

-(void)doVolumeFade
{
    if (self.taskCardSound.volume > 0.1) {
        self.taskCardSound.volume = self.taskCardSound.volume - 0.1;
        [self performSelector:@selector(doVolumeFade) withObject:nil afterDelay:0.1];
    }
    else
    {
        // Stop and get the sound ready for playing again
        [self.taskCardSound stop];
        self.taskCardSound.currentTime = 0;
        [self.taskCardSound prepareToPlay];
        self.taskCardSound.volume = 1.0;
    }
}

-(void)spinVolumeFade
{
    if (self.spinningSound.volume > 0.3) {
        self.spinningSound.volume = self.spinningSound.volume - 0.1;
        [self performSelector:@selector(spinVolumeFade) withObject:nil afterDelay:0.1];
    }
    else
    {
        // Stop and get the sound ready for playing again
        [self.spinningSound stop];
        self.spinningSound.currentTime = 0;
        [self.spinningSound prepareToPlay];
        self.spinningSound.volume = 1.0;
    }

    
}


#pragma mark -
#pragma mark level Actions

-(void)setUpLever
{
    
    self.fullArray = [NSArray arrayWithObjects:
                          [UIImage imageNamed:@"1.png"],
                          [UIImage imageNamed:@"2.png"],
                          [UIImage imageNamed:@"3.png"],
                          [UIImage imageNamed:@"4.png"],
                          [UIImage imageNamed:@"5.png"],
                          [UIImage imageNamed:@"6.png"],
                          [UIImage imageNamed:@"7.png"],
                          [UIImage imageNamed:@"8.png"],
                          [UIImage imageNamed:@"9.png"],
                          [UIImage imageNamed:@"10.png"],
                          [UIImage imageNamed:@"11.png"],
                          [UIImage imageNamed:@"10.png"],
                          [UIImage imageNamed:@"9.png"],
                          [UIImage imageNamed:@"8.png"],
                          [UIImage imageNamed:@"7.png"],
                          [UIImage imageNamed:@"6.png"],
                          [UIImage imageNamed:@"5.png"],
                          [UIImage imageNamed:@"4.png"],
                          [UIImage imageNamed:@"3.png"],
                          [UIImage imageNamed:@"2.png"],
                          [UIImage imageNamed:@"1.png"],nil];
    
    self.halfArray = [NSArray arrayWithObjects:
                      [UIImage imageNamed:@"11.png"],
                      [UIImage imageNamed:@"10.png"],
                      [UIImage imageNamed:@"9.png"],
                      [UIImage imageNamed:@"8.png"],
                      [UIImage imageNamed:@"7.png"],
                      [UIImage imageNamed:@"6.png"],
                      [UIImage imageNamed:@"5.png"],
                      [UIImage imageNamed:@"4.png"],
                      [UIImage imageNamed:@"3.png"],
                      [UIImage imageNamed:@"2.png"],
                      [UIImage imageNamed:@"1.png"],nil];
    
    self.downCompleteArray = [NSMutableArray arrayWithObjects:
                              [UIImage imageNamed:@"7.png"],
                              [UIImage imageNamed:@"8.png"],
                              [UIImage imageNamed:@"9.png"],
                              [UIImage imageNamed:@"10.png"],
                              [UIImage imageNamed:@"11.png"],
                              [UIImage imageNamed:@"10.png"],
                              [UIImage imageNamed:@"9.png"],
                              [UIImage imageNamed:@"8.png"],
                              [UIImage imageNamed:@"7.png"],
                              [UIImage imageNamed:@"6.png"],
                              [UIImage imageNamed:@"5.png"],
                              [UIImage imageNamed:@"4.png"],
                              [UIImage imageNamed:@"3.png"],
                              [UIImage imageNamed:@"2.png"],
                              [UIImage imageNamed:@"1.png"],nil];

    
    self.upCompleteArray = [NSMutableArray arrayWithObjects:
                              [UIImage imageNamed:@"6.png"],
                              [UIImage imageNamed:@"5.png"],
                              [UIImage imageNamed:@"4.png"],
                              [UIImage imageNamed:@"3.png"],
                              [UIImage imageNamed:@"2.png"],
                              [UIImage imageNamed:@"1.png"],nil];

    
    leverStage =1;
    panRecog = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(handlePan:)];
    [self.levelImgView setUserInteractionEnabled:YES];
    [self.levelImgView addGestureRecognizer:panRecog];
    
    tapRecog = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleTap:)];
    [self.levelImgView addGestureRecognizer:tapRecog];

}

-(void)handleTap:(UITapGestureRecognizer *)recognizer
{
    NSLog(@"calllllllllll here");
    [self leverFullAnimation];
    
    [self performSelector:@selector(spinTheWheel:) withObject:nil afterDelay:0.1];
    [self.levelImgView setUserInteractionEnabled:NO];
}

-(void)handlePan:(UIPanGestureRecognizer *)recognizer
{
    //    if (!(CGRectIntersectsRect(imgView1.frame, imgView2.frame)))
    //    {
    CGPoint pre_moveLocation = [recognizer locationInView:recognizer.view];
    //NSLog(@"previous location %@",NSStringFromCGPoint(pre_moveLocation));
    int userFingerLoc;
    
    //NSLog(@"pulldown %i",pulledDown);
    
    
    if (pulledDown)
    {
        //NSLog(@"userFingerLoc = 0");
        userFingerLoc = 0;
    }
    else if(!pulledDown)
    {
    //NSLog(@"userFingerLoc = pre_move");
    userFingerLoc = ((int)pre_moveLocation.y);
    }
    
    //NSLog(@"previous location %i",(int)pre_moveLocation.y);
        
    if ( [recognizer state] == UIGestureRecognizerStateChanged )
    {
        //NSLog(@"UIGestureRecognizerStateChanged");
        
        if (!pulledDown)
        {
            if (userFingerLoc < 55)
            {
                    leverStage =1;
                self.levelImgView.image =[UIImage imageNamed:@"1.png"];
            }
            if (userFingerLoc >= 55)
            {
                    leverStage =2;
                self.levelImgView.image =[UIImage imageNamed:@"2.png"];
            }
            if (userFingerLoc >= 83)
            {
                    leverStage =3;
                self.levelImgView.image =[UIImage imageNamed:@"3.png"];
            }
            if (userFingerLoc >= 115)
            {
                    leverStage =4;
                self.levelImgView.image =[UIImage imageNamed:@"4.png"];
            }
            if (userFingerLoc >= 148)
            {
                    leverStage =5;
                self.levelImgView.image =[UIImage imageNamed:@"5.png"];
            }
            if (userFingerLoc >= 178)
            {
                    leverStage =6;
                self.levelImgView.image =[UIImage imageNamed:@"6.png"];
            }
            if (userFingerLoc >= 212)
            {
                    leverStage =7;
                self.levelImgView.image =[UIImage imageNamed:@"7.png"];
            }
            if (userFingerLoc >= 248)
            {
                    leverStage =8;
                self.levelImgView.image =[UIImage imageNamed:@"8.png"];
            }
            if (userFingerLoc >= 284)
            {
                    leverStage =9;
                self.levelImgView.image =[UIImage imageNamed:@"9.png"];
            }
            if (userFingerLoc >= 315)
            {
                    leverStage =10;
                self.levelImgView.image =[UIImage imageNamed:@"10.png"];
            }
            if (userFingerLoc >= 345)
            {
                pulledDown = 1;
                    leverStage =11;
                self.levelImgView.image =[UIImage imageNamed:@"11.png"];
               
                NSLog(@"last");
            }
        }
    }
    else if ( [recognizer state] == UIGestureRecognizerStateEnded )
    {
        if (pulledDown)
        {
            NSLog(@"UIGestureRecognizerStateEnded");
             [self performSelector:@selector(leverBackAnimation) withObject:nil afterDelay:0.1];
            [self spinTheWheel:nil];
        }
        else
        {
            NSLog(@"not pull down called here");
            [self performSelector:@selector(completeAnimation:) withObject:[NSNumber numberWithInt:leverStage] afterDelay:0.15];
        }
    }
}

-(void)setImgbackTofirst
{
     NSLog(@"setImgbackTofirst");
    self.levelImgView.image =[UIImage imageNamed:@"1.png"];
}

-(void)leverBackAnimation
{
    NSLog(@"called");
    //[self.levelImgView removeGestureRecognizer:panRecog];
    [self.levelImgView setUserInteractionEnabled:NO];
    
    [self setImgbackTofirst];
    // load all the frames of our animation
    self.levelImgView.animationImages = self.halfArray;
    
    // all frames will execute in 0.45 seconds
    self.levelImgView.animationDuration = 0.45;
    // animationRepeatCount 1 time
    self.levelImgView.animationRepeatCount = 1;
    // start animating
    [self.levelImgView startAnimating];
}

-(void)leverFullAnimation
{
    [self setImgbackTofirst];
       // load all the frames of our animation
    self.levelImgView.animationImages = self.fullArray;
    
    // all frames will execute in 1.75 seconds
    self.levelImgView.animationDuration = 0.35;
    // repeat the annimation forever
    self.levelImgView.animationRepeatCount = 1;
    // start animating
      [self.levelImgView startAnimating];
}

-(void)completeAnimation:(NSNumber*)lever
{
  
    
    NSLog(@"lever no %i", [lever intValue]);
          
    NSMutableArray *tempArray = [[NSMutableArray alloc]init];
        
    if ([lever intValue] >=7)
    {
         [self spinTheWheel:nil];
        //down
        NSLog(@"DOWN!!!! lever no %i", [lever intValue]);
        
        tempArray = [self.downCompleteArray mutableCopy];
        for (int i = 0 ; i<= 6 - [lever intValue]; i++)
        {
            [tempArray removeObjectAtIndex:0];
        }
        
        [self setImgbackTofirst];
        // load all the frames of our animation
        self.levelImgView.animationImages = tempArray;
        // all frames will execute in 1.75 seconds
        self.levelImgView.animationDuration = 0.5;
        // repeat the annimation forever
        self.levelImgView.animationRepeatCount = 1;
        // start animating
        [self.levelImgView startAnimating];
       
           [self.levelImgView setUserInteractionEnabled:NO];
    }
    else
    {
        //up
        tempArray = [self.upCompleteArray mutableCopy];
        for (int i = 0 ; i<= 6 - [lever intValue]; i++)
        {
            [tempArray removeObjectAtIndex:0];
        }
    
        [self setImgbackTofirst];
        // load all the frames of our animation
        self.levelImgView.animationImages = tempArray;
        // all frames will execute in 1.75 seconds
        self.levelImgView.animationDuration = 0.15;
        // repeat the annimation forever
        self.levelImgView.animationRepeatCount = 1;
        // start animating
        [self.levelImgView startAnimating];
    }
    
  
    
}

#pragma mark -
#pragma mark Spinner

-(void)setTimerForSpinner
{
    firstScroll = (arc4random() % 3) + 2;
    slowDownScroll = (arc4random() % 3) + 2;
    endingScroll = (arc4random() % 4) + 2;
    
    NSLog(@"first %i",firstScroll);
        NSLog(@"slowDownScroll %i",slowDownScroll);
        NSLog(@"endingScroll %i",endingScroll);
    
    //[self performSelector:@selector(setTimerForSpinner) withObject:nil afterDelay:1];
}

-(IBAction)spinTheWheel:(id)sender
{
    [self setTimerForSpinner];
    
    [self performSelector:@selector(startScrolling) withObject:nil afterDelay:0.4];
   // [self startScrolling];
    
    self.exitButton.enabled = NO;
    self.nameTag.text = @"";
    spinned =0;
    
    self.carouselView.scrollEnabled = NO;
    self.carouselView.centerItemWhenSelected = NO;
}

- (void)startScrolling
{
    [self.scrollTimer invalidate];
    self.scrollTimer = [NSTimer scheduledTimerWithTimeInterval:1.0/60.0
                                                   target:self
                                                 selector:@selector(scrollStep)
                                                 userInfo:nil
                                                  repeats:YES];
    [self performSelector:@selector(slowScrolling) withObject:nil afterDelay:firstScroll];
    
    
    NSError *error;
    NSURL *soundurl   = [[NSBundle mainBundle] URLForResource: @"spinning" withExtension: @"mp3"];
    self.spinningSound =[[AVAudioPlayer alloc] initWithContentsOfURL:soundurl error:&error];
    self.spinningSound .volume=0.7f; //between 0 and 1
    [self.spinningSound prepareToPlay];
    self.spinningSound.numberOfLoops=0; //or more if needed
    [self.spinningSound play];

    
}

- (void)stopScrolling
{
    [self spinVolumeFade];

//   NSLog(@"called");
    [self.scrollTimer invalidate];
    self.scrollTimer = nil;   
    [self.carouselView  scrollToItemAtIndex:self.carouselView.currentItemIndex duration:1.0f];
    self.nameTag.text = [self.nameArray objectAtIndex:self.carouselView.currentItemIndex];
    self.userID = [self.userIDArray objectAtIndex:self.carouselView.currentItemIndex];
    NSLog(@"name %@",self.nameTag.text);
    spinned = 1;
    
//    SystemSoundID soundID;
//    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"bingo" ofType:@"mp3"];
//    
//    NSURL *fileUrl = [NSURL fileURLWithPath:filePath];
//    AudioServicesCreateSystemSoundID((__bridge CFURLRef)fileUrl, &soundID);
//    AudioServicesPlaySystemSound(soundID);
    
    [self performSelector:@selector(imageViewPopup) withObject:nil afterDelay:1];
    
    NSError *error;
    NSURL *soundurl   = [[NSBundle mainBundle] URLForResource: @"bingo" withExtension: @"mp3"];
    self.selectedSound =[[AVAudioPlayer alloc] initWithContentsOfURL:soundurl error:&error];
    self.selectedSound .volume=0.5f; //between 0 and 1
    [self.selectedSound prepareToPlay];
    self.selectedSound.numberOfLoops=0; //or more if needed
    [self.selectedSound play];
    
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);

}

- (void)scrollStep
{
    //calculate delta time
    NSTimeInterval now = [NSDate timeIntervalSinceReferenceDate];
    float delta = self.lastTime - now;
    self.lastTime = now;
    
    //don't autoscroll when user is manipulating carousel
    if (!self.carouselView.dragging && !self.carouselView.decelerating)
    {
        //scroll carousel
        self.carouselView.scrollOffset += delta * (float)(SCROLL_SPEED);
    }
}

- (void)slowScrolling
{
    [self.scrollTimer invalidate];
    self.scrollTimer = [NSTimer scheduledTimerWithTimeInterval:1.0/60.0
                                                        target:self
                                                      selector:@selector(slowDownScrollStep)
                                                      userInfo:nil
                                                       repeats:YES];
    [self performSelector:@selector(endingScrolling) withObject:nil afterDelay:slowDownScroll];

    
}

- (void)slowDownScrollStep
{
    //calculate delta time
    NSTimeInterval now = [NSDate timeIntervalSinceReferenceDate];
    float delta = self.lastTime - now;
    self.lastTime = now;
    
    //don't autoscroll when user is manipulating carousel
    if (!self.carouselView.dragging && !self.carouselView.decelerating)
    {
        //scroll carousel
        self.carouselView.scrollOffset += delta * (float)(SCROLL_SPEED1);
    }
    
}

- (void)endingScrolling
{
    [self.scrollTimer invalidate];
    self.scrollTimer = [NSTimer scheduledTimerWithTimeInterval:1.0/60.0
                                                        target:self
                                                      selector:@selector(endingScrollStep)
                                                      userInfo:nil
                                                       repeats:YES];
    [self performSelector:@selector(stopScrolling) withObject:nil afterDelay:endingScroll];
}

- (void)endingScrollStep
{
    //calculate delta time
    NSTimeInterval now = [NSDate timeIntervalSinceReferenceDate];
    float delta = self.lastTime - now;
    self.lastTime = now;
    
    //don't autoscroll when user is manipulating carousel
    if (!self.carouselView.dragging && !self.carouselView.decelerating)
    {
        //scroll carousel
        self.carouselView.scrollOffset += delta * (float)(SCROLL_SPEED2);
    }    
}

-(void)enableButton
{
    self.exitButton.enabled =YES;
    self.carouselView.scrollEnabled = YES;
    self.carouselView.centerItemWhenSelected = YES;
}

- (void) hideLargeImage
{
     [self setupTODData];
    
    [UIView animateWithDuration:0.2
                     animations:^{
                            [self.nameTag setAlpha:0.0];
                     }
                     completion:^(BOOL finished){
                         
                     }
     ];
  
    [UIView animateWithDuration:1.2
                     animations:^{
                         [self.alphaOverlay setAlpha:0.0];
                         [self.largeImgView setFrame:imageLocation];
                         //[self.active setAlpha:1.0];
                         [self.nameTag setAlpha:0.0];
                     }
                     completion:^(BOOL finished){
                        
                         [self.exitButton setEnabled:YES];
                         self.largeImageView.hidden=NO;
                         //self.largeImageView.hidden=YES;
                         //[self.largeImgView removeFromSuperview];
                         
                     }
     ];
    
    
    
}

- (void)imageViewPopup
{
    //Load URL
    //////////////////////////////////////////////////////////////////////
    //UIImageView *selectorView = [[AsyncImageView alloc] initWithFrame:CGRectMake(0, 105, 250, 250.0f)];
    //selectorView.contentMode = UIViewContentModeScaleAspectFit;
    //selectorView.backgroundColor = [UIColor clearColor];
    
    //[[AsyncImageLoader sharedLoader] cancelLoadingImagesForTarget:selectorView];
    //((AsyncImageView *)selectorView).imageURL = [self.picsLocalArray objectAtIndex:self.carouselView.currentItemIndex];
    //////////////////////////////////////////////////////////////////////

    //Load Local
    //////////////////////////////////////////////////////////////////////
    UIImageView *selectorView = [[UIImageView alloc] initWithFrame:CGRectMake(-5, 105, 250.0f, 250.0f)];
    selectorView.contentMode = UIViewContentModeScaleAspectFit;//UIViewContentModeScaleAspectFit;
    selectorView.backgroundColor = [UIColor clearColor];
    //selectorView.image = [UIImage imageNamed:[self.picsLocalArray objectAtIndex:self.carouselView.currentItemIndex]];
    selectorView.image = [self.picsLocalArray objectAtIndex:self.carouselView.currentItemIndex];
    //////////////////////////////////////////////////////////////////////

    //UIImageView *imgView = selectorView;
    
    self.largeImgView=selectorView;
    
    [self.largeImageView addSubview:self.largeImgView];
    
    //orginal location
    //imageLocation=CGRectMake(selectorView.frame.origin.x, selectorView.frame.origin.y, selectorView.frame.size.width, selectorView.frame.size.height);
    imageLocation=CGRectMake(115,5,90,90);
    self.largeImageView.hidden=YES;
    
    [UIView beginAnimations:nil context:nil];
    
    [self.crosshairView setAlpha:0];
    [UIView commitAnimations];
    
    [UIView animateWithDuration:0.5
                     animations:^{
                         [self.exitButton setAlpha:0.0];
                         [self.levelImgView setAlpha:0.0];
                         //self.largeImageView.alpha =1;
                        [self.alphaOverlay setAlpha:1.0];
                         
                     }
     
                     completion:^(BOOL  completed)
     {
         if (completed)
             NSLog(@"set BG done");
     }
     ];
    
    [UIView animateWithDuration:1.0
                     animations:^{
                           self.largeImageView.hidden=NO;
                          //[self.largeImageBackgroundView setAlpha:1.0];
                         self.largeImgView.frame=CGRectMake(50, 10, 230, 230.0f);
                         self.nameTag.alpha=1.0;
                         }
     
    completion:^(BOOL  completed)
     {
         if (completed)
             NSLog(@"show big pics done");
         [self performSelector:@selector(showTOD) withObject:nil afterDelay:0.2];
     }
     ];
}

-(void)removePlayerSpinner;
{
    if (self.carouselView.numberOfItems > 0)
    {
        [self.picsLocalArray removeAllObjects];
        [self.carouselView reloadData];
    }
}

-(void)removeTODSpinner
{
    if (self.ToDCarouselView.numberOfItems > 0)
    {
        [self.ToDGameArray removeAllObjects];
         [self.headerGameNameArray removeAllObjects];
         [self.detailGameNameArray removeAllObjects];
         [self.gameIconArray removeAllObjects];

        [self.ToDCarouselView reloadData];
    }
    
}

#pragma mark -
#pragma mark TODspinner
- (void)startTODScrolling
{
    NSLog(@" self.ToDGameArray %i",[self.ToDGameArray count]);

    
    [self.scrollTimer invalidate];
    self.scrollTimer = [NSTimer scheduledTimerWithTimeInterval:1.0/60.0
                                                        target:self
                                                      selector:@selector(TODScrollStep)
                                                      userInfo:nil
                                                       repeats:YES];
    [self performSelector:@selector(slowTODScrolling) withObject:nil afterDelay:firstScroll];
}

- (void)stopTODScrolling
{
    
    //   NSLog(@"called");
    [self.scrollTimer invalidate];
    self.scrollTimer = nil;
    [self.ToDCarouselView  scrollToItemAtIndex:self.ToDCarouselView.currentItemIndex duration:1.0f];
    
    
    
    
    NSLog(@"game CARD %@",[self.ToDGameArray objectAtIndex:self.ToDCarouselView.currentItemIndex]);
    NSLog(@"gameIconArray %@",[self.gameIconArray objectAtIndex:self.ToDCarouselView.currentItemIndex]);
    NSLog(@"detailGameNameArray %@",[self.detailGameNameArray objectAtIndex:self.ToDCarouselView.currentItemIndex]);
    NSLog(@"headerGameNameArray %@",[self.headerGameNameArray objectAtIndex:self.ToDCarouselView.currentItemIndex]);

    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    
     [self performSelector:@selector(showDoneOrFail) withObject:nil afterDelay:1];
}

- (void)TODScrollStep
{
    //calculate delta time
    NSTimeInterval now = [NSDate timeIntervalSinceReferenceDate];
    float delta = self.lastTime - now;
    self.lastTime = now;
    
    //don't autoscroll when user is manipulating carousel
    if (!self.ToDCarouselView.dragging && !self.ToDCarouselView.decelerating)
    {
        //scroll carousel
        self.ToDCarouselView.scrollOffset += delta * (float)(-SCROLL_SPEEDTOD);
    }
}

- (void)slowTODScrolling
{
    [self.scrollTimer invalidate];
    self.scrollTimer = [NSTimer scheduledTimerWithTimeInterval:1.0/60.0
                                                        target:self
                                                      selector:@selector(slowDownTODScrollStep)
                                                      userInfo:nil
                                                       repeats:YES];
    [self performSelector:@selector(endingTODScrolling) withObject:nil afterDelay:slowDownScroll];

}

- (void)slowDownTODScrollStep
{
    //calculate delta time
    NSTimeInterval now = [NSDate timeIntervalSinceReferenceDate];
    float delta = self.lastTime - now;
    self.lastTime = now;
    
    //don't autoscroll when user is manipulating carousel
    if (!self.ToDCarouselView.dragging && !self.ToDCarouselView.decelerating)
    {
        //scroll carousel
        self.ToDCarouselView.scrollOffset += delta * (float)(-SCROLL_SPEEDTOD2);
    }
}

- (void)endingTODScrolling
{
    [self.scrollTimer invalidate];
    self.scrollTimer = [NSTimer scheduledTimerWithTimeInterval:1.0/60.0
                                                        target:self
                                                      selector:@selector(endingTODScrollStep)
                                                      userInfo:nil
                                                       repeats:YES];
    [self performSelector:@selector(stopTODScrolling) withObject:nil afterDelay:endingScroll+2];
}

- (void)endingTODScrollStep
{
    //calculate delta time
    NSTimeInterval now = [NSDate timeIntervalSinceReferenceDate];
    float delta = self.lastTime - now;
    self.lastTime = now;
    
    //don't autoscroll when user is manipulating carousel
    if (!self.ToDCarouselView.dragging && !self.ToDCarouselView.decelerating)
    {
        //scroll carousel
        self.ToDCarouselView.scrollOffset += delta * (float)(-SCROLL_SPEED2);
    }    
}


//segue

- (IBAction)backFromCOG:(UIStoryboardSegue *)segue {
    // Optional place to read data from closing controller
}

@end
