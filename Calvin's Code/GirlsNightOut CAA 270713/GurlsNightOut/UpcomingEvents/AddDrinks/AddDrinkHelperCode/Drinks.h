//
//  Drinks.h
//  drinkTable
//
//  Created by Desmond on 2/06/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Drinks : NSObject


@property (nonatomic, copy) NSString *category;
@property (nonatomic, copy) NSString *catCount;
@property (nonatomic, copy) NSString *catTotal;

@property (nonatomic, copy) NSString *drinkID;
@property (nonatomic, copy) NSString *drinkName;
@property (nonatomic, copy) NSString *percentage;
@property (nonatomic, copy) NSString *volume;
@property (nonatomic, copy) NSString *imageName;
@property (nonatomic, copy) NSString *unit;
@property (nonatomic, copy) NSString *calories;
@property (nonatomic, copy) NSString *energy;
@property (nonatomic, copy) NSString *fat;
@property (nonatomic) NSInteger imageSize;



@property (nonatomic, strong) NSMutableArray *addedTime;
@property (nonatomic, strong) NSDate *addedDateValue;
@property (nonatomic, strong) UIView *ivDrink;

@property (nonatomic) float x;
@property (nonatomic) float y;

@end
