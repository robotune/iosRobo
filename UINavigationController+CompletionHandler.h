//
//  UINavigationController+CompletionHandler.h
//  RoboTune2
//
//  Created by Alan O'Sullivan on 06/12/2014.
//  Copyright (c) 2014 Alan O'Sullivan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UINavigationController (CompletionHandler)

- (void)pushViewController:(UIViewController *)viewController
                  animated:(BOOL)animated
                completion:(void (^)(void))completion;

@end
