//
//  PlaceDetailsViewController.h
//  FoursquarePlace
//
//  Created by calvin on 4/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <MapKit/MKAnnotation.h>
#import "PlaceAnnotation.h"
#import "Kumulos.h"
#import "AddEventsViewController.h"

@interface PlaceDetailsViewController : UIViewController<MKMapViewDelegate,KumulosDelegate>

@property (nonatomic) NSInteger function;
@property (strong, nonatomic) NSString *eventDBID;
@property (strong, nonatomic) AddEventsViewController *addEventsViewController;

@property (nonatomic) float latitude;
@property (nonatomic) float longitude;
@property (strong, nonatomic) NSString *pName;
@property (strong, nonatomic) NSString *pAddress;
@property (strong, nonatomic) NSString *pDictance;
@property (strong, nonatomic) IBOutlet UILabel *placeName;
@property (strong, nonatomic) IBOutlet UILabel *placeDistance;
@property (strong, nonatomic) IBOutlet MKMapView *myMapView;
- (IBAction)doneButtonAction:(id)sender;
@end
