//
//  ShowLoopSegue.m
//  RoboTune2
//
//  Created by Alan O'Sullivan on 30/11/2014.
//  Copyright (c) 2014 Alan O'Sullivan. All rights reserved.
//

#import "ShowLoopSegue.h"
#import "ViewControllerLoop.h"

@implementation ShowLoopSegue

- (void)perform {
    UIViewController *sourceViewController = self.sourceViewController;
    
       
 
    
    UIViewController *destinationViewController = self.destinationViewController;
    
    // Add the destination view as a subview, temporarily
    [sourceViewController.view addSubview:destinationViewController.view];
    
    // Transformation start scale
    //destinationViewController.view.transform = CGAffineTransformMakeScale(0.05, 0.05);
    
    //Transformation start position
    destinationViewController.view.transform = CGAffineTransformMakeTranslation(-sourceViewController.view.bounds.size.width, 0);
    
    
    // Store original centre point of the destination view
    CGPoint originalCenter = destinationViewController.view.center;
    // Set center to start point of the button
    destinationViewController.view.center = self.originatingPoint;
    
    [UIView animateWithDuration:0.75
                          delay:0.1
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         // Grow!
                         //destinationViewController.view.transform = CGAffineTransformMakeScale(1.0, 1.0);
                         destinationViewController.view.transform = CGAffineTransformMakeTranslation(0, 0);
                         destinationViewController.view.center = originalCenter;
                     }
                     completion:^(BOOL finished){
                         [destinationViewController.view removeFromSuperview]; // remove from temp super view
                         [sourceViewController presentViewController:destinationViewController animated:YES completion:NULL]; // present VC
                     }];
}

@end
