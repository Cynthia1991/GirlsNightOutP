//
//  AddFunctionCell.h
//  GurlsNightOut
//
//  Created by Calvin on 7/04/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddFunctionCell : UITableViewCell <UITextFieldDelegate>

@property (nonatomic, weak) IBOutlet UILabel *lbTitle;
@property (nonatomic, weak) IBOutlet UITextField *tfContent;
@end
