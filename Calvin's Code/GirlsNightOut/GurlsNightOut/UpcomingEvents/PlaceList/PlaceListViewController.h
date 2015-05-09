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

#define kFourSquareClientID	@"LLMZC1KVOLYD5J0YW3EXUH3K2S2HO1RUWUVYFSSS1BZQUOWF"
#define kFourSquareClientSecret	@"CMGGREQOWGGC2QCQT4RV3MJVI0LXSOZTURZQNCY1OHGSCP5U"

@interface PlaceListViewController : UITableViewController
{    
    NSMutableData *receivedData;
    NSMutableArray *data4TableView;
    
//    Boolean searching;
    NSMutableArray *data4SearchingTableView;
    NSInteger funtionFSQ;
    NSInteger venuesCategoriesMark;
    NSMutableDictionary *CategoriesDic;

}
@property (nonatomic) NSInteger function;
@property (strong, nonatomic) NSString *eventDBID;
@property (strong, nonatomic) AddEventsViewController *addEventsViewController;

@property (strong, nonatomic) IBOutlet UISearchDisplayController *searchBarDisplayController;
@property (nonatomic,retain) CLLocationManager *currentLocation;

- (IBAction)cancelButtonAction:(id)sender;
@end
