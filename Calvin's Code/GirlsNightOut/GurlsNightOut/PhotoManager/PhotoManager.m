//
//  PhotoManager.m
//  gno
//
//  Created by Calvin on 12/06/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PhotoManager.h"
#import "SBJson.h"

@implementation PhotoManager
@synthesize photoDic,photoDicPath;
- (id) init
{
    if (self = [super init]) {
        self.photoDicPath=[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"photoDicPath"];
        BOOL photoDicPathExists = [[NSFileManager defaultManager] fileExistsAtPath:self.photoDicPath];
        
        if (photoDicPathExists) {
            
            self.photoDic=[[NSMutableDictionary alloc] initWithContentsOfFile:self.photoDicPath];
        }
        else {
            self.photoDic=[[NSMutableDictionary alloc] init];
        }
    }
    return self;
}

-(void) addPhoto:(NSData *)photoData text:(NSString*) text PhotoDBID:(NSString*)photoDBID
{
    UIImage *img=[UIImage imageWithData:photoData];
    
    NSString *folderPath=[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"/Pictures/"];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:folderPath isDirectory:NULL]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:folderPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
       
    
    NSString *path=[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"/Pictures/%@.png",photoDBID]];

    
    
    if ([UIImagePNGRepresentation(img) writeToFile:path atomically:YES]) {
        NSLog(@"write img ok");
    }
    else {
        NSLog(@"write img Fail");
        
    }
    NSMutableDictionary *dic=[[NSMutableDictionary alloc] init];
    [dic setObject:path forKey:@"path"];
    [dic setObject:text forKey:@"text"];
    [self.photoDic setObject:dic forKey:[NSString stringWithFormat:@"id%@",photoDBID]];///////////////////////////////////////////////////////////////
//    NSLog(@"%@",self.photoDic);
//    NSString *photoDicStr=[self.photoDic JSONRepresentation];
    if ([self.photoDic writeToFile:self.photoDicPath atomically:YES]) {
        NSLog(@"write dic ok");
    }
    else {
        NSLog(@"write dic Fail");

    }
}
-(void) deletePhotoWithPhotoDBID:(NSString*)photoDBID
{
    NSString *path=[[self.photoDic objectForKey:[NSString stringWithFormat:@"id%@",photoDBID]] objectForKey:@"path"];
    NSLog(@"%@",path);
    NSFileManager *fileManager = [NSFileManager defaultManager];
    [fileManager removeItemAtPath:path error:NULL];
    
    [self.photoDic removeObjectForKey:[NSString stringWithFormat:@"id%@",photoDBID]];
    
    if ([self.photoDic writeToFile:self.photoDicPath atomically:YES]) {
        NSLog(@"write dic ok");
    }
    else {
        NSLog(@"write dic Fail");
        
    }
}
-(UIImage*) getPhotoByPhotoDBID:(NSString *)photoDBID
{
    NSString *imgPath=[[photoDic objectForKey:[NSString stringWithFormat:@"id%@",photoDBID]] objectForKey:@"path"];
    UIImage *img=[UIImage imageWithContentsOfFile:imgPath];
    return img;
}
@end
