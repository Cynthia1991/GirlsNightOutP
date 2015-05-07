//
//  DrinkCatViewController.m
//  drinkTable
//
//  Created by Desmond on 2/06/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DrinkCatViewController.h"
#import "TDBadgedCell.h"

@interface DrinkCatViewController ()

@end

@implementation DrinkCatViewController

@synthesize aDelegate;
@synthesize drinksCatTable;
@synthesize selectedDrinkCat;

#pragma mark - App life
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
    
    aDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
}

-(void)viewWillAppear:(BOOL)animated
{
    aDelegate.addDrinkManager.categoryArray = [[NSMutableArray alloc] init];
    aDelegate.addDrinkManager.totalArray = [[NSMutableArray alloc] init];
    [aDelegate.addDrinkManager getCategory:[aDelegate.addDrinkManager getDBPath]];
    [aDelegate.addDrinkManager getTotal:[aDelegate.addDrinkManager getDBPath]];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"pushToDrinkList"])
    {
        NSIndexPath *myIndexPath = [self.drinksCatTable indexPathForSelectedRow];
        NSLog(@"my index path %d",myIndexPath.row);
        
        if (myIndexPath.row ==0) //if selected is row 1 
        {
            //selectedDrinkCat  =[segue destinationViewController];
            selectedDrinkCat=(DrinkListViewController *)[segue destinationViewController];
            Drinks *drinkList = [aDelegate.addDrinkManager.categoryArray objectAtIndex:0];//forward all drinks to drinksList
            selectedDrinkCat.drinkList = drinkList;//point drinkList to the next view drinkList
            selectedDrinkCat.allDrinkStr = @"All";//all drinks selected	
            NSLog(@"All");
        }
        else 
        {
            selectedDrinkCat=(DrinkListViewController *)[segue destinationViewController];
            Drinks *drinkList = [aDelegate.addDrinkManager.categoryArray objectAtIndex:(myIndexPath.row)-1];//we have to minus 1 as the row had en extra "All" row which is not in the database
            NSLog(@"drink cat %@",drinkList.category);
            selectedDrinkCat.drinkList = drinkList; 
            selectedDrinkCat.allDrinkStr =@"cat";
            NSLog(@"cat");
        }
    }
}

-(IBAction)popBackToTable:(id)sender
{
    [UIView transitionWithView:self.navigationController.view duration:1
                       options:UIViewAnimationOptionTransitionCurlDown
                    animations:^{
                        [self.navigationController popViewControllerAnimated:NO];
//                        [[NSNotificationCenter defaultCenter] postNotificationName:UIApplicationDidReceiveMemoryWarningNotification object: [UIApplication sharedApplication]];
                        
                    }
                    completion:NULL];
    

}

#pragma mark -
#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

	NSInteger a= [aDelegate.addDrinkManager.categoryArray count]+1; //add 1 more row for All;
    return a;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"cell";
    
    TDBadgedCell *cell = [[TDBadgedCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.font = [UIFont boldSystemFontOfSize:17];
    cell.showShadow = YES;
    cell.badge.radius = 6;
    
    if (indexPath.row ==0)//if is row 1, show All 
    {
        Drinks *catObj = [aDelegate.addDrinkManager.totalArray objectAtIndex:0];
        cell.textLabel.text = @"All";
        cell.badgeString = catObj.catTotal;//total drinks number 
        
    }
    else 
    {		
        Drinks *catObj = [aDelegate.addDrinkManager.categoryArray objectAtIndex:(indexPath.row)-1];//show drinks from database from row 2 onwards 
        cell.textLabel.text = catObj.category;
        cell.badgeString = catObj.catCount;//count each category's drink;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self performSegueWithIdentifier:@"pushToDrinkList" sender:self];
    [self.drinksCatTable deselectRowAtIndexPath:indexPath animated:YES];
}


@end
