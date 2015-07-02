//
//  ButtonHelper.m
//  RoboTune2
//
//  Created by Alan O'Sullivan on 20/10/2014.
//  Copyright (c) 2014 Alan O'Sullivan. All rights reserved.
//

#import "ControlHelper.h"

#import "ColorSingleton.h"

@implementation ControlHelper

+(DKCircleButton*)getDKButton:(NSString *) title withTag:(NSInteger)tag forSelector:(SEL)selector owner:(UIViewController*)controller radius:(NSInteger) radius fontSize:(NSInteger)fontSize
{
    ColorSingleton *colors = [ColorSingleton getInstance];
    
    DKCircleButton *button = [[DKCircleButton alloc] initWithFrame:CGRectMake(0, 0, radius, radius)];
    
    [button addTarget:controller action:selector forControlEvents:UIControlEventTouchUpInside];
    //button.center = point; //CGPointMake(90, 90);
    button.titleLabel.font = [UIFont systemFontOfSize:fontSize];
    //button.backgroundColor = color;
    
    [button setTitle:NSLocalizedString(title, nil) forState:UIControlStateNormal];
    [button setTitle:NSLocalizedString(title, nil) forState:UIControlStateSelected];
    [button setTitle:NSLocalizedString(title, nil) forState:UIControlStateHighlighted];
    button.tag = tag;
    [button setDisplayShading:false];
    [button setBorderColor:colors.black];
    
    //[cell addSubview:button];
    
    return button;
    
}

+ (UILabel *)getSliderLabel:(UISlider *)sender withTag:(NSInteger)tag
{
    ScreenDimensionHelper *screenHelper = [ScreenDimensionHelper getInstance];

    UIImageView *handleView = [sender.subviews lastObject];
    UILabel *label = (UILabel*)[handleView viewWithTag:tag];
    
    
    if (!label) { //Create new instance
        
        label = [[UILabel alloc] init];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor whiteColor];
        label.textAlignment = NSTextAlignmentCenter;
        [label setFont:[UIFont systemFontOfSize:screenHelper.labelSize]];
        label.tag = tag; //Assign a tag so that you can get the instance from parentview next time
        [handleView addSubview:label];
    }
    else
    {
        
    }
    // NSLog(@"imageView bounds height %f width %f", handleView.bounds.size.height,handleView.bounds.size.width );
    
    [label setFrame:handleView.bounds];
    return label;
    
}


@end
