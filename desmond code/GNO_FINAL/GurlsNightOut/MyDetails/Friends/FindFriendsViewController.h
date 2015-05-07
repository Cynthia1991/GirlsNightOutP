//
//  FindFriendsViewController.h
//  gno
//
//  Created by Calvin on 31/08/12.
//
//

#import <UIKit/UIKit.h>
#import "Kumulos.h"
@interface FindFriendsViewController : UITableViewController<KumulosDelegate>
{
    NSMutableArray *data4TableView;
    NSMutableArray *data4SearchingTableView;

}

@property (strong, nonatomic) IBOutlet UISearchDisplayController *mySearchBarController;
- (IBAction)cancelButton:(id)sender;
@end
