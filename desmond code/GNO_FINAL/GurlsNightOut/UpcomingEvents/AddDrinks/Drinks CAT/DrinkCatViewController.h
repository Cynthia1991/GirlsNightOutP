//
//  DrinkCatViewController.h
//  drinkTable
//
//  Created by Desmond on 2/06/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Drinks.h"
#import "DrinkListViewController.h"

@interface DrinkCatViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic,weak)IBOutlet UITableView *drinksCatTable;


@property (nonatomic,strong) AppDelegate *aDelegate;
@property (nonatomic,strong) DrinkListViewController *selectedDrinkCat;

-(IBAction)popBackToTable:(id)sender;
@end
