//
//  instructionViewController.m
//  photoBooth
//
//  Created by Desmond on 28/06/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "instructionViewController.h"

@interface instructionViewController ()

@end

@implementation instructionViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.overlayArray = [[NSMutableArray alloc] initWithObjects:
                         @"OverLay00.png",
                         @"OverLay01.png",
                         @"OverLay02.png",
                         @"OverLay03.png",
                         nil];
    
    [self gridSetup];
}

-(void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:YES];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    [self setIconView:nil];
}

-(void)gridSetup
{
    
    _emptyCellIndex = NSNotFound;
    
    //self.view.autoresizesSubviews = YES;
    self.iconView.autoresizesSubviews = YES;
    // background goes in first
    //        UIImageView * background = [[UIImageView alloc] initWithFrame:CGRectMake(0, 10, 320, 420)];
    //        background.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    //        background.contentMode = UIViewContentModeCenter;
    //    	background.image = [UIImage imageNamed: @"PBbg.png"];
    //
    //         [self.iconView addSubview: background];
    
    // grid view sits on top of the background image
    _gridView = [[AQGridView alloc] initWithFrame: CGRectMake(0.0f, 0.0f, 280, 385)];
    _gridView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    _gridView.backgroundColor = [UIColor clearColor];
    _gridView.opaque = YES;
    _gridView.dataSource = self;
    _gridView.delegate = self;
    _gridView.scrollEnabled = YES;
    
    //[self.view addSubview: _gridView];
    [self.iconView addSubview: _gridView];
    
    if ( _icons == nil )
    {
        _icons = [[NSMutableArray alloc] initWithCapacity: [self.overlayArray count]];
        UIBezierPath * path = [UIBezierPath bezierPathWithRoundedRect: CGRectMake(0.0, 0.0, 125.0, 180.0)
                                                         cornerRadius: 18.0];
        NSUInteger x = 0;
        CGFloat saturation = 0.6, brightness = 0.7;
        for ( NSUInteger i = 0; i < [self.overlayArray count]; i++ )
        {
            UIColor * color = [UIColor colorWithHue: (CGFloat)i/20.0
                                         saturation: saturation
                                         brightness: brightness
                                              alpha: 1.0];
            
            UIGraphicsBeginImageContext( CGSizeMake(125.0, 180.0) );
            
            // clear background
            [[UIColor clearColor] set];
            UIRectFill( CGRectMake(0.0, 0.0, 125.0, 180.0) );
            
            // fill the rounded rectangle
            [color set];
            [path fill];
			
			UIImage *image;
            
			if (i == x)
            {
                image = [UIImage imageNamed:[self.overlayArray objectAtIndex:i]];
            }
            
			else image = UIGraphicsGetImageFromCurrentImageContext();
            
			UIGraphicsEndImageContext();
            // put the image into our list
            [_icons addObject: image];
            x++;
            
        }
    }
    
    [_gridView reloadData];
    
}

-(void)pushToCaptureView
{
    [self performSegueWithIdentifier:@"pushToCapture" sender:self];
    
}

#pragma mark -
#pragma mark GridView Delegate

- (void) gridView: (AQGridView *) gridView didSelectItemAtIndex: (NSUInteger) index
{
	[gridView deselectItemAtIndex:index animated:YES];
    
    self.selectedOverlay =  [self.overlayArray objectAtIndex:index];
       
	//newViewController.view.frame = CGRectMake(0.0f, 0.0f, 320.0f, 460.0f);
    [self performSegueWithIdentifier:@"pushToCapture" sender:self];
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

    if ([[segue identifier] isEqualToString:@"pushToCapture"])
    {
        imageCaptureViewController *imageCaptureVC = [segue destinationViewController];
        imageCaptureVC.selectedOverlay=[NSString stringWithFormat:@"%@",[self selectedOverlay]];        
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
            hiddenCell = [[AQGridViewCell alloc] initWithFrame: CGRectMake(0.0, 0.0, 125.0, 180.0)
                                               reuseIdentifier: EmptyIdentifier];
        }
        
        hiddenCell.hidden = YES;
        return ( hiddenCell );
    }
    
    springboardIconForPBCell * cell = (springboardIconForPBCell *)[gridView dequeueReusableCellWithIdentifier: CellIdentifier];
    if ( cell == nil )
    {
        cell = [[springboardIconForPBCell alloc] initWithFrame: CGRectMake(0.0, 0.0, 125, 180) reuseIdentifier: CellIdentifier];
    }
    
	cell.selectionStyle = AQGridViewCellSelectionStyleGlow;
	cell.title.textColor = [UIColor yellowColor];
	cell.selectionGlowColor = [UIColor whiteColor];
    
    cell.icon = [_icons objectAtIndex: index];
    return ( cell );
}

- (CGSize) portraitGridCellSizeForGridView: (AQGridView *) gridView
{
    return ( CGSizeMake(140, 190) );
}

- (IBAction)backButtonAction:(id)sender {
    [self dismissModalViewControllerAnimated:YES];
}
@end


