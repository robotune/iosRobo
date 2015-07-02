//
//  DimensionSingleton.h
//  RoboTune2
//
//  Created by Alan O'Sullivan on 12/11/2014.
//  Copyright (c) 2014 Alan O'Sullivan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ScreenDimensionHelper : NSObject

@property CGPoint leftButtonPoint;
@property CGPoint rightButtonPoint;
@property CGPoint midButtonPoint;

@property CGPoint leftRecordButtonPoint;
@property CGPoint rightRecordButtonPoint;

@property int buttonCellHeight;
@property int labelSize;
@property float modalFontSize;
@property float modalWidth;
@property int borderRadius;

 +(ScreenDimensionHelper *) getInstance;

@end
