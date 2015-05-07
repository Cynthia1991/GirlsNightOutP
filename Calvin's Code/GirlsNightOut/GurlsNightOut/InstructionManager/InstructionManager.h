//
//  InstructionManager.h
//  gno
//
//  Created by Calvin on 4/10/12.
//
//

#import <Foundation/Foundation.h>

@interface InstructionManager : NSObject

@property (nonatomic, strong) NSMutableDictionary *instructionDic;
@property (nonatomic, strong) NSString *instructionDicPath;
-(void) writeToFile;
-(void) setInstructionDicWithValue:(Boolean) isLook Key:(NSString *) key;
@end
