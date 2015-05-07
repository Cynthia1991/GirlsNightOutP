//
//  MyDetailsManager.m
//  GurlsNightOut
//
//  Created by calvin on 3/05/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MyDetailsManager.h"
#import "PhotoManager.h"

@implementation MyDetailsManager
@synthesize userInfoDicPath,isShareDicPath,shareDicPath,userInfoDic,isShareDic,shareDic,userIcon,userPersonalInfoDic,userPersonalInfoDicPath;
- (id) init
{
    if (self = [super init]) {
        NSLog(@"-----------running myDetailsManager----------------");
        self.userInfoDicPath=[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"userInfoDicPath"];
        self.isShareDicPath=[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"isShareDicPath"];
        self.shareDicPath=[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"shareDicPath"];
        self.userPersonalInfoDicPath=[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"userPersonalInfoDicPath"];
        
        BOOL userInfoDicPathExists = [[NSFileManager defaultManager] fileExistsAtPath:self.userInfoDicPath];
        BOOL isShareDicPathExists = [[NSFileManager defaultManager] fileExistsAtPath:self.isShareDicPath];
        BOOL shareDicPathExists = [[NSFileManager defaultManager] fileExistsAtPath:self.shareDicPath];
        BOOL userPersonalInfoDicExists = [[NSFileManager defaultManager] fileExistsAtPath:self.userPersonalInfoDicPath];
        
        if (userInfoDicPathExists) {
            self.userInfoDic=[NSMutableDictionary dictionaryWithContentsOfFile:userInfoDicPath];
        }
        else {
            self.userInfoDic=[[NSMutableDictionary alloc] init];
        }
        
        if (isShareDicPathExists) {
            self.isShareDic=[NSMutableDictionary dictionaryWithContentsOfFile:isShareDicPath];
        }
        else {
            self.isShareDic=[[NSMutableDictionary alloc] init];
        }
        
        if (shareDicPathExists) {
            self.shareDic=[NSMutableDictionary dictionaryWithContentsOfFile:shareDicPath];
        }
        else {
            self.shareDic=[[NSMutableDictionary alloc] init];
        }
        if (userPersonalInfoDicExists) {
            self.userPersonalInfoDic=[NSMutableDictionary dictionaryWithContentsOfFile:userPersonalInfoDicPath];
        }
        else {
            self.userPersonalInfoDic=[[NSMutableDictionary alloc] init];
        }

        PhotoManager *photoManager=[[PhotoManager alloc] init];
        if ([[[self userInfoDic] objectForKey:@"photosDBID"] intValue]!=0) {
            if ([photoManager getPhotoByPhotoDBID:[[self userInfoDic] objectForKey:@"photosDBID"]]!=nil) {
                self.userIcon=[photoManager getPhotoByPhotoDBID:[[self userInfoDic] objectForKey:@"photosDBID"]];
            }
        }
        
        [self initIsShareDic];
        [self initShareDic];
    }    
    return self;
}

