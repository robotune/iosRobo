//
//  CsoundSingleton.h
//  RoboTune2
//
//  Created by Alan O'Sullivan on 21/09/2014.
//  Copyright (c) 2014 Alan O'Sullivan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CsoundObj.h"
#import "ChannelNames.h"
#import "SyncDelegate.h"
#import "InputBinding.h"
//#import "OutputBinding.h"
@import AVFoundation;

@interface CsoundSingleton : NSObject<CsoundObjListener>

    @property (nonatomic, strong) CsoundObj *csound;
    //@property (nonatomic, strong) CsoundUI *csoundUI;
    @property (nonatomic, strong) NSString* csdFile;
    @property (nonatomic) Boolean isRunning;

    @property (nonatomic) int preset;

    @property NSDictionary * channels;

    @property (nonatomic) float channel_source;
    @property (nonatomic) float channel_cross;
    @property (nonatomic) float channel_gateswitch;
    @property (nonatomic) float channel_gate;


    @property (nonatomic) float channel_appreverb;
    @property (nonatomic) float channel_reverblevel;
    @property (nonatomic) float channel_reverbtone;

    @property (nonatomic) float channel_appdelay;
    @property (nonatomic) float channel_fdb;
    @property (nonatomic) float channel_delayinterval;

    @property (nonatomic) float channel_autorobo;
    @property (nonatomic) float channel_harm1;
    @property (nonatomic) float channel_harmlevel1;
    @property (nonatomic) float channel_harm2;
    @property (nonatomic) float channel_harmlevel2;
    @property (nonatomic) float channel_harm3;
    @property (nonatomic) float channel_harmlevel3;

    @property (nonatomic) float channel_harm1form;

    @property (nonatomic) float channel_mainlevel;

    @property (nonatomic) float channel_scale;
    @property (nonatomic) float channel_click;

    @property (nonatomic) float channel_key;

    @property (nonatomic) Boolean isLoopStored;

    @property (nonatomic) float channel_loop;
    @property (nonatomic) float channel_loopplay;
    @property (nonatomic) float channel_loopPos;
    @property (nonatomic) float channel_looptype;
    @property (nonatomic) float channel_loopsync;
    @property (nonatomic) float channel_looplevel;

    @property (nonatomic) float channel_tempo;

    @property Boolean isRecordingTrack;
    @property Boolean isPlayingTrack;
    @property Boolean isTrackStored;

    @property Boolean isLoopPlayPaused;
    @property Boolean isLoopRecordPaused;

    @property NSTimer *timerLoopPlay;
    @property NSTimer *timerLoopRecord;

    @property NSTimer *timerRecord;
    @property NSTimer *timerPlay;

    @property double playTime;
    @property double recordTime;

    @property AVAudioPlayer *mPlayer;


    @property (nonatomic) InputBinding *bindingLoopPos;
    @property (nonatomic) InputBinding *bindingLoopSync;

    @property (nonatomic, strong) ChannelNames *channelNames;

    @property (nonatomic, strong) UIView *currentView;

   +(CsoundSingleton *) getInstance;

   @property (nonatomic, unsafe_unretained) id<SyncDelegate> delegate;

- (void)receivedSyncValue:(float)value forChannel:(NSString *)channelName;
- (void)stopCsound;
- (void)startAndDetermineHeadphones;
-(void)loadDefaults;

-(void)setShowingView:(UIView *)currentView;

-(void)overwriteCsoundChannels;

-(void)setCsoundChannelValue:(NSString *)channel value:(NSNumber *)value;
-(void)updateCsoundChannel:(NSString  *)channelName;

-(void)loadBon;
-(void)loadBonBuzz;
-(void)loadKan;
-(void)loadKanBuzz;
-(void)loadChip;
-(void)loadUserPreset:(NSInteger)userPreset;


@end
