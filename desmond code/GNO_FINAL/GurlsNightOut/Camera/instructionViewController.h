//
//  instructionViewController.h
//  photoBooth
//
//  Created by Desmond on 28/06/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AQGridView.h"
#import "springboardIconForPBCell.h"
#import "AppDelegate.h"
#import "imageCaptureViewController.h"

@class springboardIconCell;

@interface instructionViewController : UIViewController <AQGridViewDataSource, AQGridViewDelegate, UIGestureRecognizerDelegate,UIActionSheetDelegate,UITabBarControllerDelegate,UITabBarDelegate>

{
    NSMutableArray * _icons;
    AQGridView * _gridView;
    
    NSUInteger _emptyCellIndex;
    
    NSUInteger _dragOriginIndex;
    CGPoint _dragOriginCellOrigin;
    
    springboardIconForPBCell * _draggingCell;
    AppDelegate *appDelegate;
    
    UITabBarController *tabController;
    
}
@property (weak, nonatomic) IBOutlet UIView *iconView;
@property (strong,nonatomic)NSString *selectedOverlay;
//@property (nonatomic, weak) IBOutlet UISwitch *overlaySwitch;
@property (nonatomic,strong)NSMutableArray *overlayArray;
-(void)gridSetup;
-(void)pushToCaptureView;

//- (IBAction) toggleEnabledForOverlaySwitch: (id) sender;
- (IBAction)backButtonAction:(id)sender;


@end
