//
//  EditMyDetailsViewController.h
//  gno
//
//  Created by Calvin on 20/08/12.
//
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface EditMyDetailsViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,KumulosDelegate>
{
    AppDelegate *appDelegate;
}

@property (strong, nonatomic) IBOutlet UITableView *_tableView;
@property (strong, nonatomic) NSMutableDictionary *friendInfoDic;
@property (nonatomic) NSInteger function;//
- (IBAction)btDoneAction:(id)sender;
- (IBAction)btBackAction:(id)sender;
@end
