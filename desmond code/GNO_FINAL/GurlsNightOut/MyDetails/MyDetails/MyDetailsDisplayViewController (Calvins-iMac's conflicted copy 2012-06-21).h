//
//  MyDetailsDisplayViewController.h
//  GurlsNightOut
//
//  Created by calvin on 3/05/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyDetailsManager.h"
#import "AppDelegate.h"

@interface MyDetailsDisplayViewController : UITableViewController
{
    AppDelegate *appDelegate;
}
@property (strong, nonatomic) IBOutlet UIButton *btPhoto;
- (IBAction)btPhotoAction:(id)sender;
@end
