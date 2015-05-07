//
//  InstructionManager.m
//  gno
//
//  Created by Calvin on 4/10/12.
//
//

#import "InstructionManager.h"

@implementation InstructionManager
@synthesize instructionDic,instructionDicPath;
- (id) init
{
    if (self = [super init]) {        
        self.instructionDicPath=[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"instructionDicPath"];
        BOOL instructionDicPathExists = [[NSFileManager defaultManager] fileExistsAtPath:self.instructionDicPath];
        
        if (instructionDicPathExists) {
            self.instructionDic=[[NSMutableDictionary alloc] initWithContentsOfFile:self.instructionDicPath];
        }
        else {
            // Path to the plist (in the application bundle)
            NSString *path = [[NSBundle mainBundle] pathForResource:@"Instruction" ofType:@"plist"];
            
            // Build the array from the plist
            NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithContentsOfFile:path];
            
            self.instructionDic=[[NSMutableDictionary alloc] initWithDictionary:dic];
            [self writeToFile];
        }
    }
    return self;
}
-(void) setInstructionDicWithValue:(Boolean)isLook Key:(NSString *)key
{
    [self.instructionDic setObject:[NSNumber numberWithBool:isLook] forKey:key];
    [self writeToFile];
}
-(void) writeToFile
{
    [self.instructionDic writeToFile:self.instructionDicPath atomically:YES];
}
@end
