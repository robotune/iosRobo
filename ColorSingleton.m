//
//  ColorSingleton.m
//  RoboTune2
//
//  Created by Alan O'Sullivan on 11/10/2014.
//  Copyright (c) 2014 Alan O'Sullivan. All rights reserved.
//

#import "ColorSingleton.h"

@implementation ColorSingleton


static ColorSingleton * single=nil;

+(ColorSingleton *)getInstance
{
    @synchronized(self)
    {
        if(!single)
        {
            single = [[ColorSingleton alloc] init];
            
            single.cc6666 = (UIColor*)UIColorFromRGB(0xcc6666);
            single.cc3333 = (UIColor*)UIColorFromRGB(0xcc3333);
            single.c993333 = (UIColor*)UIColorFromRGB(0x993333);
            single.c660000 = (UIColor*)UIColorFromRGB(0x660000);
            single.ff6666 = (UIColor*)UIColorFromRGB(0xff6666);
            single.mainRed = (UIColor*)UIColorFromRGB(0x9b2123);
            single.ffcccc = (UIColor*)UIColorFromRGB(0xffcccc);
            single.cc9999 = (UIColor*)UIColorFromRGB(0xcc9999);
            single.c333333 = (UIColor*)UIColorFromRGB(0x333333);
            single.titleBarRed = (UIColor*)UIColorFromRGB(0xa90329);
            
            
            single.recordRed= (UIColor*)UIColorFromRGB(0xff0000);
            single.recordRedBorder = (UIColor*)UIColorFromRGB(0x990000);

            single.playGreen = (UIColor*)UIColorFromRGB(0x339933);
            single.playGreenBorder = (UIColor*)UIColorFromRGB(0x006600);

            single.white = [UIColor whiteColor];
            single.black = [UIColor blackColor];
            
            single.greyinfo = (UIColor*)UIColorFromRGB(0x808080);
            single.greyinfobg = (UIColor*)UIColorFromRGB(0xD8D8D8);
            single.presetbg = (UIColor*)UIColorFromRGB(0xC8C8C8);
            single.presettitle = (UIColor*)UIColorFromRGB(0x000000);
            single.presetborder = (UIColor*)UIColorFromRGB(0x000000);
            
            single.disabled = _RGB(204, 204, 204, 0.6);
        }
    
    
    return single;
    }
    
}

@end
