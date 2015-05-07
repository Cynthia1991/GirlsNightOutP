//
//  PhotoManager.h
//  gno
//
//  Created by Calvin on 12/06/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhotoManager : NSObject

@property (nonatomic, strong) NSMutableDictionary *photoDic;
@property (nonatomic, strong) NSString *photoDicPath;

-(void) addPhoto:(NSData *)photoData text:(NSString*) text PhotoDBID:(NSString*)photoDBID;
-(void) deletePhotoWithPhotoDBID:(NSString*)photoDBID;
-(UIImage*) getPhotoByPhotoDBID:(NSString *) photoDBID;
@end
