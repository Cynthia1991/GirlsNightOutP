//
//  FavoriteMapViewController.m
//  GurlsNightOut
//
//  Created by Calvin on 11/04/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "FavoriteMapViewController.h"

@interface FavoriteMapViewController ()

@end

@implementation FavoriteMapViewController

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
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}


- (IBAction)doneAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
