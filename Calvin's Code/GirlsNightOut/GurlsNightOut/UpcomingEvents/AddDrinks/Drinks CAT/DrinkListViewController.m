//
//  DrinkListViewController.m
//  drinkTable
//
//  Created by Desmond on 2/06/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DrinkListViewController.h"

@interface DrinkListViewController ()

@end

@implementation DrinkListViewController

@synthesize drinkList,allDrinkStr,catToList,drinksListTableView;
@synthesize aDelegate;
@synthesize searchBar,searchResult,searchDisplayController;
@synthesize drinkToConsume,sectionsArray;


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
    
    catToList = [[NSMutableArray alloc]init];
    
    self.aDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    if ([self.allDrinkStr isEqualToString:@"All"]) {
        self.title = @"All";
        [aDelegate.addDrinkManager selectedCat:self.allDrinkStr];		
        self.catToList = aDelegate.addDrinkManager.catSelectedListArray;
        //[drinkList release];		
    }else	
    {
        if ([self.allDrinkStr isEqualToString:@"cat"]) {		
            self.title =self.drinkList.category;
            [aDelegate.addDrinkManager selectedCat:self.drinkList.category];
            self.catToList = aDelegate.addDrinkManager.catSelectedListArray;//[drinkList selectedCat:self.drinkList.category];
            //[drinkList release];
        }
    }
    NSLog(@"caToList Count%d", [catToList count]);
    NSLog(@"catSelectedListArray %d",[aDelegate.addDrinkManager.catSelectedListArray count]);

    //---create the index---
    sectionsArray = [[NSMutableArray alloc] init];
    NSMutableArray *indexArray = [[NSMutableArray alloc] init];
    
    NSString *ABC;
    char alphabet;
    NSString *uniChar;
    
    for (int i=0; i<[self.catToList count]; i++)
    {
        //---get the first char of each state---
        Drinks *drinkObj = [catToList objectAtIndex:i];
        
        ABC = drinkObj.drinkName;
        [indexArray addObject:ABC];
        NSLog(@"%@ ABC",ABC);
    }
    
    for (int i=0; i<[indexArray count]; i++) 
    {
        alphabet = [[indexArray objectAtIndex:i] characterAtIndex:0];
        uniChar = [NSString stringWithFormat:@"%c", alphabet];
        
        //---add each letter to the index array---
        if (![sectionsArray containsObject:uniChar])
        {            
            [sectionsArray addObject:uniChar];
        }
    }
    [self.drinksListTableView setContentOffset:CGPointMake(0,45)];//hide the searchbar initially    
}

