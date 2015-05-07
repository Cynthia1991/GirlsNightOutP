//
//  showDrinkedList.m
//  gno
//
//  Created by Calvin on 14/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "showDrinkedList.h"
#import "DrinkTableViewController.h"
#import "DrinkTableViewListViewController.h"

@implementation showDrinkedList
-(void)perform {
    DrinkTableViewController *sourceVC = (DrinkTableViewController *) self.sourceViewController;
    
    DrinkTableViewListViewController *destinationVC = (DrinkTableViewListViewController *) self.destinationViewController;
    
    [destinationVC setEventDBID:[sourceVC eventDBID]];
    destinationVC.modalTransitionStyle = UIModalTransitionStylePartialCurl;

    [sourceVC presentModalViewController:destinationVC animated:YES];
//    [UIView transitionWithView:sourceVC.navigationController.view duration:1
//                       options:UIViewAnimationOptionTransitionCurlUp
//                    animations:^{
//                        [sourceVC.navigationController pushViewController:destinationVC animated:NO];
//                    }
//                    completion:^(BOOL  completed)
//     {     
//         if (completed) 
//         {
//             return ;
//         }
//         //[sourceVC.navigationController pushViewController:destinationVC animated:NO];
//     }                      
//     ];
    
    
    
}
@end
