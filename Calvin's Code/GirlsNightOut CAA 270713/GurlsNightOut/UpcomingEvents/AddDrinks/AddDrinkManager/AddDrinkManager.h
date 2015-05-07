//
//  AddDrinkManager.h
//  gno
//
//  Created by calvin on 5/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Drinks.h"

@interface AddDrinkManager : NSObject

//add drinks
@property (strong, nonatomic) NSMutableArray *categoryArray;
@property (strong, nonatomic) NSMutableArray *totalArray;
@property (strong, nonatomic) NSMutableArray *catSelectedListArray;


@property (strong, nonatomic) NSMutableDictionary *addedDrinkDic;
//@property (strong, nonatomic) NSMutableArray *addedDrinkArray;

@property (strong, nonatomic) Drinks *enteredDrinkList;
@property (strong, nonatomic) NSMutableDictionary *enteredDrinkListNameDic;
@property (strong, nonatomic) NSString *enteredDrinkListNameDicPath;


- (NSString *) getDBPath;
- (void) copyDatabaseIfNeeded;
- (void) getCategory:(NSString *)dbPath;
- (void) getTotal:(NSString *)dbPath;

- (NSMutableArray*) selectedCat: (NSString *)cat;
- (Drinks*) selectADrinkID:(NSString *)drinkID;
- (void) setSelectedDrinkDicWithDrinkID:(NSString *) drinkID EventDBID:(NSString*) eventDBID;
- (Drinks*) getSelectedDrinkWithEventDBID:(NSString *) eventDBID;

@end
