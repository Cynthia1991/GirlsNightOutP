//
//  DrinkingView.m
//  GNO
//
//  Created by Calvin on 29/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DrinkingView.h"

@implementation DrinkingView
@synthesize drink,drinkID,postID,userID,eventID,timeStamp;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}
- (id)initWithFrame:(CGRect)frame Date:(NSDate*)drinkDate Drink:(Drinks*) drink1
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        //add images and time label view
        appDelegate=(AppDelegate*)[[UIApplication sharedApplication] delegate];
        self.drink=drink1;

        UIImage *img = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png",drink.imageName]];
        UIImageView *imgView = [[UIImageView alloc]initWithImage:img];
        imgView.frame=CGRectMake(0, 0, frame.size.width, frame.size.height);
        //time stamp
        //        NSDate *now = [[NSDate alloc] init];
        
        NSDateFormatter *dateTimeFormat = [[NSDateFormatter alloc] init];
        [dateTimeFormat setDateFormat:@"HH:mm aaa"]; //24 hrs
        NSString *theDate = [dateTimeFormat stringFromDate:drinkDate];
        NSLog(@"%@",theDate);
        //time label
        self.timeStamp = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 50, 20)];
        [self.timeStamp setCenter:CGPointMake(imgView.frame.size.width/2, imgView.frame.size.height/2)];
        self.timeStamp.adjustsFontSizeToFitWidth = YES;
        self.timeStamp.text = theDate;
        self.timeStamp.textColor=[UIColor whiteColor];
        self.timeStamp.backgroundColor = [UIColor clearColor];
        
        //subview
//        UIView *drinkView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, imgView.frame.size.width, imgView.frame.size.height)];
        
        //set tap location
//        [self setFrame:frame];        
        [self setCenter:CGPointMake(frame.origin.x, frame.origin.y)];
        //add image and time to subview
        [self addSubview:imgView];
        [self addSubview:timeStamp];
        
        //add gesture to view
        UIPanGestureRecognizer *recognizer1 = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(handlePan1:)];
        [self addGestureRecognizer:recognizer1];
        
        UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(deleteDrinkView:)];
        tapRecognizer.numberOfTapsRequired = 2;
        [self addGestureRecognizer:tapRecognizer];

    }
    return self;
}
-(void)deleteDrinkView:(UIPanGestureRecognizer *)recognizer//move drinks
{
    NSLog(@"long press");
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Delete Drink" message:[NSString stringWithFormat:@"Are you sure delete %@ ?", drink.drinkName] delegate:self cancelButtonTitle:@"NO" otherButtonTitles:@"YES", nil];
    [alert show];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==1) {
        for (int i=0; i<[[appDelegate.timelineManager.timelineDic objectForKey:eventID] count]; i++) {
            if ([[[[appDelegate.timelineManager.timelineDic objectForKey:eventID] objectAtIndex:i] objectForKey:@"eventPostDBID"] intValue]==[postID intValue]) {
                [[appDelegate.timelineManager.timelineDic objectForKey:eventID] removeObjectAtIndex:i];
                break;
            }
        }
        [appDelegate.timelineManager writeToFile];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"GetAllPost" object:self];
        
        //////////////////////////////////////
        for (int i=0; i<[[appDelegate.addDrinkManager.addedDrinkDic objectForKey:[NSString stringWithFormat:@"%@",[self eventID]]] count]; i++) {
            DrinkingView *drinkingView=[[appDelegate.addDrinkManager.addedDrinkDic objectForKey:[NSString stringWithFormat:@"%@",[self eventID]]] objectAtIndex:i];
            
            if ([self.drinkID intValue] == [drinkingView.drinkID intValue]) {
                [[appDelegate.addDrinkManager.addedDrinkDic objectForKey:[NSString stringWithFormat:@"%@",[self eventID]]] removeObjectAtIndex:i];
                break;
            }
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:@"initAddedDrinks" object:self];

        Kumulos *k=[[Kumulos alloc] init];
        [k setDelegate:self];
        [k deletePostWithEventPostDBID:[postID intValue]];
    }
}

#pragma mark - move drinks location
-(void)handlePan1:(UIPanGestureRecognizer *)recognizer//move drinks
{
    
//    [myScrollView setScrollEnabled:NO];/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    //    [self.view bringSubviewToFront:recognizer.view];/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    CGPoint pre_moveLocation = [recognizer locationInView:recognizer.view];
    NSLog(@"previous location %@",NSStringFromCGPoint(pre_moveLocation));        
    
    CGPoint translation = [recognizer translationInView:self];
    
    [recognizer.view setCenter:CGPointMake(recognizer.view.center.x + translation.x, recognizer.view.center.y + translation.y)];
    [recognizer setTranslation:CGPointMake(0, 0) inView:recognizer.view];
    
    CGPoint cur_moveLocation = [recognizer locationInView:recognizer.view];
    if (cur_moveLocation.x==pre_moveLocation.x&&cur_moveLocation.y==pre_moveLocation.y) {
//        NSLog(@"ccc");
        if (isUpdate==0) {
            isUpdate=1;
        }
        else {
            isUpdate=0;
            ////////////////////////////////////////////////////////////////////////////////////////post to the server
            NSMutableDictionary *dic=[[NSMutableDictionary alloc] init];
            [dic setObject:self.drinkID forKey:@"drinksID"];
            [dic setObject:drink.addedDateValue forKey:@"timeCreated"];
            [dic setObject:[NSString stringWithFormat:@"%.2f",self.center.x] forKey:@"drinkX"];
            [dic setObject:[NSString stringWithFormat:@"%.2f",self.center.y] forKey:@"drinkY"];
            //        NSLog(@"%@",dic);
            
            NSMutableData *data = [[NSMutableData alloc] init];
            NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
            [archiver encodeObject:dic forKey:@"DrinkDetail"];
            [archiver finishEncoding];
            
            NSLog(@"%@,%@",[NSString stringWithFormat:@"%.2f",self.frame.origin.x],[NSString stringWithFormat:@"%.2f",self.frame.origin.y]);
            
            
            Kumulos *k=[[Kumulos alloc] init];
            [k setDelegate:self];
            [k updateDrinkLocationWithDrinksDetail:data andEventPostDBID:[[self postID] intValue]];
        }
    }

//    [myScrollView setScrollEnabled:YES];/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
}
#pragma mark - kumulos location
-(void) kumulosAPI:(Kumulos *)kumulos apiOperation:(KSAPIOperation *)operation updateDrinkLocationDidCompleteWithResult:(NSNumber *)affectedRows
{
    NSLog(@"change dring dic:%@",affectedRows);
}

-(void) kumulosAPI:(Kumulos *)kumulos apiOperation:(KSAPIOperation *)operation deletePostDidCompleteWithResult:(NSNumber *)affectedRows
{
    [self removeFromSuperview];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
