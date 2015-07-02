//
//  UIBarButtonItem+WithImageOnly.m
//  RoboTune2
//
//  Created by Alan O'Sullivan on 12/10/2014.
//  Copyright (c) 2014 Alan O'Sullivan. All rights reserved.
//

#import "UIBarButtonItem+WithImageOnly.h"

@implementation UIBarButtonItem (WithImageOnly)

- (id)initWithImage:(UIImage *)image target:(id)target action:(SEL)action {
    CGRect frame = CGRectMake(0, 0, image.size.width, image.size.height);
    frame = CGRectInset(frame, -5, 0);
    
    UIButton *button = [[UIButton alloc] initWithFrame:frame];
    [button setImage:image forState:UIControlStateNormal];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    return [self initWithCustomView:button];
}

@end