//
//  LeaderboardCell.h
//  GurlsNightOut
//
//  Created by Calvin on 8/05/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LeaderboardCell : UITableViewCell
@property (nonatomic, weak) IBOutlet UILabel *lbFirst;
@property (nonatomic, weak) IBOutlet UILabel *lbSecond;
@property (nonatomic, weak) IBOutlet UILabel *lbThird;

@property (nonatomic, weak) IBOutlet UILabel *lbFirstPoint;
@property (nonatomic, weak) IBOutlet UILabel *lbSecondPoint;
@property (nonatomic, weak) IBOutlet UILabel *lbThirdPoint;
@end
