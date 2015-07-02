//
//  SyncDelegate.h
//  RoboTune2
//
//  Created by Alan O'Sullivan on 21/10/2014.
//  Copyright (c) 2014 Alan O'Sullivan. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SyncDelegate <NSObject>

@required

-(void)receivedSyncValue:(float)value forChannel:(NSString *)channelName ;

@end
