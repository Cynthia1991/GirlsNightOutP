//
//  PlaceDetailsViewController.m
//  FoursquarePlace
//
//  Created by calvin on 4/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PlaceDetailsViewController.h"

@interface PlaceDetailsViewController ()

@end

@implementation PlaceDetailsViewController
@synthesize latitude,longitude,pName,pAddress,pDictance,addEventsViewController,eventDBID,function;
@synthesize placeName;
@synthesize placeDistance;
@synthesize myMapView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.placeName.text=[NSString stringWithFormat:@"Location: %@",pName];
    self.placeDistance.text=[NSString stringWithFormat:@"Distance: %@m",pDictance];
    
   
    PlaceAnnotation *pin=[[PlaceAnnotation alloc] init];
    pin.title=pName;
    pin.subtitle=[NSString stringWithFormat:@"Distance: %@m",pDictance];
    pin.latitude=[self latitude];
    pin.longitude=[self longitude];
    [pin getRegion];
    
    [myMapView addAnnotation:pin];
    [myMapView setDelegate:self];
	[myMapView setRegion:[pin theRegion] animated:YES];
    [myMapView showsUserLocation];

}

- (void)viewDidUnload
{
    [self setPlaceName:nil];
    [self setPlaceDistance:nil];
    [self setMyMapView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}


- (IBAction)doneButtonAction:(id)sender {
    if (function==0) {
        addEventsViewController.locationName=[self pName];
        addEventsViewController.locationAddress=[self pAddress];
        addEventsViewController.locationLatitude=[self latitude];
        addEventsViewController.locationLongitude=[self longitude];
        [self dismissModalViewControllerAnimated:YES];
    }
    else if (function==1) {
        Kumulos *k=[[Kumulos alloc] init];
        [k setDelegate:self];
        [k changeEventLocationWithEventDBID:31 andLocationLongitude:[self longitude] andLocationLatitude:[self latitude] andLocationAddress:[self pAddress] andLocationName:[self pName]];
    }

}
- (void) kumulosAPI:(Kumulos *)kumulos apiOperation:(KSAPIOperation *)operation changeEventLocationDidCompleteWithResult:(NSNumber *)affectedRows
{
    NSLog(@"%@",affectedRows);
    [self dismissModalViewControllerAnimated:YES];
}
- (MKAnnotationView *)mapView:(MKMapView *)mV viewForAnnotation:(id <MKAnnotation>)annotation
{
	MKPinAnnotationView *pinView = nil;
	if(annotation != myMapView.userLocation)
	{
		static NSString *defaultPinID = @"com.invasivecode.pin";
		pinView = (MKPinAnnotationView *)[myMapView dequeueReusableAnnotationViewWithIdentifier:defaultPinID];
		if ( pinView == nil ) pinView = [[MKPinAnnotationView alloc]
										  initWithAnnotation:annotation reuseIdentifier:defaultPinID];
		pinView.pinColor = MKPinAnnotationColorRed;
		pinView.animatesDrop = YES;
		///////////////////////////////给大头针加入按钮
		pinView.canShowCallout = YES;
//		UIButton *button = [UIButton buttonWithType:UIButtonTypeDetailDisclosure]; 
		//[button addTarget:self action:@selector(checkButtonTapped:event:) forControlEvents:UIControlEventTouchUpInside]; 
//		pinView.rightCalloutAccessoryView=button; 
	}
	else {
		[myMapView.userLocation setTitle:@"You are Here"];
        [myMapView.userLocation setSubtitle:@""];
	}
	return pinView;
}
@end
