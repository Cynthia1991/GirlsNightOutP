//
//  customSegue.m
//  drinkTable
//
//  Created by Desmond on 4/06/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "customSegue.h"

@implementation customSegue

-(void)perform {
    UIViewController *sourceVC = (UIViewController *) self.sourceViewController;
    
    UIViewController *destinationVC = (UIViewController *) self.destinationViewController;
    
    [UIView transitionWithView:sourceVC.navigationController.view duration:1
                       options:UIViewAnimationOptionTransitionCurlUp
                    animations:^{
                        [sourceVC.navigationController pushViewController:destinationVC animated:NO];
                    }
                    completion:^(BOOL  completed)
     {     
         if (completed) 
         {
             return ;
         }
         //[sourceVC.navigationController pushViewController:destinationVC animated:NO];
     }                      
     ];
    
    
    
}

@end
