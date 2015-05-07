//
//  QDViewController.m
//  gno
//
//  Created by calvin on 26/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "QDViewController.h"
#import "EmergencyViewController.h"

@interface QDViewController ()

@end

@implementation QDViewController
@synthesize tilesView;
@synthesize photoItems,titleItems,phoneItems,quickDialItems,friendsList,eventDBID;

- (void)viewDidLoad
{    
    
    //[[self delegate] mapPinDidFinish:self];
    
    [super viewDidLoad];
    appDelegate=(AppDelegate*)[[UIApplication sharedApplication] delegate];
    [[NSNotificationCenter defaultCenter]  addObserver:self selector:@selector(refreshQuickDial:) name:@"refreshQuickDial" object:nil];

    //NSLog(@"titel item %@",self.titleItems);
    
}
- (void)viewWillAppear:(BOOL)animated
{
    if ([[self.tilesView subviews] count]>0) {
        [[[self.tilesView subviews] objectAtIndex:0] removeFromSuperview];
    }
    [self initDataFromArray];
}
- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}
-(void)refreshQuickDial:(NSNotification*) notification{
    _icons=nil;
    _gridView=nil;
    _draggingCell=nil;
    for (int i=0; i<[[tilesView subviews] count]; i++) {
        [[[tilesView subviews] objectAtIndex:i] removeFromSuperview];
    }
//    _emptyCellIndex;
//    
//    NSUInteger _dragOriginIndex;
//    CGPoint _dragOriginCellOrigin;
    
    
    [self initDataFromArray];
}
-(void)initDataFromArray
{
    NSMutableDictionary *dic=[appDelegate.eventsManager getEventDictionaryByEventID:eventDBID];
    NSLog(@"%@",dic);
    friendsList=[[NSMutableArray alloc] init];
    [friendsList addObjectsFromArray:[dic objectForKey:@"eventFriends"]];
    
//    self.phoneItems = [[NSMutableArray array] init];
    self.titleItems = [[NSMutableArray alloc] init];
//    self.photoItems = [[NSMutableArray alloc] init];
//    self.phoneItems = [[NSMutableArray alloc] init];
//    NSLog(@"%@",friendsList);
    for (int i=0; i<[friendsList count]; i++) {
        NSMutableDictionary *dic=[[NSMutableDictionary alloc] init];
        [dic setObject:[[[friendsList objectAtIndex:i] objectForKey:@"userID"] objectForKey:@"userName"] forKey:@"userName"];
        [dic setObject:[[[friendsList objectAtIndex:i] objectForKey:@"userID"] objectForKey:@"photosDBID"] forKey:@"photosDBID"];
        
        
                
        for (int j=0; j<[appDelegate.friendsManager.friendsList count]; j++) {
            if ([[[appDelegate.friendsManager.friendsList objectAtIndex:j] objectForKey:@"userDBID"] intValue]==[[[[friendsList objectAtIndex:i] objectForKey:@"userID"] objectForKey:@"userDBID"] intValue]) {
                if ([[[appDelegate.friendsManager.friendsList objectAtIndex:j] objectForKey:@"mobilePhone"] length]!=0) {
                    [dic setObject:[NSString stringWithFormat:@"%@",[[appDelegate.friendsManager.friendsList objectAtIndex:j] objectForKey:@"mobilePhone"]] forKey:@"mobilePhone"];
                    break;
                }
                else
                {
                    [dic setObject:[NSString stringWithFormat:@""] forKey:@"mobilePhone"];
                }
            }
        }
        [self.titleItems addObject:dic];
    }
    NSLog(@"%@",self.titleItems);
    [self.titleItems sortUsingSelector:@selector(quickDialUserNameCompareMethodWithDict:)];
    NSLog(@"%@",self.titleItems);

//    self.titleItems = [[NSMutableArray alloc] initWithObjects:
//                       @"Desmond", 
//                       @"Andy",
//                       @"Johannes",
//                       @"Tony",
//                       @"Zac", 
//                       @"Calvin",
//                       @"Dian", 
//                       @"Jimmy", 
//                       @"Launa", 
//                       @"Wei", 
//                       @"Michael",
//                       @"Ivan",@"Desmond",
//                       @"Andy",
//                       @"Johannes",
//                       @"Tony",
//                       @"Zac",
//                       @"Calvin",
//                       @"Dian",
//                       @"Jimmy",
//                       @"Launa",
//                       @"Wei",
//                       @"Michael",
//                       @"Ivan",nil];
//    
//    self.photoItems = [[NSMutableArray alloc] initWithObjects:
//                       @"Des.png",
//                       @"Andy.png",
//                       @"Jo.png",
//                       @"Tony.png",
//                       @"Zac.png",
//                       @"Cal.png",
//                       @"Dian.png",
//                       @"Jimmy.png",
//                       @"Launa.png",
//                       @"Wei.png",
//                       @"Mi.png",                                   
//                       @"Ivan.png",
//                       @"Des.png",
//                       @"Andy.png",
//                       @"Jo.png",
//                       @"Tony.png",
//                       @"Zac.png",
//                       @"Cal.png",
//                       @"Dian.png",
//                       @"Jimmy.png",
//                       @"Launa.png",
//                       @"Wei.png",
//                       @"Mi.png",
//                       @"Ivan.png",nil];
    
//    NSLog(@"title %i",[self.titleItems count]);
//    NSLog(@"photo %i",[self.photoItems count]);
    
    _emptyCellIndex = NSNotFound;
    self.tilesView.autoresizesSubviews = YES;
    
    
    // grid view sits on top of the background image
    _gridView = [[AQGridView alloc] initWithFrame: CGRectMake(5.0f, 5.0f, 310, 285)];
    _gridView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    _gridView.backgroundColor = [UIColor clearColor];
    _gridView.opaque = YES;
    _gridView.layoutDirection = AQGridViewLayoutDirectionVertical;
    _gridView.dataSource = self;
    _gridView.delegate = self;
    _gridView.scrollEnabled = YES;
    
    //[self.view addSubview: _gridView];
    [self.tilesView addSubview: _gridView];
    
    if ( _icons == nil )
    {
        _icons = [[NSMutableArray alloc] initWithCapacity: [self.titleItems count]];
        UIBezierPath * path = [UIBezierPath bezierPathWithRoundedRect: CGRectMake(0.0, 0.0, 72.0, 72.0)
                                                         cornerRadius: 18.0];
        NSUInteger x = 0;
        CGFloat saturation = 0.6, brightness = 0.7;
        for ( NSUInteger i = 0; i < [self.titleItems count]; i++ )
        {
            NSLog(@"i %i",i);
            UIColor * color = [UIColor colorWithHue: (CGFloat)i/20.0
                                         saturation: saturation
                                         brightness: brightness
                                              alpha: 1.0];
            
            UIGraphicsBeginImageContext( CGSizeMake(72.0, 72.0) );
            
            // clear background
            [[UIColor clearColor] set];
            UIRectFill( CGRectMake(0.0, 0.0, 72.0, 72.0) );
            
            // fill the rounded rectangle
            [color set];
            [path fill];
			
			UIImage *image;
			UIImage *roundedImage;
            
            ////////////////////////////////////////
            if ([[[self.titleItems objectAtIndex:i] objectForKey:@"photosDBID"] intValue]!=0) {
                image=[[appDelegate photoManager] getPhotoByPhotoDBID:[[self.titleItems objectAtIndex:i] objectForKey:@"photosDBID"]];
            }
            else {
                image=[UIImage imageNamed:@"Persondot.png"];
            }
            ////////////////////////////////////////
            
            
			if (i == x)
            {
//                image = [UIImage imageNamed:[self.photoItems objectAtIndex:i]];
                CALayer *imageLayer = [CALayer layer];
                imageLayer.frame = CGRectMake(0, 0, image.size.width, image.size.height);
                imageLayer.contents = (id) image.CGImage;
                imageLayer.masksToBounds = YES;
                imageLayer.cornerRadius = 20.0;
                UIGraphicsBeginImageContext(image.size);
                [imageLayer renderInContext:UIGraphicsGetCurrentContext()];
                roundedImage = UIGraphicsGetImageFromCurrentImageContext();
            }
			else image = UIGraphicsGetImageFromCurrentImageContext();
            
			UIGraphicsEndImageContext();
            // put the image into our list
            [_icons addObject: roundedImage];
            x++;
            NSLog(@"x %i",x);
        }
        NSLog(@"_icons array %@",_icons);
    }
    [_gridView reloadData];    
}


