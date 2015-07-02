//
//  UIBarButtonItem+WithImageOnly.h
//  RoboTune2
//
//  Created by Alan O'Sullivan on 12/10/2014.
//  Copyright (c) 2014 Alan O'Sullivan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface UIBarButtonItem (WithImageOnly)

- (id)initWithImage:(UIImage*)image target:(id)target action:(SEL)action;

@end