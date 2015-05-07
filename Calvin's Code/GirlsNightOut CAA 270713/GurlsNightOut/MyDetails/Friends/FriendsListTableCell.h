//
//  FriendsListTableCell.h
//  gno
//
//  Created by calvin on 16/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FriendsListTableCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel *lbTitle;
@property (nonatomic, weak) IBOutlet UILabel *lbSubTitle;
@property (nonatomic, weak) IBOutlet UIImageView *ivIcon;
@property (nonatomic, weak) IBOutlet UIImageView *checkIcon;
@property (nonatomic, weak) IBOutlet UIImageView *ivArrow;

@end
