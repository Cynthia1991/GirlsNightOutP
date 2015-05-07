//
//  MyDetailsManager.h
//  GurlsNightOut
//
//  Created by calvin on 3/05/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Kumulos.h"

@interface MyDetailsManager : NSObject<KumulosDelegate>
{
    NSString *userInfoDicPath;
    NSMutableDictionary *userInfoDic;
    
    NSString *userPersonalInfoDicPath;
    NSMutableDictionary *userPersonalInfoDic;
    
    NSString *isShareDicPath;
    NSMutableDictionary *isShareDic;
    
    NSString *shareDicPath;
    NSMutableDictionary *shareDic;
    
    UIImage *userIcon;
    
    
}

@property (nonatomic, retain) NSString *userInfoDicPath;
@property (nonatomic, retain) NSString *isShareDicPath;
@property (nonatomic, retain) NSString *shareDicPath;
@property (nonatomic, retain) NSString *userPersonalInfoDicPath;

@property (nonatomic, retain) NSMutableDictionary *userInfoDic;
@property (nonatomic, retain) NSMutableDictionary *isShareDic;
@property (nonatomic, retain) NSMutableDictionary *shareDic;
@property (nonatomic, retain) NSMutableDictionary *userPersonalInfoDic;

@property (nonatomic, retain) UIImage *userIcon;

- (id) init;
- (void) initIsShareDic;
- (void) initShareDic;
- (void) changeIsShareDicInFile:(NSString*) result KeyInDic:(NSString*) keyName;
- (void) rewriteUserInfoDic;
- (void) rewriteUserPersonalInfoDic;
- (void) saveUserIconByImage:(UIImage*)image;
- (void) updateDeviceToken;

@end
