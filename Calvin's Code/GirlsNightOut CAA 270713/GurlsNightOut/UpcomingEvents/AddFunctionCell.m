//
//  AddFunctionCell.m
//  GurlsNightOut
//
//  Created by Calvin on 7/04/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AddFunctionCell.h"

@implementation AddFunctionCell
@synthesize lbTitle,tfContent;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - textField delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	// hide current keyboard
	[textField resignFirstResponder];
	return YES;
}

@end
