//
//  AddDrinkManager.m
//  gno
//
//  Created by calvin on 5/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AddDrinkManager.h"
#import "FMDatabase.h"

@implementation AddDrinkManager
@synthesize categoryArray,totalArray,catSelectedListArray,enteredDrinkList,enteredDrinkListNameDic,enteredDrinkListNameDicPath,addedDrinkDic;

-(id) init
{
    if (self = [super init]) {
        NSLog(@"-----------running addDrinksManager----------------");

        self.categoryArray = [[NSMutableArray alloc] init];
        
        self.totalArray = [[NSMutableArray alloc] init];
        
        self.catSelectedListArray = [[NSMutableArray alloc] init];
        
        self.addedDrinkDic = [[NSMutableDictionary alloc] init];
        
        [self copyDatabaseIfNeeded];
        
        
        
        
        self.enteredDrinkListNameDicPath=[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"enteredDrinkListNameDicPath"];
        BOOL enteredDrinkListNameDicPathExists = [[NSFileManager defaultManager] fileExistsAtPath:self.enteredDrinkListNameDicPath];
        if (enteredDrinkListNameDicPathExists) {
            self.enteredDrinkListNameDic=[[NSMutableDictionary alloc] initWithContentsOfFile:self.enteredDrinkListNameDicPath];
        }
        else {
            self.enteredDrinkListNameDic=[[NSMutableDictionary alloc] init];
        }
    }

    return self;
}
- (Drinks*) getSelectedDrinkWithEventDBID:(NSString *) eventDBID
{
    self.enteredDrinkListNameDicPath=[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"enteredDrinkListNameDicPath"];
    BOOL enteredDrinkListNameDicPathExists = [[NSFileManager defaultManager] fileExistsAtPath:self.enteredDrinkListNameDicPath];
    if (enteredDrinkListNameDicPathExists) {
        self.enteredDrinkListNameDic=[[NSMutableDictionary alloc] initWithContentsOfFile:self.enteredDrinkListNameDicPath];
    }
    else {
        self.enteredDrinkListNameDic=[[NSMutableDictionary alloc] init];
    }
    
    Drinks *selectDrink;
    if ([self.enteredDrinkListNameDic objectForKey:eventDBID]!=nil) {
        NSString *drinkID=[self.enteredDrinkListNameDic objectForKey:eventDBID];
        selectDrink=[self selectADrinkID:drinkID];
    }
    return selectDrink;
}
- (void) setSelectedDrinkDicWithDrinkID:(NSString *) drinkID EventDBID:(NSString*) eventDBID
{
    [self.enteredDrinkListNameDic setObject:drinkID forKey:eventDBID];
    if ([self.enteredDrinkListNameDic writeToFile:self.enteredDrinkListNameDicPath atomically:YES]) {
        NSLog(@"write dic ok");
    }
    else {
        NSLog(@"write dic Fail");
        
    }
}
- (NSString *) getDBPath {
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDir = [paths objectAtIndex:0];
	return [documentsDir stringByAppendingPathComponent:@"drinks.sqlite"];
}

- (void) copyDatabaseIfNeeded {
	//Using NSFileManager we can perform many file system operations.
	NSFileManager *fileManager = [NSFileManager defaultManager];
	NSError *error;
	NSString *dbPath = [self getDBPath];
	BOOL success = [fileManager fileExistsAtPath:dbPath];
	
	if(!success) {
		
		NSString *defaultDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"drinks.sqlite"];
		success = [fileManager copyItemAtPath:defaultDBPath toPath:dbPath error:&error];
		
		if (!success)
			NSAssert1(0, @"Failed to create writable database file with message '%@'.", [error localizedDescription]);
	}
    NSLog(@"Drinks.sql copied");
}
- (void) getCategory:(NSString *)dbPath
{
    
    FMDatabase *database = [FMDatabase databaseWithPath:dbPath];
    [database open];
    // Fetch all users
    FMResultSet *results = [database executeQuery:@"SELECT category, COUNT(category) FROM drinks GROUP BY category"];
    
    while([results next]) 
    {
        Drinks *catObj = [[Drinks alloc]init];
        catObj.category = [results stringForColumn:@"category"];
        catObj.catCount = [results stringForColumn:@"COUNT(category)"];        
        // NSLog(@"User: %@ - %@",catObj.category, catObj.catCount);
        
        [self.categoryArray addObject:catObj];
        //NSLog(@"Result %@",results.resultDictionary);
    }
    //NSLog(@"Cat Array %@",aDelegate.categoryArray);
    [database close];
}

- (void) getTotal:(NSString *)dbPath
{
    
    FMDatabase *database = [FMDatabase databaseWithPath:dbPath];
    [database open];
    // Fetch all users
    FMResultSet *results = [database executeQuery:@ "SELECT COUNT(drinkID) FROM drinks"];
    
    while([results next]) 
    {
        Drinks *allCatObj = [[Drinks alloc]init];
        allCatObj.catTotal = [results stringForColumn:@"COUNT(drinkID)"];
        
        //NSLog(@"Total: %@ ", allCatObj.catTotal);
        
        [self.totalArray addObject:allCatObj];
        
        //NSLog(@"Result %@",results.resultDictionary);
        
    }
    //NSLog(@"Total Cat Array %@",aDelegate.totalArray);
    [database close];
}

