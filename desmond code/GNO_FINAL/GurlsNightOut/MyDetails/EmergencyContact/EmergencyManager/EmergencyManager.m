//
//  EmergencyManager.m
//  gno
//
//  Created by Calvin on 28/09/12.
//
//

#import "EmergencyManager.h"

@implementation EmergencyManager
@synthesize emergencyInfoArray,emergencyInfoArrayPath;

- (id) init
{
    if (self = [super init]) {
        self.emergencyInfoArrayPath=[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"emergencyInfoDicPath"];
        BOOL emergencyInfoArrayPathExists = [[NSFileManager defaultManager] fileExistsAtPath:self.emergencyInfoArrayPath];
        if (emergencyInfoArrayPathExists) {
            self.emergencyInfoArray=[NSMutableArray arrayWithContentsOfFile:emergencyInfoArrayPath];
        }
        else {
            self.emergencyInfoArray=[[NSMutableArray alloc] init];
        }
    }
    return self;
}
-(void) addEmergencyContactWithName:(NSString *)contactName Relationship:(NSString *)relationship PhoneNumber:(NSString *)phoneNumber
{
    NSMutableDictionary *dic=[[NSMutableDictionary alloc] init];
    [dic setObject:contactName forKey:@"contactName"];
    [dic setObject:relationship forKey:@"relationship"];
    [dic setObject:phoneNumber forKey:@"phoneNumber"];
    
    [self.emergencyInfoArray addObject:dic];
    [self.emergencyInfoArray writeToFile:self.emergencyInfoArrayPath atomically:YES];
}

-(void) deleteContactWithIndex:(NSInteger)index
{
    [self.emergencyInfoArray removeObjectAtIndex:index];
    [self.emergencyInfoArray writeToFile:self.emergencyInfoArrayPath atomically:YES];
}
@end
