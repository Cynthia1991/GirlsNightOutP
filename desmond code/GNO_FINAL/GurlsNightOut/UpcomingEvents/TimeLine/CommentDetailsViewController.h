//
//  CommentDetailsViewController.h
//  gno
//
//  Created by Calvin on 16/08/12.
//
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface CommentDetailsViewController : UITableViewController
{
    AppDelegate *appDelegate;
    NSMutableDictionary *iconDic;
}
@property (nonatomic, strong) NSMutableArray *commentsArray;

@end