-(void) initIsShareDic
{
    if ([self.userInfoDic count]!=0) {
        if ([self.isShareDic count]==0) {
            [self.isShareDic setObject:[NSString stringWithFormat:@"1"] forKey:@"userID"];
            [self.isShareDic setObject:[NSString stringWithFormat:@"1"] forKey:@"userDBID"];
            [self.isShareDic setObject:[NSString stringWithFormat:@"1"] forKey:@"userName"];
            [self.isShareDic setObject:[NSString stringWithFormat:@"1"] forKey:@"photosDBID"];
            [self.isShareDic setObject:[NSString stringWithFormat:@"1"] forKey:@"deviceToken"];
            [self.isShareDic setObject:[NSString stringWithFormat:@"1"] forKey:@"latitude"];
            [self.isShareDic setObject:[NSString stringWithFormat:@"1"] forKey:@"longitude"];
            [self.isShareDic setObject:[NSString stringWithFormat:@"0"] forKey:@"userPassword"];
            [self.isShareDic setObject:[NSString stringWithFormat:@"0"] forKey:@"timeCreated"];
            [self.isShareDic setObject:[NSString stringWithFormat:@"0"] forKey:@"timeUpdated"];

            [self.isShareDic setObject:[NSString stringWithFormat:@"0"] forKey:@"mobilePhone"];
            [self.isShareDic setObject:[NSString stringWithFormat:@"0"] forKey:@"facebook"];

        }
        [self.isShareDic writeToFile:self.isShareDicPath atomically:YES];
        
        if ([self.shareDic count]==0) {
            [self.shareDic setObject:[NSString stringWithFormat:@""] forKey:@"userID"];
            [self.shareDic setObject:[NSString stringWithFormat:@""] forKey:@"userDBID"];
            [self.shareDic setObject:[NSString stringWithFormat:@""] forKey:@"userName"];
            [self.shareDic setObject:[NSString stringWithFormat:@""] forKey:@"photosDBID"];
            [self.shareDic setObject:[NSString stringWithFormat:@""] forKey:@"deviceToken"];
            [self.shareDic setObject:[NSString stringWithFormat:@""] forKey:@"latitude"];
            [self.shareDic setObject:[NSString stringWithFormat:@""] forKey:@"longitude"];
            [self.shareDic setObject:[NSString stringWithFormat:@""] forKey:@"userPassword"];
            [self.shareDic setObject:[NSString stringWithFormat:@""] forKey:@"timeCreated"];
            [self.shareDic setObject:[NSString stringWithFormat:@""] forKey:@"timeUpdated"];
            
            [self.shareDic setObject:[NSString stringWithFormat:@""] forKey:@"mobilePhone"];
            [self.shareDic setObject:[NSString stringWithFormat:@""] forKey:@"facebook"];
            
        }
        [self.shareDic writeToFile:self.shareDicPath atomically:YES];

    }
}

-(void) initShareDic
{
    if ([self.userInfoDic objectForKey:@"userID"]!=nil&&[[self.isShareDic objectForKey:@"userID"] intValue]==1) {
        [self.shareDic setObject:[self.userInfoDic objectForKey:@"userID"] forKey:@"userID"];
    }
    
    if ([self.userInfoDic objectForKey:@"userDBID"]!=nil&&[[self.isShareDic objectForKey:@"userDBID"] intValue]==1) {
        [self.shareDic setObject:[self.userInfoDic objectForKey:@"userDBID"] forKey:@"userDBID"];
    }
    
    if ([self.userInfoDic objectForKey:@"userName"]!=nil&&[[self.isShareDic objectForKey:@"userName"] intValue]==1) {
        [self.shareDic setObject:[self.userInfoDic objectForKey:@"userName"] forKey:@"userName"];
    }
    if ([self.userInfoDic objectForKey:@"photosDBID"]!=nil&&[[self.isShareDic objectForKey:@"photosDBID"] intValue]==1) {
        [self.shareDic setObject:[self.userInfoDic objectForKey:@"photosDBID"] forKey:@"photosDBID"];
    }
    if ([self.userInfoDic objectForKey:@"deviceToken"]!=nil&&[[self.isShareDic objectForKey:@"deviceToken"] intValue]==1) {
        [self.shareDic setObject:[self.userInfoDic objectForKey:@"deviceToken"] forKey:@"deviceToken"];
    }
    if ([self.userInfoDic objectForKey:@"latitude"]!=nil&&[[self.isShareDic objectForKey:@"latitude"] intValue]==1) {
        [self.shareDic setObject:[self.userInfoDic objectForKey:@"latitude"] forKey:@"latitude"];
    }
    if ([self.userInfoDic objectForKey:@"longitude"]!=nil&&[[self.isShareDic objectForKey:@"longitude"] intValue]==1) {
        [self.shareDic setObject:[self.userInfoDic objectForKey:@"longitude"] forKey:@"longitude"];
    }
    if ([self.userInfoDic objectForKey:@"userPassword"]!=nil&&[[self.isShareDic objectForKey:@"userPassword"] intValue]==1) {
        [self.shareDic setObject:[self.userInfoDic objectForKey:@"userPassword"] forKey:@"userPassword"];
    }
    if ([self.userInfoDic objectForKey:@"timeCreated"]!=nil&&[[self.isShareDic objectForKey:@"timeCreated"] intValue]==1) {
        [self.shareDic setObject:[self.userInfoDic objectForKey:@"timeCreated"] forKey:@"timeCreated"];
    }
    if ([self.userInfoDic objectForKey:@"timeUpdated"]!=nil&&[[self.isShareDic objectForKey:@"timeUpdated"] intValue]==1) {
        [self.shareDic setObject:[self.userInfoDic objectForKey:@"timeUpdated"] forKey:@"timeUpdated"];
    }
    if ([self.userPersonalInfoDic objectForKey:@"mobilePhone"]!=nil&&[[self.isShareDic objectForKey:@"mobilePhone"] intValue]==1) {
        [self.shareDic setObject:[self.userPersonalInfoDic objectForKey:@"mobilePhone"] forKey:@"mobilePhone"];
    }
    if ([self.userPersonalInfoDic objectForKey:@"facebook"]!=nil&&[[self.isShareDic objectForKey:@"facebook"] intValue]==1) {
        [self.shareDic setObject:[self.userPersonalInfoDic objectForKey:@"facebook"] forKey:@"facebook"];
    }
    
    
//    if ([self.userInfoDic count]!=0&&[self.isShareDic count]!=0) {
//        for (int i=0; i<[self.isShareDic count]; i++) {
//            if ([[self.isShareDic objectForKey:[[self.isShareDic allKeys] objectAtIndex:i]] boolValue]) {
//                [self.shareDic setObject:[self.userInfoDic objectForKey:[[self.isShareDic allKeys] objectAtIndex:i]] forKey:[[self.isShareDic allKeys] objectAtIndex:i]];
//            }
//            else {
//                [self.shareDic setObject:[NSString stringWithFormat:@""] forKey:[[self.isShareDic allKeys] objectAtIndex:i]];
//            }
//        }
//    }
//    if ([self.userPersonalInfoDic count]!=0&&[self.isShareDic count]!=0) {
//        for (int i=0; i<[self.isShareDic count]; i++) {
//            if ([[self.isShareDic objectForKey:[[self.isShareDic allKeys] objectAtIndex:i]] boolValue]) {
//                [self.shareDic setObject:[self.userInfoDic objectForKey:[[self.isShareDic allKeys] objectAtIndex:i]] forKey:[[self.isShareDic allKeys] objectAtIndex:i]];
//            }
//            else {
//                [self.shareDic setObject:[NSString stringWithFormat:@""] forKey:[[self.isShareDic allKeys] objectAtIndex:i]];
//            }
//        }
//    }
    [self.shareDic writeToFile:self.shareDicPath atomically:YES];
}

