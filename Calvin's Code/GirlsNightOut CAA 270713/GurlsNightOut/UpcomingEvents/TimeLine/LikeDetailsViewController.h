//
//  LikeDetailsViewController.h
//  gno
//
//  Created by Calvin on 17/08/12.
//
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface LikeDetailsViewController : UITableViewController
{
    AppDelegate *appDelegate;
    NSMutableDictionary *iconDic;
}
@property (nonatomic, strong) NSMutableArray *likesArray;

@end
