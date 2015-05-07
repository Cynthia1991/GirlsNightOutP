//
//  MyDetailsManager.h
//  GurlsNightOut
//
//  Created by calvin on 3/05/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyDetailsManager : NSObject
{
    NSString *userInfoDicPath;
    NSMutableDictionary *userInfoDic;
    
    NSString *isShareDicPath;
    NSMutableDictionary *isShareDic;
    
    NSString *shareDicPath;
    NSMutableDictionary *shareDic;
}

@property (nonatomic, retain) NSString *userInfoDicPath;
@property (nonatomic, retain) NSString *isShareDicPath;
@property (nonatomic, retain) NSString *shareDicPath;

@property (nonatomic, retain) NSMutableDictionary *userInfoDic;
@property (nonatomic, retain) NSMutableDictionary *isShareDic;
@property (nonatomic, retain) NSMutableDictionary *shareDic;

- (id) init;
- (void) initIsShareDic;
- (void) initShareDic;
- (void) changeIsShareDicInFile:(NSString*) result KeyInDic:(NSString*) keyName;

@end
