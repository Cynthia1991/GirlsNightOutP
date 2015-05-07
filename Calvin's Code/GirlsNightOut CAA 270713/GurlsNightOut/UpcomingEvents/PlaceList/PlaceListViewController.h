//
//  PlaceListViewController.h
//  FoursquarePlace
//
//  Created by calvin on 3/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "SBJson.h"
#import "AddEventsViewController.h"

#define kFourSquareClientID	@"AL50DX5KCCDJC5ANYPEVNUP32SWX34D0RB4TW2ATG04VU4YP"
#define kFourSquareClientSecret	@"F0RHNQTMXIR0YBXHY1EC4SNDEKKWA1TPL2C5TG1JTQHR2AWM"

@interface PlaceListViewController : UITableViewController
{    
    NSMutableData *receivedData;
    NSMutableArray *data4TableView;
    
//    Boolean searching;
    NSMutableArray *data4SearchingTableView;
    NSInteger funtionFSQ;

}
@property (nonatomic) NSInteger function;
@property (strong, nonatomic) NSString *eventDBID;
@property (strong, nonatomic) AddEventsViewController *addEventsViewController;

@property (strong, nonatomic) IBOutlet UISearchDisplayController *searchBarDisplayController;
@property (nonatomic,retain) CLLocationManager *currentLocation;

- (IBAction)cancelButtonAction:(id)sender;
@end
