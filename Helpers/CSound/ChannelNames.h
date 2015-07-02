//
//  ChannelNames.h
//  RoboTune2
//
//  Created by Alan O'Sullivan on 16/10/2014.
//  Copyright (c) 2014 Alan O'Sullivan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ChannelNames : NSObject

@property  NSString *const CHANNEL_SOURCE;
@property  NSString *const CHANNEL_CROSS;
@property  NSString *const CHANNEL_GATE;
@property  NSString *const CHANNEL_GATEVALUE;
@property  NSString *const CHANNEL_APPREVERB;
@property  NSString *const CHANNEL_APPDELAY;
@property  NSString *const CHANNEL_REVERBLEVEL;
@property  NSString *const CHANNEL_REVERBTONE;
@property  NSString *const CHANNEL_DELAYINTERVAL;
@property  NSString *const CHANNEL_DELAYFDB;
@property  NSString *const CHANNEL_SCALE;
@property  NSString *const CHANNEL_CLICK;
@property  NSString *const CHANNEL_KEY;
@property  NSString *const CHANNEL_AUTOROBO;
@property  NSString *const CHANNEL_HARMLEVEL1;
@property  NSString *const CHANNEL_HARMLEVEL2;
@property  NSString *const CHANNEL_HARMLEVEL3;
@property  NSString *const CHANNEL_HARM1;
@property  NSString *const CHANNEL_HARM2;
@property  NSString *const CHANNEL_HARM3;
@property  NSString *const CHANNEL_HARMFORM;
@property  NSString *const CHANNEL_MAINLEVEL;

@property  NSString *const CHANNEL_LOOP;
@property  NSString *const CHANNEL_LOOPPLAY;
@property  NSString *const CHANNEL_LOOPPOS;
@property  NSString *const CHANNEL_LOOPTYPE;
@property  NSString *const CHANNEL_LOOPSYNC;
@property  NSString *const CHANNEL_LOOPLEVEL;
@property  NSString *const CHANNEL_TEMPO;

  +(ChannelNames *) getInstance;

+ (NSString *)getCSDFile;

@end
