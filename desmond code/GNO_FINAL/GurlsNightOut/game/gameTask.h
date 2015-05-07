//
//  gameTask.h
//  GNOdare
//
//  Created by Desmond on 6/11/12.
//  Copyright (c) 2012 QUT. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface gameTask : NSObject

@property (strong, nonatomic) NSString *truthGamePlist;
@property (strong,nonatomic) NSArray *truthGameContent;

@property (strong, nonatomic) NSString *dareGamePlist;
@property (strong,nonatomic) NSArray *dareGameContent;

- (id)initWithTruthGameName:(NSString *)truthGameName;
- (NSDictionary *)truthGameItemAtIndex:(int)index;
- (int)truthgameTaskCount;

- (id)initWithDareGameName:(NSString *)daregameName;
- (NSDictionary *)dareGameItemAtIndex:(int)index;
- (int)dareGameTaskCount;

@end
