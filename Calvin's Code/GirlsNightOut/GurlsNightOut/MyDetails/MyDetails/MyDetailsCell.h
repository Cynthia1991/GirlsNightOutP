//
//  MyDetailsCell.h
//  GurlsNightOut
//
//  Created by Calvin on 5/05/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyDetailsCell : UITableViewCell
@property (nonatomic, weak) IBOutlet UILabel *lbTitle;
@property (nonatomic, weak) IBOutlet UIImageView *ivTitleIcon;
@property (nonatomic, weak) IBOutlet UITextField *tfInput;
@property (nonatomic, weak) IBOutlet UIImageView *ivShare;
@end
