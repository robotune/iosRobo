//
//  InputBinding.m
//  RoboTune2
//
//  Created by Alan O'Sullivan on 21/10/2014.
//  Copyright (c) 2014 Alan O'Sullivan. All rights reserved.
//

#import "InputBinding.h"

@implementation InputBinding

@synthesize delegate;

- (void)setup:(CsoundObj *)csoundObj
{
    channelPtr = [csoundObj getOutputChannelPtr:self.channelName
                                   channelType:CSOUND_CONTROL_CHANNEL];
    //self.cacheDirty = true;
   
}

//no need for this
-(void)setValue:(float)value{}


/*- (void)receivedSyncValue:(float)value {
    
    //if([self delegate] != nil)
    //{
   
    //}
}*/


-(void)updateValuesFromCsound{
    cachedValue = *channelPtr;
    if(cachedValue!=syncChange)
    {
        //NSLog(@"cached sync from csound %f",cachedValue);
        //[self performSelectorOnMainThread:@selector(updateProgress) withObject:nil waitUntilDone:YES];
        //NSLog(@"Syncchannel %@ -- %f", self.channelName, cachedValue);
        
        //[self receivedSyncValue:cachedValue];
         [[self delegate] receivedSyncValue:cachedValue forChannel:self.channelName];
        syncChange = cachedValue;
        
    }
}

-(instancetype)init:(NSString *)channelName 
{
    if (self = [super init]) {
        self.channelName = channelName;
        cachedValue = 0.0f;
        syncChange = cachedValue;
        //self.delegate = instance;
        
    }
    return self;
}

-(void)cleanup {
    cachedValue = 0;
}


@end
