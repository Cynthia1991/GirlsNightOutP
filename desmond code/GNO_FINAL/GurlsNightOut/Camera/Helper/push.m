//
//  push.m
//  photoBooth
//
//  Created by Desmond on 28/06/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "push.h"

@implementation push

-(void)perform {
    UIViewController *sourceVC = (UIViewController *) self.sourceViewController;
    
    UIViewController *destinationVC = (UIViewController *) self.destinationViewController;
    
    [UIView transitionWithView:sourceVC.navigationController.view duration:0.5
                       options:UIViewAnimationOptionTransitionCrossDissolve
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
