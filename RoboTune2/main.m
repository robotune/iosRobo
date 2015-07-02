//
//  main.m
//  RoboTune2
//
//  Created by Alan O'Sullivan on 21/09/2014.
//  Copyright (c) 2014 Alan O'Sullivan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <PixateFreestyle/PixateFreestyle.h>
#import "AppDelegate.h"

int main(int argc, char * argv[])
{
    @autoreleasepool {
             [PixateFreestyle initializePixateFreestyle];
        return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
    }
}
