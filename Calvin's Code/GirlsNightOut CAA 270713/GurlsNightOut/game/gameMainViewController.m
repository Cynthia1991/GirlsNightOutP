//
//  gameMainViewController.m
//  gno
//
//  Created by Desmond on 29/11/12.
//
//

#import "gameMainViewController.h"

@interface gameMainViewController ()

@end

@implementation gameMainViewController

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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)callModalGameView:(id)sender
{
    [self.TLSVC callGameView];
    
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"gameMainToGame"])
    {
        spinViewController *mView = (spinViewController *)[segue destinationViewController];
    
        mView.eventID = self.eventID;
//        mView.userID = self.userID;
        
        
    }
    //mView.hidesBottomBarWhenPushed = YES;
    //NSLog(@"text scanner %@",qrToText.textFromScanner);
}


@end
