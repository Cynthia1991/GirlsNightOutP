//
//  gameMainViewController.h
//  gno
//
//  Created by Desmond on 29/11/12.
//
//

#import <UIKit/UIKit.h>
#import "spinViewController.h"
#import "TimelineScrollViewController.h"

@interface gameMainViewController : UIViewController
@property (nonatomic, strong) NSString *eventID;
@property (nonatomic,strong)  NSString *userID;
@property (nonatomic,strong)  TimelineScrollViewController *TLSVC;

-(IBAction)callModalGameView:(id)sender;
@end
