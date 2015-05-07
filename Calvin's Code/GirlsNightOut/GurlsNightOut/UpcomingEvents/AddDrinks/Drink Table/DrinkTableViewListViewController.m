//
//  DrinkTableViewListViewController.m
//  drinkTable
//
//  Created by Desmond on 6/06/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DrinkTableViewListViewController.h"
#import "TDBadgedCell.h"
#import "Drinks.h"
#import "DrinkingView.h"

@interface DrinkTableViewListViewController ()

@end

@implementation DrinkTableViewListViewController

@synthesize drinksListTableView,drunkList,aDelegate,eventDBID;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    aDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    tableViewValueArray=[[NSMutableArray alloc] init];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(initAddedDrinks:) name:@"initAddedDrinks" object:nil];

    [self initAddedDrinks:nil];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}
-(void) initAddedDrinks:(NSNotification*)notification
{
    NSMutableArray *abc=[[NSMutableArray alloc] init];
    for (int i=0; i<[[aDelegate.addDrinkManager.addedDrinkDic objectForKey:[NSString stringWithFormat:@"%d",[self eventDBID]]] count]; i++) {
        DrinkingView *drinkingView=[[aDelegate.addDrinkManager.addedDrinkDic objectForKey:[NSString stringWithFormat:@"%d",[self eventDBID]]] objectAtIndex:i];
        
        if ([[aDelegate.myDetailsManager.userInfoDic objectForKey:@"userDBID"] intValue] == [drinkingView.userID intValue]) {
            
            if (drinkingView.drink.addedTime==nil) {
                drinkingView.drink.addedTime=[[NSMutableArray alloc] init];
            }
            
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"drinkID == %@", drinkingView.drinkID];
            NSArray *abc1 = [abc filteredArrayUsingPredicate:predicate];
            
            if ([abc1 count]==0) {//the first one
                drinkingView.drink.catCount=[NSString stringWithFormat:@"1"];
                [drinkingView.drink.addedTime addObject:drinkingView.drink.addedDateValue];
                
                [abc addObject:drinkingView];
            }
            else {//+1
                DrinkingView *drinkView1=[abc1 objectAtIndex:0];
                NSInteger count=[drinkView1.drink.catCount intValue];
                drinkView1.drink.catCount=[NSString stringWithFormat:@"%d",count+1];
                [drinkView1.drink.addedTime addObject:drinkingView.drink.addedDateValue];
                
            }
        }
    }
    [tableViewValueArray removeAllObjects];
    [tableViewValueArray addObjectsFromArray:abc];
    [self.drinksListTableView reloadData];
}
#pragma mark -
#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [tableViewValueArray count];
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    
    TDBadgedCell *cell = [[TDBadgedCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    cell.showShadow = YES;
    cell.badge.radius = 6;
   
    DrinkingView *drinkView = [tableViewValueArray objectAtIndex:indexPath.row];
    drunkList = drinkView.drink;
    cell.textLabel.text = drunkList.drinkName;
    cell.badgeString = drunkList.catCount;
    NSString *detailText = [[NSString alloc]initWithFormat:@"%@ml - %@%% Alcohol",drunkList.volume,drunkList.percentage];
    cell.detailTextLabel.text =detailText;
    
    return cell;
}

@end
