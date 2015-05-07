//
//  ViewController.m
//  drinkTable
//
//  Created by Desmond on 1/06/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DrinkTableViewController.h"
#import "DrinkingView.h"

@implementation DrinkTableViewController
@synthesize lbDrinkName;
@synthesize lbDrinkContent;
@synthesize btBlackboard;

@synthesize aDelegate,myScrollView,eventDBID,userDBID,eventMainPageViewController,addDrinksFunction,isActivity;

#pragma mark - App life cycle
-(void)viewDidAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}
- (void)viewWillAppear:(BOOL)animated
{
//    [self initSelectedDrink];
    if (isActivity) {
        btBlackboard.enabled=NO;
        lbDrinkContent.text=[NSString stringWithFormat:@""];
    }
    else
    {
        btBlackboard.enabled=YES;
    }
}
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.    
    self.aDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    
    if (!isActivity) {//if event is activitied, then add gesture to the view
        UILongPressGestureRecognizer *tapRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(addImgView:)];
        tapRecognizer.numberOfTouchesRequired = 1;
        tapRecognizer.minimumPressDuration = 0.7;
        
        [self.view addGestureRecognizer:tapRecognizer];
    }

    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveTestNotification:) name:@"Drink Selected Notification1" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(initAddedDrinkArray:) name:@"initAddedDrinkArray" object:nil];
    
    Kumulos *k=[[Kumulos alloc] init];
    [k setDelegate:self];
    [k getAllDrinksWithFunction:3 andEventID:[self eventDBID]];
    
    [self initSelectedDrink];
}