-(void) changeIsShareDicInFile:(NSString*) result KeyInDic:(NSString*) keyName
{
    [self.isShareDic setObject:result forKey:keyName];
    [self.isShareDic writeToFile:self.isShareDicPath atomically:YES];
}

-(void) rewriteUserInfoDic
{
    [self.userInfoDic writeToFile:userInfoDicPath atomically:YES];
}

-(void) rewriteUserPersonalInfoDic
{
    [self.userPersonalInfoDic writeToFile:userPersonalInfoDicPath atomically:YES];
}

- (void) saveUserIconByImage:(UIImage*)image
{
    self.userIcon=[image copy];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"delete icon" object:[self.userInfoDic objectForKey:@"photosDBID"]];//delete local icon
    
    //delete icon in server
    Kumulos *k=[[Kumulos alloc] init];
    [k setDelegate:self];
    [k deleteIconWithPhotosDBID:[[self.userInfoDic objectForKey:@"photosDBID"] intValue]];
}

-(void) updateDeviceToken
{
    NSString *deviceTokenPath=[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"deviceTokenPath"];
    NSString *deviceToken=[NSString stringWithContentsOfFile:deviceTokenPath encoding:NSASCIIStringEncoding error:nil];
    NSLog(@"%@",deviceToken);
    
    if ([self.userInfoDic objectForKey:@"userDBID"]!=nil) {
        NSString *userDBID=[NSString stringWithFormat:@"%@",[self.userInfoDic objectForKey:@"userDBID"]];
        NSLog(@"%@",userDBID);
        Kumulos *k=[[Kumulos alloc] init];    
        [k setDelegate:self];
        [k updateDeviceTokenWithDeviceToken:deviceToken andUserDBID:[userDBID intValue]];
    }
}
#pragma mark - kumulos delegate
-(void) kumulosAPI:(Kumulos *)kumulos apiOperation:(KSAPIOperation *)operation deleteIconDidCompleteWithResult:(NSNumber *)affectedRows
{
    NSData *imageData=UIImageJPEGRepresentation(self.userIcon, 1.0);;
    Kumulos *k=[[Kumulos alloc] init];
    [k setDelegate:self];
    [k uploadPhotosWithPhotoValue:imageData andTextValue:@"1" andLargePhotoValue:nil];
}
-(void) kumulosAPI:(Kumulos *)kumulos apiOperation:(KSAPIOperation *)operation uploadPhotosDidCompleteWithResult:(NSNumber *)newRecordID
{
    NSData *imageData=UIImageJPEGRepresentation(userIcon, 1.0);
    NSMutableDictionary *dic=[[NSMutableDictionary alloc] init];
    [dic setObject:imageData forKey:@"imageData"];
    [dic setObject:[NSString stringWithFormat:@"%@", newRecordID] forKey:@"photoDBID"];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"add icon" object:dic];

