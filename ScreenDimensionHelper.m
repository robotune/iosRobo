//
//  DimensionSingleton.m
//  RoboTune2
//
//  Created by Alan O'Sullivan on 12/11/2014.
//  Copyright (c) 2014 Alan O'Sullivan. All rights reserved.
//

#import "ScreenDimensionHelper.h"

@implementation ScreenDimensionHelper

static ScreenDimensionHelper * screenHelper=nil;

static int iPhoneCellHeight=120;
static int iPadCellHeight=240;

static int xLeftPointIPad = 140;
static int xRightPointIPad = 628;
static int xMidPointIPad = 384;

static int xLeftRecordPointIPad = 160;
static int xRightRecordPointIPad = 608;

static float iPadModalFontSize = 24.f;
static float iPhoneModalFontSize = 14.f;

static float iPhoneModalWidth = 280.f;
static float iPadModalWidth = 540.f;

//TODO REFACTOR THIS IN LIGHT OF NOT USING TABLE CELLS FOR THE PRESETS
+(ScreenDimensionHelper *)getInstance
{
    @synchronized(self)
    {
        if(!screenHelper)
        {
            screenHelper = [[ScreenDimensionHelper alloc] init];
            
            CGRect screenBounds = [[UIScreen mainScreen] bounds];
            CGSize screenSize = screenBounds.size;

            if(screenSize.height < 568) //iPhone 4s
            {
                iPhoneCellHeight= 105; //TEMPORARY since presets don't scroll for iPhone 4s
            }
            
            screenHelper.modalFontSize = iPhoneModalFontSize;
            screenHelper.modalWidth = iPhoneModalWidth;
            screenHelper.buttonCellHeight = iPhoneCellHeight /2;
            
            
            screenHelper.leftRecordButtonPoint=CGPointMake(screenSize.width/4-10,screenHelper.buttonCellHeight);
            screenHelper.rightRecordButtonPoint= CGPointMake(screenSize.width-70,screenHelper.buttonCellHeight);
            
            screenHelper.leftButtonPoint=CGPointMake(screenSize.width/4-25,screenHelper.buttonCellHeight);
            screenHelper.rightButtonPoint= CGPointMake(screenSize.width-55,screenHelper.buttonCellHeight);
            screenHelper.midButtonPoint= CGPointMake(screenSize.width/4+80,screenHelper.buttonCellHeight);
            screenHelper.labelSize = 16;
            screenHelper.borderRadius = 100;
           
            
            if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
            {
                screenHelper.modalWidth = iPadModalWidth;
                screenHelper.modalFontSize = iPadModalFontSize;
                screenHelper.borderRadius = 220;
                screenHelper.buttonCellHeight = iPadCellHeight /2;
                screenHelper.labelSize=28;
                
                screenHelper.leftRecordButtonPoint=CGPointMake(xLeftRecordPointIPad,screenHelper.buttonCellHeight);
                screenHelper.rightRecordButtonPoint= CGPointMake(xRightRecordPointIPad,screenHelper.buttonCellHeight);

                
                screenHelper.midButtonPoint= CGPointMake(xMidPointIPad,screenHelper.buttonCellHeight);
                screenHelper.leftButtonPoint= CGPointMake(xLeftPointIPad,screenHelper.buttonCellHeight);
                screenHelper.rightButtonPoint= CGPointMake(xRightPointIPad,screenHelper.buttonCellHeight);
                
            }

            
            
            
        }
        
        
        return screenHelper;
    }
    
}


@end