#pragma mark -
#pragma mark GridView Delegate

- (void) gridView: (AQGridView *) gridView didSelectItemAtIndex: (NSUInteger) index
{
	[gridView deselectItemAtIndex:index animated:YES];
	
    
    NSString *phone=[[self.titleItems objectAtIndex:index] objectForKey:@"mobilePhone"];
    if ([phone length]!=0) {
        NSString *phoneStr=[NSString stringWithFormat:@"telprompt:%@",phone];
        UIDevice *device = [UIDevice currentDevice];
        
        if ([[device model] isEqualToString:@"iPhone"])
        {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneStr]];
            
        } else
        {
            UIAlertView *Notpermitted=[[UIAlertView alloc] initWithTitle:@"Alert" message:@"Your device doesn't support this feature." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [Notpermitted show];
        }
    }
    else{
        NSString *Title;
        
        Title = [[self.titleItems objectAtIndex:index] objectForKey:@"userName"];
        
        NSLog(@"title %@",Title);
        
        NSString *msgStr = [NSString stringWithFormat:@"%@ did not share the phone",Title];
        
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Caller" message:msgStr delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];

    }

}

#pragma mark -
#pragma mark GridView Data Source

- (NSUInteger) numberOfItemsInGridView: (AQGridView *) gridView
{
    return ( [_icons count] );
}

