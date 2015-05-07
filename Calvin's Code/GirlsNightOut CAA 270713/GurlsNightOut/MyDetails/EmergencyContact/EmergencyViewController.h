//
//  EmergencyViewController.h
//  gno
//
//  Created by Calvin on 28/09/12.
//
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface EmergencyViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    AppDelegate *appDelegate;
}
@property (strong, nonatomic) IBOutlet UITableView *_tableView;
@property (strong, nonatomic) IBOutlet UIButton *btAdd;
@property (nonatomic) NSInteger function;//0=manage, 1=timeline

- (IBAction)addAction:(id)sender;
- (IBAction)backAction:(id)sender;
@end
