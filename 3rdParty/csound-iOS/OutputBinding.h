//
//  BaseCsoundBinding.h
//  RoboTune2
//
//  Created by Alan O'Sullivan on 21/09/2014.
//  Copyright (c) 2014 Alan O'Sullivan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CsoundObj.h"

@interface OutputBinding : NSObject<CsoundBinding>
{
    float *channelPtr;
    float channelValue;
    BOOL mCacheDirty;
}

@property (assign) BOOL cacheDirty;

@property (nonatomic, strong) NSString *channelName;

-(instancetype)initWithValue:(NSString *)channelName withDefaultValue:(float )channelValue;
-(void)setValue:(float)value;

@end
