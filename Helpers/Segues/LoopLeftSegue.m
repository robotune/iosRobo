//
//  LoopLeftSegue.m
//  RoboTune2
//
//  Created by Alan O'Sullivan on 02/12/2014.
//  Copyright (c) 2014 Alan O'Sullivan. All rights reserved.
//

#import "LoopLeftSegue.h"
#import "UINavigationController+CompletionHandler.h"
//#import "ViewControllerLoop.h"

@implementation LoopLeftSegue

//not being used. useful to know it can be overriden
- (id)initWithIdentifier:(NSString *)identifier
                  source:(UIViewController *)source
             destination:(UIViewController *)destination
{
    return [super initWithIdentifier:identifier
                              source:source
                         destination:destination];
}

-(void)perform {
    
    UIViewController *sourceViewController = (UIViewController*)[self sourceViewController];
    UIViewController *destinationController = (UIViewController*)[self destinationViewController];
    
    CATransition* transition = [CATransition animation];
    transition.duration = .4;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionPush; //kCATransitionMoveIn; //, kCATransitionPush, kCATransitionReveal, kCATransitionFade
    transition.subtype = kCATransitionFromLeft; //kCATransitionFromLeft, kCATransitionFromRight, kCATransitionFromTop, kCATransitionFromBottom
    
    [sourceViewController.navigationController.view.layer addAnimation:transition forKey:kCATransition];
    [sourceViewController.navigationController pushViewController:destinationController animated:YES completion:nil];
    
    /* don't need right now
     
    [sourceViewController.navigationController pushViewController:destinationController animated:YES completion:^{

        [self log];
        //[destinationController initRecordCurrentState];
    }];

    */
    
    
}

-(void)log
{
    NSLog(@"COMPLETED!");
}

@end
