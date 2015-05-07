//
//  gameTask.m
//  GNOdare
//
//  Created by Desmond on 6/11/12.
//  Copyright (c) 2012 QUT. All rights reserved.
//

#import "gameTask.h"

@implementation gameTask


//@synthesize truthGameContent, truthGamePlist;
@synthesize dareGameContent, dareGamePlist;

-(id)initWithTruthGameName:(NSString *)truthGameName
{
    if (self = [super init]) {
        self.truthGamePlist = truthGameName;
        
        self.truthGameContent = [[NSArray alloc] initWithContentsOfFile:[[NSBundle mainBundle]
                                                                  pathForResource:self.truthGamePlist ofType:@"plist"]];
        
        //NSLog(@"truth init %@",self.truthGamePlist);
    }
    return self;
}


- (NSDictionary *)truthGameItemAtIndex:(int)index
{
    return (self.truthGameContent != nil && [self.truthGameContent count] > 0 && index < [self.truthGameContent count])
	? [self.truthGameContent objectAtIndex:index]
	: nil;
}

- (int)truthgameTaskCount
{
    //NSLog(@"truth123 %i",(self.truthGameContent != nil) ? [self.truthGameContent count] : 0);
    //NSLog(@"truth %i",[self.truthGameContent count] );
    return (self.truthGameContent != nil) ? [self.truthGameContent count] : 0;
}

-(id)initWithDareGameName:(NSString *)daregameName
{
    if (self = [super init]) {
         dareGamePlist= daregameName;
        dareGameContent = [[NSArray alloc] initWithContentsOfFile:[[NSBundle mainBundle]
                                                                    pathForResource:dareGamePlist ofType:@"plist"]];
    }
    return self;
}

- (NSDictionary *)dareGameItemAtIndex:(int)index
{
    return (dareGameContent != nil && [dareGameContent count] > 0 && index < [dareGameContent count])
	? [dareGameContent objectAtIndex:index]
	: nil;
}

- (int)dareGameTaskCount    
{
    return (dareGameContent != nil) ? [dareGameContent count] : 0;
}


@end