//    [photoManager addPhoto:imageData text:@"1" PhotoDBID:[NSString stringWithFormat:@"%@", newRecordID]];
    
    [self.userInfoDic setObject:[NSString stringWithFormat:@"%@",newRecordID] forKey:@"photosDBID"];
    [self rewriteUserInfoDic];
    
    Kumulos *k=[[Kumulos alloc] init];
    [k setDelegate:self];
    [k updateUserIconWithPhotosDBID:[newRecordID intValue] andUserDBID:[[self.userInfoDic objectForKey:@"userDBID"] intValue]];
    
//    if ([[[self userInfoDic] objectForKey:@"photosDBID"] intValue]==0) {
//        [k uploadPhotosWithPhotoValue:imageData andTextValue:@"1" andLargePhotoValue:nil];
//        
//    }
//    else {
//        [k updatePhotoWithPhotosDBID:[[[self userInfoDic] objectForKey:@"photosDBID"] intValue] andPhotoValue:imageData andLargePhotoValue:nil andTextValue:@"1"];
//    }

//    [k updateUserIconWithPhotosDBID:[newRecordID intValue] andUserDBID:[[[self userInfoDic] objectForKey:@"userDBID"] intValue] andUserIconUpdateTimes:0];
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
}
//-(void) kumulosAPI:(Kumulos *)kumulos apiOperation:(KSAPIOperation *)operation updatePhotoDidCompleteWithResult:(NSNumber *)affectedRows
//{
//    NSLog(@"upload photo");
//    NSData *imageData=UIImageJPEGRepresentation(userIcon, 1.0);
//    PhotoManager *photoManager=[[PhotoManager alloc] init];
//    [photoManager addPhoto:imageData text:@"1" PhotoDBID:[NSString stringWithFormat:@"%@", [[self userInfoDic] objectForKey:@"photosDBID"]]];
//    [[self userInfoDic] setObject:[NSString stringWithFormat:@"%@",[[self userInfoDic] objectForKey:@"photosDBID"]] forKey:@"photosDBID"];
//    [self rewriteUserInfoDic];
//    
//    
//    Kumulos *k=[[Kumulos alloc] init];
//    [k setDelegate:self];
//    [k updateIconTimesWithUserDBID:[[self.userInfoDic objectForKey:@"userDBID"] intValue] andUserIconUpdateTimes:[[self.userInfoDic objectForKey:@"userIconUpdateTimes"] intValue]+1];
//    
//}
-(void) kumulosAPI:(Kumulos *)kumulos apiOperation:(KSAPIOperation *)operation updateUserIconDidCompleteWithResult:(NSNumber *)affectedRows
{
    NSLog(@"upload icon");
    [[NSNotificationCenter defaultCenter] postNotificationName:@"dismiss my detail photo" object:nil];
}
-(void) kumulosAPI:(Kumulos *)kumulos apiOperation:(KSAPIOperation *)operation updateDeviceTokenDidCompleteWithResult:(NSNumber *)affectedRows
{
    NSLog(@"updateDeviceToken:%@",affectedRows);
}
@end
