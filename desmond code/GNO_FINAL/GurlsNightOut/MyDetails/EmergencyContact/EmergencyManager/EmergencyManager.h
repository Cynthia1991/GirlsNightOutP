//
//  EmergencyManager.h
//  gno
//
//  Created by Calvin on 28/09/12.
//
//

#import <UIKit/UIKit.h>

@interface EmergencyManager : NSObject
{
}
@property (nonatomic, retain) NSString *emergencyInfoArrayPath;
@property (nonatomic, retain) NSMutableArray *emergencyInfoArray;
-(void) addEmergencyContactWithName:(NSString *) contactName Relationship:(NSString*) relationship PhoneNumber:(NSString*) phoneNumber;
-(void) deleteContactWithIndex:(NSInteger) index;
@end
