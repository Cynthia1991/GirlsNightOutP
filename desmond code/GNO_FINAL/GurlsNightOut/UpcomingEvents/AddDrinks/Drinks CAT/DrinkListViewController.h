//
//  DrinkListViewController.h
//  drinkTable
//
//  Created by Desmond on 2/06/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Drinks.h"
#import "DrinkTableViewController.h"
#import "AppDelegate.h"

@interface DrinkListViewController : UIViewController<UISearchDisplayDelegate,UITableViewDelegate, UITableViewDataSource, UIActionSheetDelegate>
{
    BOOL searching;
}

@property (nonatomic,retain) AppDelegate *aDelegate;

//searchbar
@property (nonatomic, weak) IBOutlet UISearchBar *searchBar;
@property (nonatomic, weak) IBOutlet UISearchDisplayController *searchDisplayController;
@property (nonatomic, strong) NSArray *searchResult;

//drink objects
@property (nonatomic, strong) Drinks  *drinkList;
@property (nonatomic, strong) Drinks *drinkToConsume;


@property (nonatomic,weak)IBOutlet UITableView *drinksListTableView;
@property (nonatomic,strong) NSString *allDrinkStr;
@property (nonatomic, strong) NSMutableArray  *catToList;
@property (nonatomic, strong) NSMutableArray *sectionsArray;

- (IBAction)popBackButton:(id)sender;

@end