- (AQGridViewCell *) gridView: (AQGridView *) gridView cellForItemAtIndex: (NSUInteger) index
{
    static NSString * EmptyIdentifier = @"EmptyIdentifier";
    static NSString * CellIdentifier = @"CellIdentifier";
    
    if ( index == _emptyCellIndex )
    {
        NSLog( @"Loading empty cell at index %u", index );
        AQGridViewCell * hiddenCell = [gridView dequeueReusableCellWithIdentifier: EmptyIdentifier];
        if ( hiddenCell == nil )
        {
            // must be the SAME SIZE AS THE OTHERS
            // Yes, this is probably a bug. Sigh. Look at -[AQGridView fixCellsFromAnimation] to fix
            hiddenCell = [[AQGridViewCell alloc] initWithFrame: CGRectMake(0.0, 0.0, 72.0, 60.0)
                                               reuseIdentifier: EmptyIdentifier];
        }
        
        hiddenCell.hidden = YES;
        return ( hiddenCell );
    }
    
    springboardIconCell * cell = (springboardIconCell *)[gridView dequeueReusableCellWithIdentifier: CellIdentifier];
    if ( cell == nil )
    {
        cell = [[springboardIconCell alloc] initWithFrame: CGRectMake(0.0, 0.0, 90, 90.0) reuseIdentifier: CellIdentifier];
    }
    
	cell.selectionStyle = AQGridViewCellSelectionStyleGlow;
	cell.title.textColor = [UIColor whiteColor];
	cell.selectionGlowColor = [UIColor whiteColor];
    cell.icon = [_icons objectAtIndex: index];
    cell.backgroundColor = [UIColor clearColor];
	
	cell.title.text = [[self.titleItems objectAtIndex:index] objectForKey:@"userName"];
    
    
	
    
    return ( cell );
}

- (CGSize) portraitGridCellSizeForGridView: (AQGridView *) gridView
{
    return ( CGSizeMake(80, 100) );
}

#pragma mark -
#pragma mark Call

- (IBAction)emergencyAct:(id)sender 
{
    UIAlertView *Notpermitted=[[UIAlertView alloc] initWithTitle:@"Alert" message:@"Are you sure call the emergency?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes",nil];
    Notpermitted.tag=0;
    [Notpermitted show];
}

- (IBAction)transportAct:(id)sender
{
    UIAlertView *Notpermitted=[[UIAlertView alloc] initWithTitle:@"Alert" message:@"Are you sure call a taxi?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes",nil];
    Notpermitted.tag=1;
    [Notpermitted show];
}

- (IBAction)contactAct:(id)sender 
{
//    UIAlertView *Notpermitted=[[UIAlertView alloc] initWithTitle:@"Alert" message:@"Are you sure call your contacts?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes",nil];
//    Notpermitted.tag=2;
//    [Notpermitted show];
    
    //[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"telprompt:0431118326"]];
    EmergencyViewController *emergencyViewController=[self.storyboard instantiateViewControllerWithIdentifier:@"EmergencyViewController"];
    emergencyViewController.function=1;
    [self.navigationController presentModalViewController:emergencyViewController animated:YES];
}

#pragma mark - UIAlertView delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag==0) {
        if (buttonIndex==1) {
            UIDevice *device = [UIDevice currentDevice];
            
            if ([[device model] isEqualToString:@"iPhone"])
            {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"telprompt:000"]];
                
            } else
            {
                UIAlertView *Notpermitted=[[UIAlertView alloc] initWithTitle:@"Alert" message:@"Your device doesn't support this feature." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [Notpermitted show];
            }
        }
    }
    else if(alertView.tag==1)
    {
        if (buttonIndex==1) {
            UIDevice *device = [UIDevice currentDevice];
            
            if ([[device model] isEqualToString:@"iPhone"])
            {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"telprompt:131924"]];
                
            } else
            {
                UIAlertView *Notpermitted=[[UIAlertView alloc] initWithTitle:@"Alert" message:@"Your device doesn't support this feature." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [Notpermitted show];
            }
        }
    }
//    else if(alertView.tag==2)
//    {
//        if (buttonIndex==1) {
//            UIDevice *device = [UIDevice currentDevice];
//            
//            if ([[device model] isEqualToString:@"iPhone"])
//            {
//                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"telprompt:0431"]];
//                
//            } else
//            {
//                UIAlertView *Notpermitted=[[UIAlertView alloc] initWithTitle:@"Alert" message:@"Your device doesn't support this feature." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//                [Notpermitted show];
//            }
//        }
//    }
}

@end
