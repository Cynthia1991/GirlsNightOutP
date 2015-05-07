//
//  PlaceAnnotation.m
//  FoursquarePlace
//
//  Created by calvin on 4/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PlaceAnnotation.h"

@implementation PlaceAnnotation
@synthesize coordinate,title,subtitle,longitude,latitude,theRegion,ID;
-(void) getRegion
{
	coordinate.latitude=latitude;
	coordinate.longitude=longitude;
    
    theRegion.center=coordinate;
	theRegion.span.longitudeDelta=0.01f;
	theRegion.span.latitudeDelta = 0.01f;
}

@end
