//
//  InternetChecker.m
//  QUT Mobile
//
//  Created by calvin on 9/12/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "InternetChecker.h"

@implementation InternetChecker

-(BOOL) internetCheck
{
    BOOL isConnect=0;
    
    appDelegate=(AppDelegate*)[[UIApplication sharedApplication] delegate];
    
    NSString *networkCheckPath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"networdCondition"];
    NSMutableArray *array=[[NSMutableArray alloc] init];
    
    Reachability *r = [Reachability reachabilityWithHostName:@"www.apple.com"];
    switch ([r currentReachabilityStatus]) {
        case NotReachable:
            // No network connection
            NSLog(@"No network connection");
            appDelegate.isConnectInternet=NO;
            isConnect=NO;
            
            [array addObject:[NSString stringWithFormat:@"0"]];
            [array writeToFile:networkCheckPath atomically:YES];
            break;
        case ReachableViaWWAN:
            // 3G network
            NSLog(@"3G network connection");
            appDelegate.isConnectInternet=YES;
            isConnect=YES;
            
            [array addObject:[NSString stringWithFormat:@"1"]];
            [array writeToFile:networkCheckPath atomically:YES];
            ////////////////////////////////////////udate in network environment
            
            break;
        case ReachableViaWiFi:
            // WiFi network
            NSLog(@"WIFI network connection");
            appDelegate.isConnectInternet=YES;
            isConnect=YES;
            
            [array addObject:[NSString stringWithFormat:@"1"]];
            [array writeToFile:networkCheckPath atomically:YES];
            ////////////////////////////////////////udate in network environment
            
            break;
    }
    return isConnect;
}
//-(void) updateInNetwork
//{
//    NSString *profileUpdateResultPath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"profileUpdateResultPath"];
//        
//    NSString *completedUpdateResultPath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"completedUpdateResultPath"];
//    
//    NSString *profileUpdateResult=[NSString stringWithContentsOfFile:profileUpdateResultPath encoding:NSASCIIStringEncoding error:nil];
//
//    
//    ////////////////////////////////////////profile
//    if ([profileUpdateResult isEqualToString:@"0"]) {
//        NSString *profileArrayPath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"profileArrayPath"];
//        BOOL profileFileExists = [[NSFileManager defaultManager] fileExistsAtPath:profileArrayPath];
//        if (profileFileExists) 
//        {
//            NSMutableArray *profileArray = [NSMutableArray arrayWithContentsOfFile:profileArrayPath];
//            NSString *studentID=[[profileArray objectAtIndex:0] objectForKey:@"studentID"];
//            NSString *studentName=[[profileArray objectAtIndex:0] objectForKey:@"studentName"];
//            NSString *faculty=[[profileArray objectAtIndex:0] objectForKey:@"faculty"];
//            NSString *studyLevel=[[profileArray objectAtIndex:0] objectForKey:@"studyLevel"];
//            NSString *course=[[profileArray objectAtIndex:0] objectForKey:@"course"];
//            
//            //student name
//            NSString *newStudentName=[studentName stringByReplacingOccurrencesOfString:@" " withString:@"+"];
//            
//            //faculty
//            NSString *newFaculty=[faculty stringByReplacingOccurrencesOfString:@" " withString:@"+"];
//            
//            //studyLevel
//            NSString *newStudyLevel=[studyLevel stringByReplacingOccurrencesOfString:@" " withString:@"+"];
//            
//            //course
//            NSString *newCourse=[course stringByReplacingOccurrencesOfString:@" " withString:@"+"];
//            
//            ProfileManager *pm=[[ProfileManager alloc] init];
//            bool result=[pm updateServerProfileWithStudentID:studentID StudentName:newStudentName Faculty:newFaculty StudyLevel:newStudyLevel Course:newCourse];
//            [pm release];
//            //                    NSLog(@"%d",result);
//            [[NSString stringWithFormat:@"%d",result] writeToFile:profileUpdateResultPath atomically:YES encoding:NSASCIIStringEncoding error:nil];
//        } 
//    }
//    
//    /////////////////////////////////////////Completed challenge
//    NSString *str=[[NSString alloc] initWithContentsOfFile:completedUpdateResultPath encoding:NSASCIIStringEncoding error:nil];
//    
//    NSMutableArray *arrayCompleted=[[[NSMutableArray alloc] init] autorelease];
//    if (str!=nil) {
//        NSData* jsonData=[str dataUsingEncoding:NSUTF8StringEncoding];
//        JSONDecoder *jsonKitDecoder = [JSONDecoder decoder];
//        arrayCompleted=[jsonKitDecoder mutableObjectWithData:jsonData];
//    }
//    
//    //            NSLog(@"%@",arrayCompleted);
//    if ([arrayCompleted count]!=0) {
//        dispatch_async(dispatch_get_global_queue(0, 0), ^
//                       {
//                           [self updateForEach:arrayCompleted SaveResult:completedUpdateResultPath];                
//                       });
//    }
//    [str release];
//}
//
//- (void) updateForEach:(NSMutableArray *) arrayCompleted SaveResult:(NSString *) completedUpdateResultPath
//{
//    for (int i=0; i<[arrayCompleted count]; i++) {
//        NSString *urlStr=[NSString stringWithFormat:@"%@/updateCompleted.jsp?completedAchNum=%d&completedDate=%@&achID=%@&achSetID=%@&studentID=%@&password=orientationqut&completedTime=%@",kWebHostIP,[[arrayCompleted objectAtIndex:i] objectForKey:@"setCompleteNum"],[[arrayCompleted objectAtIndex:i] objectForKey:@"theDate"],[[arrayCompleted objectAtIndex:i] objectForKey:@"achID"],[[arrayCompleted objectAtIndex:i] objectForKey:@"setID"],[[arrayCompleted objectAtIndex:i] objectForKey:@"studentID"],[[arrayCompleted objectAtIndex:i] objectForKey:@"theTime"]];
//        NSURL *url=[NSURL URLWithString:urlStr];
//        [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:nil];
//    }
//    
//    
//    
//    [arrayCompleted removeAllObjects];
//    NSString *arrayStr=[arrayCompleted JSONString];
//    
//    [arrayStr writeToFile: completedUpdateResultPath atomically: YES encoding:NSASCIIStringEncoding error: nil];
//}
@end
