//
//  DrinkTableViewListViewController.h
//  drinkTable
//
//  Created by Desmond on 6/06/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Drinks.h"
#import "AppDelegate.h"

@interface DrinkTableViewListViewController : UIViewController <UISearchDisplayDelegate,UITableViewDelegate, UITableViewDataSource, UIActionSheetDelegate,KumulosDelegate>
{
    NSMutableArray *tableViewValueArray;
}
@property (nonatomic,weak)IBOutlet UITableView *drinksListTableView;
@property (nonatomic,retain) AppDelegate *aDelegate;
//drink objects
@property (nonatomic, strong) Drinks  *drunkList;
@property (nonatomic) NSInteger  eventDBID;
//- (void) initAddedDrinkArray1:(NSNotification *) notification;
-(void) initAddedDrinks:(NSNotification*)notification;

@end
