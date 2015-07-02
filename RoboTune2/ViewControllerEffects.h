//
//  ViewController2.h
//  RoboTune2
//
//  Created by Alan O'Sullivan on 21/09/2014.
//  Copyright (c) 2014 Alan O'Sullivan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CsoundSingleton.h"
#import "CsoundObj.h"
#import "CsoundUI.h"
#import "ASValueTrackingSlider.h"
#import "DKCircleButton.h"
#import "ColorSingleton.h"
#import "ScreenDimensionHelper.h"
#import "UAProgressView.h"
#import <MediaPlayer/MediaPlayer.h>
@import AVFoundation;

@interface ViewControllerEffects: UITableViewController<AVAudioPlayerDelegate,UIGestureRecognizerDelegate>
{
    
    ColorSingleton *colors;
    ScreenDimensionHelper *screenHelper;
    
    IBOutlet UIBarButtonItem *buttonInfo;
    IBOutlet UIBarButtonItem *buttonEffects;

    
    IBOutlet UITableViewCell *tableCellSourceSlider;
    IBOutlet UITableViewCell *tableCellGateSlider;
    
    IBOutlet UITableViewCell *tableCellReverbSlider;
    
    IBOutlet UITableViewCell *tableCellHarmony1;
    IBOutlet UITableViewCell *tableCellHarmony2;
    IBOutlet UITableViewCell *tableCellHarmony3;
    
    IBOutlet UITableViewCell *tableCellKeySlider;
    IBOutlet UITableViewCell *tableCellDelayInterval;
    IBOutlet UITableViewCell *tableCellDelayFdb;

    IBOutlet UITableViewCell *tableCellRecord;
    IBOutlet UITableViewCell *tableCellLoopLevel;
    IBOutlet UITableViewCell *tableCellLoopRecord;
    
   // IBOutlet UIProgressView *progressLoop;
   // IBOutlet UIProgressView *progressRecordPlay;
    
    Boolean isRecordingTrack;
    Boolean isPlayingTrack;
    
    Boolean isLoopPlayPaused;
    Boolean isLoopRecordPaused;
    //float recordProgress;
    //float playProgress;
    IBOutlet UILabel *labelLoopRecord;
    IBOutlet UILabel *labelLoopPlay;
    
    
    AVAudioPlayer *mPlayer;

    
    NSTimer *timerLoopPlay;
    NSTimer *timerLoopRecord;
    
     IBOutlet UIImageView *glowRecordLoopImage;
     IBOutlet UIImageView *glowRecordImage;
    
    IBOutlet ASValueTrackingSlider *sliderLoopLevel;

    
    IBOutlet UAProgressView *progressViewLoopRecord;
    IBOutlet UAProgressView *progressViewLoopPlay;
    
    double playTime;
    double recordTime;
    NSTimer *timerRecord;
    NSTimer *timerPlay;
    
    IBOutlet DKCircleButton *buttonRecord;
    IBOutlet DKCircleButton *buttonRecordPlay;

    
    IBOutlet ASValueTrackingSlider *sliderSource;
    IBOutlet ASValueTrackingSlider *sliderMainLevel;
    
    IBOutlet ASValueTrackingSlider *sliderHarm1Level;
    IBOutlet ASValueTrackingSlider *sliderHarm1Value;
    IBOutlet ASValueTrackingSlider *sliderHarm2Level;
    IBOutlet ASValueTrackingSlider *sliderHarm2Value;
    IBOutlet ASValueTrackingSlider *sliderHarm3Level;
    IBOutlet ASValueTrackingSlider *sliderHarm3Value;
    
   // IBOutlet UISwitch *switchReverb;
    IBOutlet UISegmentedControl *segmentReverb;

    IBOutlet ASValueTrackingSlider *sliderReverb;
    IBOutlet ASValueTrackingSlider *sliderReverbTone;
    
    IBOutlet UISwitch *switchFormant;
    
    IBOutlet UILabel *lableHarmValue1;
    
    IBOutlet UIButton *buttonHarmonyInfo;
    
    IBOutlet UISegmentedControl *segmentSource;
    IBOutlet UISegmentedControl *segmentAutoHarm;
    IBOutlet UISegmentedControl *segmentScale;
    IBOutlet UISegmentedControl *segmentLoopType;
    
    IBOutlet UISwitch *switchGate;
    IBOutlet ASValueTrackingSlider *sliderGate;
    
   // IBOutlet UISwitch *switchDelay;
    IBOutlet UISegmentedControl *segmentDelay;

    
    
    IBOutlet ASValueTrackingSlider *sliderDelayInterval;
    IBOutlet ASValueTrackingSlider *sliderDelayFdb;
    
    IBOutlet ASValueTrackingSlider *sliderKey;
    
     CsoundSingleton *csound;
     NSString* csdFile;
    
    
    IBOutlet UITableView *viewSource;
    IBOutlet UITableView *viewReverb;
    IBOutlet UITableView *viewDelay;
    IBOutlet UITableView *viewHarmony;
    
    
    
}

@property (nonatomic, strong) NSString  *uiViewName;

//@property (nonatomic, assign) BOOL isPlayPaused;
//@property (nonatomic, assign) BOOL isReordPaused;


@end