- (void)viewWillAppear:(BOOL)animated
{   
    if(searchResult!=0)
    {
    NSLog(@"search result %@", searchResult);
    searchResult = nil;
    }
    else
    {
        [self.drinksListTableView reloadData];
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}


#pragma mark -
#pragma mark Table view data source and delegate methods

// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        //return search frog count
        return [self.searchResult count];
    }
    //    if (searching)
    //		return [catToListForSearch count];//return search row
	
    else {
		
		//---get the letter in each section; e.g., A, B, C, etc.---
		NSString *alphabet = [sectionsArray objectAtIndex:section];
		
        NSLog(@"alph %@",alphabet);
		//---get all row beginning with the letter---
		NSPredicate *predicate = [NSPredicate predicateWithFormat:@"drinkName beginswith[c] %@", alphabet];
		
		NSArray *abc = [self.catToList filteredArrayUsingPredicate:predicate];
		
		NSLog(@"%@",abc);
		
		//---return the number of row beginning with the letter---
		return [abc count];//return orginal cat row
    }
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        
    }
	
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        //populate search table
        Drinks *searchDrink = [searchResult objectAtIndex:indexPath.row];
   		
		//NSString *cellValue = //[catToListForSearch objectAtIndex:indexPath.row];
		cell.textLabel.text = searchDrink.drinkName;
		NSString *detailText = [[NSString alloc]initWithFormat:@"%@ml - %@%% Alcohol",searchDrink.volume,searchDrink.percentage];
		cell.detailTextLabel.text =detailText;
	}else
	{	
		//---get the letter in the current section---
		NSString *alphabet = [sectionsArray objectAtIndex:[indexPath section]];
		
		//---get all cat beginning with the letter---
		
		NSPredicate *predicate = [NSPredicate predicateWithFormat:@"drinkName beginswith[c] %@", alphabet];
		NSArray *abc = [catToList filteredArrayUsingPredicate:predicate];		
		
		if ([abc count]>0) {
			//---extract the relevant state from the states object---
			Drinks *newDrink = [abc objectAtIndex:indexPath.row];
			cell.textLabel.text = newDrink.drinkName;
			NSString *detailText = [[NSString alloc]initWithFormat:@"%@ml - %@%% Alcohol",newDrink.volume,newDrink.percentage];
			cell.detailTextLabel.text =detailText;
		}
		
	}
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	if (tableView == self.searchDisplayController.searchResultsTableView)
	{
		
//		Drinks *tempArrayFromSearch = [searchResult objectAtIndex:indexPath.row];	
//		Drinks *toConsumeDrinkObj = tempArrayFromSearch;
		//NSInteger tempInt = toConsumeDrinkObj.drinkID;
		
		//Get the detail view data if it does not exists.
		//We only load the data we initially want and keep on loading as we need.
		//[toConsumeDrinkObj hydrateDetailViewData];
		
		//self.drinkToConsume = toConsumeDrinkObj;
		
		
		UIActionSheet *popupQuery = [[UIActionSheet alloc]
									 initWithTitle:nil
									 delegate:self
									 cancelButtonTitle:@"Cancel"
									 destructiveButtonTitle:nil
									 otherButtonTitles:@"View Details",@"Drink Consumed Now", @"Drink Consumed Earlier",nil];
		
		popupQuery.actionSheetStyle = UIActionSheetStyleBlackOpaque;
		[popupQuery showInView:self.tabBarController.view];
		//[popupQuery release];
		NSLog(@"value passed to toConsumeDrinkObj %@", self.drinkToConsume.category);
		NSLog(@"Category %@",self.drinkToConsume.category);
		NSLog(@"Drink Name %@",self.drinkToConsume.drinkName);
		//NSLog(@"Drink ID",self.drinkToConsume.drinkID);	
		
	}
	else
	{
    
        //self.aDelegate.enteredDrinkList
		//---get all row beginning with the letter---
        /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
        UITableViewCell *userEmailCell=[tableView cellForRowAtIndexPath:indexPath];
        NSString *cellText=[[userEmailCell textLabel] text];
        NSLog(@"%@",cellText);
		NSPredicate *predicate = [NSPredicate predicateWithFormat:@"drinkName == %@", cellText];
		
		NSArray *abc = [self.catToList filteredArrayUsingPredicate:predicate];
        NSLog(@"%@",abc);
        /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
        Drinks *selectedDrink = [abc objectAtIndex:0];
        
        NSLog(@"Drink ID %@",selectedDrink.drinkID);
        
        [aDelegate.addDrinkManager setEnteredDrinkList:selectedDrink];
        NSLog(@"Drink ID %@",aDelegate.addDrinkManager.enteredDrinkList.drinkID);

//        DrinkTableViewController *drinkTable = [[DrinkTableViewController alloc]init];
//        
//        drinkTable.selectedDrink = selectedDrink;
//        
//        [drinkTable setSelectedDrink:selectedDrink];
//        
//        NSLog(@"Drink Name %@",drinkTable.selectedDrink.drinkName);
       
        [[NSNotificationCenter defaultCenter] postNotificationName:@"Drink Selected Notification1" object:self];

        [super dismissViewControllerAnimated:YES completion:nil];
        
        NSArray *viewContrlls=[[self navigationController] viewControllers];
        NSLog(@"%@",viewContrlls);
        for( int i=0;i<[ viewContrlls count];i++){
            id obj=[viewContrlls objectAtIndex:i];
            if([obj isKindOfClass:NSClassFromString(@"DrinkTableViewController")] )
            {
            
                [UIView transitionWithView:self.navigationController.view duration:0.5
                                   options:UIViewAnimationOptionTransitionCurlDown
                                animations:^{                      
                                
                                    [[self navigationController] popToViewController:obj animated:NO];
                                }
                                completion:NULL
                 ];

                break;
            }
        }
    }   
 

    
    
}

/*
 Section-related methods: Retrieve the section titles and section index titles from the collation.
 */


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	if (tableView == self.searchDisplayController.searchResultsTableView) {
		return 1;
	}
	return [sectionsArray count];
	//return 1;
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        
        return @"Search Result";
    }
	else
        //if (self.allDrinkStr == @"All") {
        //return @"All";						
        return [sectionsArray objectAtIndex:section];
    
	//return drinkList.category;
	
}


- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
	
	if (tableView == self.searchDisplayController.searchResultsTableView) 
        return nil;
    
	return sectionsArray;
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
	
	if (tableView == self.searchDisplayController.searchResultsTableView)
		return -1;
	
	
	if (index == 0) {
		[tableView scrollRectToVisible:[[tableView tableHeaderView] bounds] animated:NO];
		return -1;
	}
	return index;
	
}



- (IBAction)popBackButton:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
