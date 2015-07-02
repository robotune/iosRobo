//
//  UINavigationController+CompletionHandler.m
//  RoboTune2
//
//  Created by Alan O'Sullivan on 06/12/2014.
//  Copyright (c) 2014 Alan O'Sullivan. All rights reserved.
//

#import "UINavigationController+CompletionHandler.h"
#import <QuartzCore/QuartzCore.h>

@implementation UINavigationController (CompletionHandler)
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated completion:(void (^)(void))completion {
    [CATransaction begin];
    [CATransaction setCompletionBlock:completion];
    [self pushViewController:viewController animated:animated];
    [CATransaction commit];
}

@end