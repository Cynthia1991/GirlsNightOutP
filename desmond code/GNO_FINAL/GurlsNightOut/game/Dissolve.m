//
//  customSegueAnimation.m
//  SLQ
//
//  Created by Desmond on 27/01/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Dissolve.h"

@implementation Dissolve

-(void)perform {
    UIViewController *sourceVC = (UIViewController *) self.sourceViewController;
    
    UIViewController *destinationVC = (UIViewController *) self.destinationViewController;
    
    [UIView transitionWithView:sourceVC.navigationController.view duration:1.5
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
