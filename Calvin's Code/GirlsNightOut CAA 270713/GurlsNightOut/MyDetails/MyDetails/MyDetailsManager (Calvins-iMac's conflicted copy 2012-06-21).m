//
//  MyDetailsManager.m
//  GurlsNightOut
//
//  Created by calvin on 3/05/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MyDetailsManager.h"

@implementation MyDetailsManager
@synthesize userInfoDicPath,isShareDicPath,shareDicPath,userInfoDic,isShareDic,shareDic;
- (id) init
{
    if (self = [super init]) {
        self.userInfoDicPath=[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"userInfoDicPath"];
        self.isShareDicPath=[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"isShareDicPath"];
        self.shareDicPath=[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"shareDicPath"];
        
        BOOL userInfoDicPathExists = [[NSFileManager defaultManager] fileExistsAtPath:self.userInfoDicPath];
        BOOL isShareDicPathExists = [[NSFileManager defaultManager] fileExistsAtPath:self.isShareDicPath];
        BOOL shareDicPathExists = [[NSFileManager defaultManager] fileExistsAtPath:self.shareDicPath];
        
        if (userInfoDicPathExists) {
            self.userInfoDic=[NSDictionary dictionaryWithContentsOfFile:userInfoDicPath];
        }
        else {
            self.userInfoDic=[[NSMutableDictionary alloc] init];
        }
        
        if (isShareDicPathExists) {
            self.isShareDic=[NSDictionary dictionaryWithContentsOfFile:isShareDicPath];
        }
        else {
            self.isShareDic=[[NSMutableDictionary alloc] init];
        }
        
        if (shareDicPathExists) {
            self.shareDic=[NSDictionary dictionaryWithContentsOfFile:shareDicPath];
        }
        else {
            self.shareDic=[[NSMutableDictionary alloc] init];
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
            [self.isShareDic setObject:[NSString stringWithFormat:@"0"] forKey:@"userPassword"];
            [self.isShareDic setObject:[NSString stringWithFormat:@"0"] forKey:@"timeCreated"];
            [self.isShareDic setObject:[NSString stringWithFormat:@"0"] forKey:@"timeUpdated"];
        }    
        [self.isShareDic writeToFile:self.isShareDicPath atomically:YES];
    }
}

-(void) initShareDic
{
    if ([self.userInfoDic count]!=0&&[self.isShareDic count]!=0) {
        for (int i=0; i<[self.isShareDic count]; i++) {
            if ([[self.isShareDic objectForKey:[[self.isShareDic allKeys] objectAtIndex:i]] boolValue]) {
                [self.shareDic setObject:[self.userInfoDic objectForKey:[[self.isShareDic allKeys] objectAtIndex:i]] forKey:[[self.isShareDic allKeys] objectAtIndex:i]];
            }
            else {
                [self.shareDic setObject:[NSString stringWithFormat:@""] forKey:[[self.isShareDic allKeys] objectAtIndex:i]];
            }
        }
        [self.shareDic writeToFile:self.shareDicPath atomically:YES];
    }
}

-(void) changeIsShareDicInFile:(NSString*) result KeyInDic:(NSString*) keyName
{
    [self.isShareDic setObject:result forKey:keyName];
    [self.isShareDic writeToFile:self.isShareDicPath atomically:YES];
}

@end
