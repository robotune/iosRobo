//
//  ChannelNames.m
//  RoboTune2
//
//  Created by Alan O'Sullivan on 16/10/2014.
//  Copyright (c) 2014 Alan O'Sullivan. All rights reserved.
//

#import "ChannelNames.h"

@implementation ChannelNames

static ChannelNames * single=nil;

+(ChannelNames *)getInstance
{
    @synchronized(self)
    {
        if(!single)
        {
            single = [[ChannelNames alloc] init];
            
            single.CHANNEL_SOURCE = @"source";
            single.CHANNEL_CROSS= @"cross";
            single.CHANNEL_GATE= @"gateswitch";
            single.CHANNEL_GATEVALUE= @"gate";
            single.CHANNEL_APPREVERB= @"appreverb";
            single.CHANNEL_APPDELAY = @"appdelay";
            single.CHANNEL_REVERBLEVEL = @"reverblevel";
            single.CHANNEL_REVERBTONE = @"reverbtone";
            single.CHANNEL_DELAYINTERVAL = @"delayinterval";
            single.CHANNEL_DELAYFDB = @"fdb";
            single.CHANNEL_SCALE = @"scale";
            single.CHANNEL_CLICK = @"click";
            single.CHANNEL_KEY = @"key";
            single.CHANNEL_AUTOROBO = @"autorobo";
            single.CHANNEL_HARMLEVEL1 = @"harmlevel1";
            single.CHANNEL_HARMLEVEL2 = @"harmlevel2";
            single.CHANNEL_HARMLEVEL3 = @"harmlevel3";
            single.CHANNEL_HARM1 = @"harm1";
            single.CHANNEL_HARM2 = @"harm2";
            single.CHANNEL_HARM3 = @"harm3";
            single.CHANNEL_HARMFORM = @"harm1form";
            single.CHANNEL_MAINLEVEL = @"mainlevel";
            
            single.CHANNEL_LOOP = @"loop";
            single.CHANNEL_LOOPPLAY = @"loopplay";
            single.CHANNEL_LOOPPOS = @"looppos";
            single.CHANNEL_LOOPTYPE = @"looptype";
            single.CHANNEL_LOOPSYNC = @"loopsync";
            single.CHANNEL_LOOPLEVEL = @"looplevel";
            single.CHANNEL_TEMPO = @"tempo";
        }
        
        
        return single;
    }
    
}

+(NSString *)getCSDFile
{
     NSString *csdFile = [[NSBundle mainBundle] pathForResource:@"finalrobo8" ofType:@"csd"];
    return csdFile;
}

@end