- (void)viewDidUnload
{
    [self setLbDrinkName:nil];
    [self setLbDrinkContent:nil];
    [self setBtBlackboard:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}
- (void) initAddedDrinkArray:(NSNotification *) notification
{
    NSMutableArray *theResult=[notification object];
    
    if ([self eventDBID]!=0) {
        if ([aDelegate.addDrinkManager.addedDrinkDic objectForKey:[NSString stringWithFormat:@"%d",[self eventDBID]]]==nil) {
            NSMutableArray *arr=[[NSMutableArray alloc] init];
            [aDelegate.addDrinkManager.addedDrinkDic setObject:arr forKey:[NSString stringWithFormat:@"%d",[self eventDBID]]];
        }
    }
            
    [self initAddDrinkDicWithResult:theResult];
    if (addDrinksFunction==0) {
        [self addInitDrinksImage];
        addDrinksFunction=1;
    }

}
-(void) initAddDrinkDicWithResult:(NSMutableArray*) theResult
{
    ///////////get addedDrinkArray
    NSMutableArray *abc=[[NSMutableArray alloc] init];
    for (int i=0; i<[theResult count]; i++) {
        if ([[[theResult objectAtIndex:i] objectForKey:@"function"] intValue]==3) {
            
            //decode drink from server
            NSLog(@"%@",[theResult objectAtIndex:i]);
            
            NSData *data=[[theResult objectAtIndex:i] objectForKey:@"drinksDetail"];
            NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
            NSMutableDictionary *myDictionary = [unarchiver decodeObjectForKey:@"DrinkDetail"];
            [unarchiver finishDecoding];
            
            //                NSLog(@"%@",myDictionary);
            
            NSLog(@"%.2f,%.2f",[[myDictionary objectForKey:@"drinkX"] floatValue],[[myDictionary objectForKey:@"drinkY"] floatValue]);
            Drinks *drink=[[aDelegate addDrinkManager] selectADrinkID:[myDictionary objectForKey:@"drinksID"]];
            CGRect frame;
            if (drink.imageSize==1) {
                frame=CGRectMake([[myDictionary objectForKey:@"drinkX"] floatValue], [[myDictionary objectForKey:@"drinkY"] floatValue], 55, 70);
            }
            else if (drink.imageSize==2) {
                frame=CGRectMake([[myDictionary objectForKey:@"drinkX"] floatValue], [[myDictionary objectForKey:@"drinkY"] floatValue], 60, 97);
            }
            else if (drink.imageSize==3) {
                frame=CGRectMake([[myDictionary objectForKey:@"drinkX"] floatValue], [[myDictionary objectForKey:@"drinkY"] floatValue], 75, 115);
            }
            else if (drink.imageSize==4) {
                frame=CGRectMake([[myDictionary objectForKey:@"drinkX"] floatValue], [[myDictionary objectForKey:@"drinkY"] floatValue], 65, 185);
            }
            else if (drink.imageSize==5) {
                frame=CGRectMake([[myDictionary objectForKey:@"drinkX"] floatValue], [[myDictionary objectForKey:@"drinkY"] floatValue], 65, 285);
            }
            
//            DrinkingView *drinkingView=[[DrinkingView alloc] initWithFrame:CGRectMake([[myDictionary objectForKey:@"drinkX"] floatValue], [[myDictionary objectForKey:@"drinkY"] floatValue], 75, 115) Date:[myDictionary objectForKey:@"timeCreated"] Drink:drink];

            DrinkingView *drinkingView=[[DrinkingView alloc] initWithFrame:frame Date:[myDictionary objectForKey:@"timeCreated"] Drink:drink];
            drinkingView.postID=[[theResult objectAtIndex:i] objectForKey:@"eventPostDBID"];
            drinkingView.eventID=[NSString stringWithFormat:@"%d",[self eventDBID]];
            drinkingView.drinkID=[myDictionary objectForKey:@"drinksID"];
//            drinkingView.drink=[[aDelegate addDrinkManager] selectADrinkID:[myDictionary objectForKey:@"drinksID"]];
            drinkingView.drink.addedDateValue=[[theResult objectAtIndex:i] objectForKey:@"timeCreated"];
            drinkingView.userID=[[[theResult objectAtIndex:i] objectForKey:@"userID"] objectForKey:@"userDBID"];
            
            [abc addObject:drinkingView];
        }
    }
    [[[[aDelegate addDrinkManager] addedDrinkDic] objectForKey:[NSString stringWithFormat:@"%d",[self eventDBID]]] removeAllObjects];
    [[[[aDelegate addDrinkManager] addedDrinkDic] objectForKey:[NSString stringWithFormat:@"%d",[self eventDBID]]] addObjectsFromArray:abc];
    NSLog(@"%d",[abc count]);
}
-(void) addInitDrinksImage
{
    for (int i=0; i<[[[[aDelegate addDrinkManager] addedDrinkDic] objectForKey:[NSString stringWithFormat:@"%d",[self eventDBID]]] count]; i++) {
        DrinkingView *drinkView=[[[[aDelegate addDrinkManager] addedDrinkDic] objectForKey:[NSString stringWithFormat:@"%d",[self eventDBID]]] objectAtIndex:i];
        if ([[aDelegate.myDetailsManager.userInfoDic objectForKey:@"userDBID"] intValue] == [drinkView.userID intValue]) {
            NSDateFormatter *dateTimeFormat = [[NSDateFormatter alloc] init];
            [dateTimeFormat setDateFormat:@"HH:mm aaa"]; //24 hrs
            NSString *theDate = [dateTimeFormat stringFromDate:drinkView.drink.addedDateValue];
            
            drinkView.timeStamp.text=theDate;
            
            [self.view addSubview:drinkView];
        }
    }
}
//-(UIView *) createDrinkView:(NSDate*) drinkDate x:(float) x y:(float)y
//{
//    //add images and time label view
//    UIImage *img = [UIImage imageNamed:@"beer.png"];  
//    UIImageView *imgView = [[UIImageView alloc]initWithImage:img];
//    
//    //time stamp
//    //        NSDate *now = [[NSDate alloc] init];
//    
//    NSDateFormatter *dateTimeFormat = [[NSDateFormatter alloc] init];
//    [dateTimeFormat setDateFormat:@"HH:mm aaa"]; //24 hrs
//    NSString *theDate = [dateTimeFormat stringFromDate:drinkDate];
//    
//    //time label
//    UILabel *timeStamp = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 50, 20)];
//    [timeStamp setCenter:CGPointMake(imgView.frame.size.width/2, imgView.frame.size.height-15)];
//    timeStamp.adjustsFontSizeToFitWidth = YES;
//    timeStamp.text = theDate;
//    timeStamp.textColor=[UIColor whiteColor];
//    timeStamp.backgroundColor = [UIColor clearColor];
//    
//    //subview
//    UIView *drinkView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, imgView.frame.size.width, imgView.frame.size.height)];
//    
//    //set tap location
//    [drinkView setCenter:CGPointMake(x,y)];        
//    
//    //add image and time to subview
//    [drinkView addSubview:imgView];
//    [drinkView addSubview:timeStamp];
//    
//    //add gesture to view
//    UIPanGestureRecognizer *recognizer1 = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(handlePan1:)];
//    [drinkView addGestureRecognizer:recognizer1];
//    
//    //add to view
//    return drinkView;
//}
//#pragma mark - move drinks location
//-(void)handlePan1:(UIPanGestureRecognizer *)recognizer//move drinks
//{
//
//    [myScrollView setScrollEnabled:NO];/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////    [self.view bringSubviewToFront:recognizer.view];/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//    
//    CGPoint pre_moveLocation = [recognizer locationInView:recognizer.view];
//    NSLog(@"previous location %@",NSStringFromCGPoint(pre_moveLocation));        
//        
//    CGPoint translation = [recognizer translationInView:self.view];
//    
//    [recognizer.view setCenter:CGPointMake(recognizer.view.center.x + translation.x, recognizer.view.center.y + translation.y)];
//    [recognizer setTranslation:CGPointMake(0, 0) inView:recognizer.view];
//    
//    [myScrollView setScrollEnabled:YES];/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//}

#pragma mark - long press gesture detect
-(void)addImgView:(UILongPressGestureRecognizer *)recognizer//long press detect
{
    if(UIGestureRecognizerStateBegan == recognizer.state) {
        if (aDelegate.addDrinkManager.enteredDrinkList!=nil) {
            // Called on start of gesture, do work here
            CGPoint tapLocation = [recognizer locationInView:recognizer.view];

            [self addImgViewAfterPopTime:tapLocation.x Y:tapLocation.y];
        }
        else {
            UIAlertView *alter=[[UIAlertView alloc] initWithTitle:@"Select Drink" message:@"Please select a drink" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alter show];
        }
    }
    
    if(UIGestureRecognizerStateChanged == recognizer.state) {
        // Do repeated work here (repeats continuously) while finger is down
        NSLog(@"UIGestureRecognizerStateChanged");
    }
    
    if(UIGestureRecognizerStateEnded == recognizer.state) {
        // Do end work here when finger is lifted
        NSLog(@"UIGestureRecognizerStateEnded");
    }
}

#pragma mark - notification
- (void) receiveTestNotification:(NSNotification *) notification
{   
    NSLog (@"Successfully received the test notification!");
    [self addImgViewAfterPopTime:200 Y:200];
}

#pragma mark - add drink function
-(void)initSelectedDrink
{
    Drinks *drink=[aDelegate.addDrinkManager getSelectedDrinkWithEventDBID:[NSString stringWithFormat:@"%d",[self eventDBID]]];
    
//    a
    if (drink!=nil) {
        // Called on start of gesture, do work here
        lbDrinkName.text=[NSString stringWithFormat:@"%@",drink.drinkName];
        lbDrinkContent.text=[NSString stringWithFormat:@"%@ml - %@%% Alcohol",drink.volume,drink.percentage];
    }
    else {
        lbDrinkName.text=[NSString stringWithFormat:@"No selected drink"];
        lbDrinkContent.text=[NSString stringWithFormat:@"Touch to select"];
    }
    
    [aDelegate.addDrinkManager setEnteredDrinkList:drink];
}
-(void)addImgViewAfterPopTime:(float) x Y:(float)y
{
    NSLog(@"Drink ID %@",aDelegate.addDrinkManager.enteredDrinkList.drinkID);

    [aDelegate.addDrinkManager setSelectedDrinkDicWithDrinkID:aDelegate.addDrinkManager.enteredDrinkList.drinkID EventDBID:[NSString stringWithFormat:@"%d",[self eventDBID]]];
    [self initSelectedDrink];
    //time stamp
    NSDate *now = [[NSDate alloc] init];
    
//    NSDateFormatter *dateTimeFormat = [[NSDateFormatter alloc] init];
//    [dateTimeFormat setDateFormat:@"HH:mm aaa"]; //24 hrs
//    NSString *theDate = [dateTimeFormat stringFromDate:now];
    
    ////////////////////////////////////////////////////////////////////////////////////////post to the server
    NSMutableDictionary *dic=[[NSMutableDictionary alloc] init];
    [dic setObject:[NSString stringWithFormat:@"%@",aDelegate.addDrinkManager.enteredDrinkList.drinkID] forKey:@"drinksID"];
    [dic setObject:[NSString stringWithFormat:@"%@",now] forKey:@"timeCreated"];
    [dic setObject:[NSString stringWithFormat:@"%.2f",x] forKey:@"drinkX"];
    [dic setObject:[NSString stringWithFormat:@"%.2f",y] forKey:@"drinkY"];
    NSLog(@"%@",dic);
    
    NSMutableData *data = [[NSMutableData alloc] init];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    [archiver encodeObject:dic forKey:@"DrinkDetail"];
    [archiver finishEncoding];
    
    NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
    NSMutableDictionary *myDictionary = [unarchiver decodeObjectForKey:@"DrinkDetail"];
    [unarchiver finishDecoding];
    
    NSLog(@"%@",myDictionary);
    
//    NSMutableData *data = [[theResults objectAtIndex:0] objectForKey:@"drinksDetail"];
//    NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
//    NSMutableDictionary *myDictionary = [unarchiver decodeObjectForKey:@"DrinkDetail"];
//    [unarchiver finishDecoding];
//    
//    NSDate *now = [[NSDate alloc] init];
    
    Drinks *drink=[[aDelegate addDrinkManager] selectADrinkID:[dic objectForKey:@"drinksID"]];
    CGRect frame;
    if (drink.imageSize==1) {
        frame=CGRectMake([[dic objectForKey:@"drinkX"] floatValue], [[dic objectForKey:@"drinkY"] floatValue], 55, 70);
    }
    else if (drink.imageSize==2) {
        frame=CGRectMake([[dic objectForKey:@"drinkX"] floatValue], [[dic objectForKey:@"drinkY"] floatValue], 60, 97);
    }
    else if (drink.imageSize==3) {
        frame=CGRectMake([[dic objectForKey:@"drinkX"] floatValue], [[dic objectForKey:@"drinkY"] floatValue], 75, 115);
    }
    else if (drink.imageSize==4) {
        frame=CGRectMake([[dic objectForKey:@"drinkX"] floatValue], [[dic objectForKey:@"drinkY"] floatValue], 65, 185);
    }
    else if (drink.imageSize==5) {
        frame=CGRectMake([[dic objectForKey:@"drinkX"] floatValue], [[dic objectForKey:@"drinkY"] floatValue], 65, 285);
    }
    
    DrinkingView *drinkingView=[[DrinkingView alloc] initWithFrame:frame Date:now Drink:drink];
    drinkingView.eventID=[NSString stringWithFormat:@"%d",[self eventDBID]];

//    DrinkingView *drinkingView=[[DrinkingView alloc] initWithFrame:CGRectMake([[dic objectForKey:@"drinkX"] floatValue], [[dic objectForKey:@"drinkY"] floatValue], 75, 115) Date:now Drink:[[aDelegate addDrinkManager] selectADrinkID:[dic objectForKey:@"drinksID"]]];
//    drinkingView.postID=[[theResults objectAtIndex:0] objectForKey:@"eventPostDBID"];
    drinkingView.drinkID=[dic objectForKey:@"drinksID"];
//    drinkingView.drink=[[aDelegate addDrinkManager] selectADrinkID:[dic objectForKey:@"drinksID"]];
    drinkingView.drink.addedDateValue=[NSString stringWithFormat:@"%@",now];
    [[[[aDelegate addDrinkManager] addedDrinkDic] objectForKey:[NSString stringWithFormat:@"%d",[self eventDBID]]] addObject:drinkingView];
    [self.view addSubview:drinkingView];
    
    
    
    Kumulos *k=[[Kumulos alloc] init];
    [k setDelegate:self];
    [k createPostWithTextValue:nil andFunction:3 andDrinksDetail:data andPhotoDetail:nil andUserID:[self userDBID] andEventID:[self eventDBID]];
    
    
    
    
    
//    //add images and time label view
//    UIImage *img = [UIImage imageNamed:@"beer.png"];  
//    UIImageView *imgView = [[UIImageView alloc]initWithImage:img];
//
    //time stamp
//    NSDate *now = [[NSDate alloc] init];
//
//    NSDateFormatter *dateTimeFormat = [[NSDateFormatter alloc] init];
//    [dateTimeFormat setDateFormat:@"HH:mm aaa"]; //24 hrs
//    NSString *theDate = [dateTimeFormat stringFromDate:now];
//    
//    //time label
//    UILabel *timeStamp = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 50, 20)];
//    [timeStamp setCenter:CGPointMake(imgView.frame.size.width/2, imgView.frame.size.height-15)];
//    timeStamp.adjustsFontSizeToFitWidth = YES;
//    timeStamp.text = theDate;
//    timeStamp.backgroundColor = [UIColor clearColor];
        
    //subview
//    DrinkingView *drinkingView=[[DrinkingView alloc] initWithFrame:CGRectMake(x, y, 75, 115) Date:now];
//    drinkingView.postID=[[[[[eventMainPageViewController timelineManager] timelineDic] objectForKey:[NSString stringWithFormat:@"%d",[self eventDBID]]] objectAtIndex:i] objectForKey:@"eventPostDBID"];
//    
//    drinkingView.drinkID=[myDictionary objectForKey:@"drinksID"];
//    drinkingView.drink=[[aDelegate addDrinkManager] selectADrinkID:[myDictionary objectForKey:@"drinksID"]];
//    drinkingView.drink.addedDateValue=[[[[[eventMainPageViewController timelineManager] timelineDic] objectForKey:[NSString stringWithFormat:@"%d",[self eventDBID]]] objectAtIndex:i] objectForKey:@"timeCreated"];
    
    
    
    
    
    
    
//    UIView *drinkView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, imgView.frame.size.width, imgView.frame.size.height)];
//
//    //set tap location
//    if (x==0.0f&&y==0.0f) {
//        [drinkView setCenter:CGPointMake(150,150)];        
//    }
//    else {
//        [drinkView setCenter:CGPointMake(x,y)];        
//
//    }
//    
//    //add image and time to subview
//    [drinkView addSubview:imgView];
//    [drinkView addSubview:timeStamp];
//    
//    //add gesture to view
//    UIPanGestureRecognizer *recognizer1 = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(handlePan1:)];
//    [drinkView addGestureRecognizer:recognizer1];
//    
//    //add to view
//    [self.view addSubview:drinkView];
//    
//    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"drinkID LIKE %@", aDelegate.addDrinkManager.enteredDrinkList.drinkID];
//    NSArray *abc = [[aDelegate.addDrinkManager.addedDrinkDic objectForKey:[NSString stringWithFormat:@"%d",[self eventDBID]]] filteredArrayUsingPredicate:predicate];
    
   
//    ////////////////////////////////////////////////////////////////////////////////////////post to the server
//    NSMutableDictionary *dic=[[NSMutableDictionary alloc] init];
//    [dic setObject:[NSString stringWithFormat:@"%@",aDelegate.addDrinkManager.enteredDrinkList.drinkID] forKey:@"drinksID"];
//    [dic setObject:[NSString stringWithFormat:@"%@",now] forKey:@"timeCreated"];
//    [dic setObject:[NSString stringWithFormat:@"%.2f",x] forKey:@"drinkX"];
//    [dic setObject:[NSString stringWithFormat:@"%.2f",y] forKey:@"drinkY"];
//    NSLog(@"%@",dic);
//
//    NSMutableData *data = [[NSMutableData alloc] init];
//    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
//    [archiver encodeObject:dic forKey:@"DrinkDetail"];
//    [archiver finishEncoding];
//
//    NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
//    NSMutableDictionary *myDictionary = [unarchiver decodeObjectForKey:@"DrinkDetail"];
//    [unarchiver finishDecoding];
//    
//    NSLog(@"%@",myDictionary);
//    Kumulos *k=[[Kumulos alloc] init];
//    [k setDelegate:self];
//    [k createPostWithTextValue:nil andFunction:3 andPhotoDBID:0 andDrinksDetail:data andUserID:[self userDBID] andEventID:[self eventDBID]];
//    [k createPostWithTextValue:nil andDrinksID:[aDelegate.addDrinkManager.enteredDrinkList.drinkID intValue] andFunction:3 andPhotoValue:0 andUserID:[self userDBID] andEventID:[self eventDBID]];
    
//    if ([abc count]==0) {
//
//        aDelegate.addDrinkManager.enteredDrinkList.catCount=[NSString stringWithFormat:@"1"];
//        [[aDelegate.addDrinkManager.addedDrinkDic objectForKey:[NSString stringWithFormat:@"%d",[self eventDBID]]]addObject:aDelegate.addDrinkManager.enteredDrinkList];
//    }
//    else {
//        Drinks *drink=[abc objectAtIndex:0];
//        NSInteger count=[drink.catCount intValue];
//        drink.catCount=[NSString stringWithFormat:@"%d",count+1];
//    }
}
-(void) kumulosAPI:(Kumulos *)kumulos apiOperation:(KSAPIOperation *)operation createPostDidCompleteWithResult:(NSNumber *)newRecordID
{
    [aDelegate.timelineManager reloadPostByEventID:[NSString stringWithFormat:@"%d",[self eventDBID]]];
    NSString *massege=[NSString stringWithFormat:@"Add a drink"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadTimelineTableView" object:massege];

    Kumulos *k=[[Kumulos alloc] init];
    [k setDelegate:self];
    [k getOnePostWithEventPostDBID:[newRecordID intValue]];
}
-(void) kumulosAPI:(Kumulos *)kumulos apiOperation:(KSAPIOperation *)operation getOnePostDidCompleteWithResult:(NSArray *)theResults
{
//    NSMutableData *data = [[theResults objectAtIndex:0] objectForKey:@"drinksDetail"];   
//    NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
//    NSMutableDictionary *myDictionary = [unarchiver decodeObjectForKey:@"DrinkDetail"];
//    [unarchiver finishDecoding];
//    
//    NSDate *now = [[NSDate alloc] init];
//
//    DrinkingView *drinkingView=[[DrinkingView alloc] initWithFrame:CGRectMake([[myDictionary objectForKey:@"drinkX"] floatValue], [[myDictionary objectForKey:@"drinkY"] floatValue], 75, 115) Date:now];
//    drinkingView.postID=[[theResults objectAtIndex:0] objectForKey:@"eventPostDBID"];
//    drinkingView.drinkID=[myDictionary objectForKey:@"drinksID"];
//    drinkingView.drink=[[aDelegate addDrinkManager] selectADrinkID:[myDictionary objectForKey:@"drinksID"]];
//    drinkingView.drink.addedDateValue=[[theResults objectAtIndex:0] objectForKey:@"timeCreated"];
//    [[[[aDelegate addDrinkManager] addedDrinkDic] objectForKey:[NSString stringWithFormat:@"%d",[self eventDBID]]] addObject:drinkingView];
//    [self.view addSubview:drinkingView];
    DrinkingView *drinkView=[self.view.subviews objectAtIndex:[self.view.subviews count]-1];
    drinkView.postID=[[theResults objectAtIndex:0] objectForKey:@"eventPostDBID"];
    
//    if (addDrinksFunction==1) {
        Kumulos *k=[[Kumulos alloc] init];
        [k setDelegate:self];
        [k getAllDrinksWithFunction:3 andEventID:[self eventDBID]];
//    }

}

-(void) kumulosAPI:(Kumulos *)kumulos apiOperation:(KSAPIOperation *)operation getAllDrinksDidCompleteWithResult:(NSArray *)theResults
{
//    addDrinksFunction=0;
    NSMutableArray *arr=[[NSMutableArray alloc] initWithArray:theResults];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"initAddedDrinkArray" object:arr];
}
@end
