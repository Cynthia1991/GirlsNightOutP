//
//  EventListCell.h
//  GurlsNightOut
//
//  Created by Calvin on 7/04/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EventListCell : UITableViewCell <UITextFieldDelegate>

@property (nonatomic, weak) IBOutlet UILabel *title;
@property (nonatomic, weak) IBOutlet UILabel *time;
@property (nonatomic, weak) IBOutlet UILabel *location;
@property (nonatomic, weak) IBOutlet UITextField *tfDetail;
@property (nonatomic, weak) IBOutlet UIImageView *ivIndicator;
@property (nonatomic, weak) IBOutlet UIImageView *ivEventPhoto;
- (void) initCell;

@end
