//
//  ColorSingleton.h
//  RoboTune2
//
//  Created by Alan O'Sullivan on 11/10/2014.
//  Copyright (c) 2014 Alan O'Sullivan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ColorSingleton : NSObject
{
    #define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
    
    #define _RGB(r,g,b,a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]
}

@property (nonatomic, strong) UIColor *cc6666;
@property (nonatomic, strong) UIColor *cc3333;
@property (nonatomic, strong) UIColor *c993333;
@property (nonatomic, strong) UIColor *c660000;
@property (nonatomic, strong) UIColor *ff6666;
@property (nonatomic, strong) UIColor *mainRed;
@property (nonatomic, strong) UIColor *white;
@property (nonatomic, strong) UIColor *black;

@property (nonatomic, strong) UIColor *ffcccc;
@property (nonatomic, strong) UIColor *cc9999;
@property (nonatomic, strong) UIColor *ff9999;

@property (nonatomic, strong) UIColor *c333333;

@property (nonatomic, strong) UIColor *titleBarRed;

@property (nonatomic, strong) UIColor *recordRed;
@property (nonatomic, strong) UIColor *recordRedBorder;

@property (nonatomic, strong) UIColor *playGreen;
@property (nonatomic, strong) UIColor *playGreenBorder;

@property (nonatomic, strong) UIColor *disabled;
@property (nonatomic, strong) UIColor *greyinfo;
@property (nonatomic, strong) UIColor *greyinfobg;

@property (nonatomic, strong) UIColor *presetbg;
@property (nonatomic, strong) UIColor *presettitle;
@property (nonatomic, strong) UIColor *presetborder;


 +(ColorSingleton *) getInstance;

@end
