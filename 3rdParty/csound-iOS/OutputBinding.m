//
//  BaseCsoundBinding.m
//  RoboTune2
//
//  Created by Alan O'Sullivan on 21/09/2014.
//  Copyright (c) 2014 Alan O'Sullivan. All rights reserved.
//

#import "OutputBinding.h"



@implementation OutputBinding


- (void)setup:(CsoundObj *)csoundObj
{
    channelPtr = [csoundObj getInputChannelPtr:self.channelName
                                   channelType:CSOUND_CONTROL_CHANNEL];
    self.cacheDirty = true;

    //*channelPtr = 0; //init
}

-(void)setValue:(float)value
{
    channelValue = value;
    self.cacheDirty = true;
   //NSLog(@"setValue: %@ -- %f" , self.channelName, channelValue);
}


-(void)updateValuesToCsound {
    if(self.cacheDirty)
    {
        *channelPtr = channelValue;
        //NSLog(@"updateValuesToCsound %f -- %@", *channelPtr, self.channelName);
        self.cacheDirty = false;
    }
    
}

-(instancetype)initWithValue:(NSString *)channelName withDefaultValue:(float )channelVal
{
    if (self = [super init])
    {
        self.channelName = channelName;
        channelValue = channelVal;
    }
    return self;
}


@end