- (NSMutableArray*) selectedCat: (NSString *)cat
{
    FMDatabase *database = [FMDatabase databaseWithPath:[self getDBPath]];
    
    self.catSelectedListArray =[[NSMutableArray alloc] init];
    
    [database open];
    NSLog(@"cat equal %@",cat);
    if (cat !=@"All") 
    {
        FMResultSet *results = [database executeQuery:@ "SELECT drinkID,drinkName,volume, percentage,category,image,unit,calories,fat,energy,imageSize FROM drinks WHERE category = ? ORDER BY drinkName ASC",cat];
        
        while([results next]) 
        {
            //NSLog(@"Total: %@ ", allCatObj.catTotal);
            //NSLog(@"Result %@",results.resultDictionary);
            
            Drinks *drinkObj = [[Drinks alloc]init];
            drinkObj.drinkName = [results stringForColumn:@"drinkName"];
            drinkObj.drinkID = [results stringForColumn:@"drinkID"];
            drinkObj.volume = [results stringForColumn:@"volume"];   
            drinkObj.percentage = [results stringForColumn:@"percentage"];   
            drinkObj.category = [results stringForColumn:@"category"];
            drinkObj.imageName = [results stringForColumn:@"image"];
            drinkObj.unit = [results stringForColumn:@"unit"];
            drinkObj.calories = [results stringForColumn:@"calories"];
            drinkObj.fat = [results stringForColumn:@"fat"];
            drinkObj.energy = [results stringForColumn:@"energy"];
            drinkObj.imageSize = [[results stringForColumn:@"imageSize"] intValue];
            
            [self.catSelectedListArray addObject:drinkObj];
            
            //NSLog(@"dring Array %@",aDelegate.catSelectedListArray);
            
        }
    }
    else
    {
        FMResultSet *results = [database executeQuery:@ "SELECT drinkID,drinkName,volume, percentage,category,image,unit,calories,fat,energy,imageSize FROM drinks ORDER BY drinkName ASC"];
        while([results next]) 
        {
            //NSLog(@"Total: %@ ", allCatObj.catTotal);
            // NSLog(@"Result %@",results.resultDictionary);
            
            Drinks *drinkObj = [[Drinks alloc]init];
            drinkObj.drinkName = [results stringForColumn:@"drinkName"];
            drinkObj.drinkID = [results stringForColumn:@"drinkID"];
            drinkObj.volume = [results stringForColumn:@"volume"];   
            drinkObj.percentage = [results stringForColumn:@"percentage"];   
            drinkObj.category = [results stringForColumn:@"category"]; 
            drinkObj.imageName = [results stringForColumn:@"image"];
            drinkObj.unit = [results stringForColumn:@"unit"];
            drinkObj.calories = [results stringForColumn:@"calories"];
            drinkObj.fat = [results stringForColumn:@"fat"];
            drinkObj.energy = [results stringForColumn:@"energy"];
            drinkObj.imageSize = [[results stringForColumn:@"imageSize"] intValue];

            [self.catSelectedListArray addObject:drinkObj];
            
            //NSLog(@"dring Array %@",aDelegate.catSelectedListArray);
        }
    }
    [database close];
    return self.catSelectedListArray;
}

- (Drinks*) selectADrinkID:(NSString *)drinkID
{
    FMDatabase *database = [FMDatabase databaseWithPath:[self getDBPath]];
    
    self.catSelectedListArray =[[NSMutableArray alloc] init];
    
    [database open];
//    NSLog(@"cat equal %@",cat);
    FMResultSet *results = [database executeQuery:@ "SELECT drinkID,drinkName,volume, percentage,category,image,unit,calories,fat,energy,imageSize FROM drinks WHERE drinkID = ? ORDER BY drinkName ASC",drinkID];
        
    Drinks *drinkObj;
    while([results next]) 
    {
        //NSLog(@"Total: %@ ", allCatObj.catTotal);
        // NSLog(@"Result %@",results.resultDictionary);
        
        drinkObj = [[Drinks alloc]init];
        drinkObj.drinkName = [results stringForColumn:@"drinkName"];
        drinkObj.drinkID = [results stringForColumn:@"drinkID"];
        drinkObj.volume = [results stringForColumn:@"volume"];   
        drinkObj.percentage = [results stringForColumn:@"percentage"];   
        drinkObj.category = [results stringForColumn:@"category"]; 
        drinkObj.imageName = [results stringForColumn:@"image"];
        drinkObj.unit = [results stringForColumn:@"unit"];
        drinkObj.calories = [results stringForColumn:@"calories"];
        drinkObj.fat = [results stringForColumn:@"fat"];
        drinkObj.energy = [results stringForColumn:@"energy"];
        drinkObj.imageSize = [[results stringForColumn:@"imageSize"] intValue];
        
        [self.catSelectedListArray addObject:drinkObj];
        
        //NSLog(@"dring Array %@",aDelegate.catSelectedListArray);
    }
    
    
    [database close];
    return drinkObj;
}
@end
