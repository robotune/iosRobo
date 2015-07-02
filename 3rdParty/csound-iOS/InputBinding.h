//
//  InputBinding.h
//  RoboTune2
//
//  Created by Alan O'Sullivan on 21/10/2014.
//  Copyright (c) 2014 Alan O'Sullivan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CsoundObj.h"
#import "SyncDelegate.h"

@interface InputBinding : NSObject<CsoundBinding>
{
    BOOL mCacheDirty;
    float cachedValue;
    float* channelPtr;
    NSString* mChannelName;
    float syncChange;
}

@property (nonatomic, unsafe_unretained) id<SyncDelegate> delegate;

//- (void)receivedSyncValue:(float)value;


@property (assign) BOOL cacheDirty;

@property (nonatomic, strong) NSString *channelName;

-(instancetype)init:(NSString *)channelName;

//-(void)receivedSyncValue:(float)value;

@end
