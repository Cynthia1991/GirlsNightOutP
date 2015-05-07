//
//  QDViewController.h
//  gno
//
//  Created by calvin on 26/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "AQGridView.h"
#import "springboardIconCell.h"

@interface QDViewController : UIViewController<UIAlertViewDelegate,AQGridViewDataSource, AQGridViewDelegate>
{
    NSMutableArray * _icons;
    AQGridView * _gridView;
    
    NSUInteger _emptyCellIndex;
    
    NSUInteger _dragOriginIndex;
    CGPoint _dragOriginCellOrigin;
    
    springboardIconCell * _draggingCell;
    AppDelegate *appDelegate;
    
    
}

@property IBOutlet UIView *tilesView;

@property (nonatomic,strong)NSMutableArray *titleItems;
@property (nonatomic,strong)NSMutableArray *photoItems;
@property (nonatomic,strong)NSMutableArray *phoneItems;
@property (nonatomic,strong)NSMutableArray *quickDialItems;
@property (nonatomic,strong)NSMutableArray *friendsList;
@property (nonatomic,strong)NSString *eventDBID;

- (IBAction)emergencyAct:(id)sender;
- (IBAction)transportAct:(id)sender;
- (IBAction)contactAct:(id)sender;
-(void)refreshQuickDial:(NSNotification*) notification;

//-(void)buttonPressedAction:(id)sender;
-(void)initDataFromArray;

@end