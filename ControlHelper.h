//
//  ButtonHelper.h
//  RoboTune2
//
//  Created by Alan O'Sullivan on 20/10/2014.
//  Copyright (c) 2014 Alan O'Sullivan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DKCircleButton.h"
#import "ScreenDimensionHelper.h"

@interface ControlHelper : NSObject
{
       ScreenDimensionHelper *screenHelper;
}

+(DKCircleButton*)getDKButton:(NSString *) title withTag:(NSInteger)tag forSelector:(SEL)selector owner:(UIViewController*)controller radius:(NSInteger) radius fontSize:(NSInteger)fontSize;

+(UILabel *)getSliderLabel:(UISlider *)sender withTag:(NSInteger)tag;

@end
