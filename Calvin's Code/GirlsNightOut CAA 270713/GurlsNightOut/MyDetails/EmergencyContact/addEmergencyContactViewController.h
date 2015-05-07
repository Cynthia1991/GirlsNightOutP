//
//  addEmergencyContactViewController.h
//  gno
//
//  Created by Calvin on 28/09/12.
//
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface addEmergencyContactViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    AppDelegate *appDelegate;
}
@property (strong, nonatomic) IBOutlet UITableView *_tableView;

- (IBAction)addAction:(id)sender;
- (IBAction)backAction:(id)sender;
@end
