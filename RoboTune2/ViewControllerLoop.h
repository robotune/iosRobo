//
//  ViewControllerLoop.h
//  RoboTune2
//
//  Created by Alan O'Sullivan on 02/12/2014.
//  Copyright (c) 2014 Alan O'Sullivan. All rights reserved.
//

#import <UIKit/UIKit.h>
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


@interface ViewControllerLoop : UITableViewController<AVAudioPlayerDelegate, UIGestureRecognizerDelegate>
{
    ColorSingleton *colors;
    ScreenDimensionHelper *screenHelper;
    
    IBOutlet UIBarButtonItem *buttonInfo;
    
    IBOutlet UITableViewCell *tableCellRecord;
    IBOutlet UITableViewCell *tableCellLoopLevel;
    IBOutlet UITableViewCell *tableCellLoopRecord;

   
    //float recordProgress;
    //float playProgress;
    IBOutlet UILabel *labelLoopRecord;
    IBOutlet UILabel *labelLoopPlay;
    
    
    
    
    IBOutlet UIImageView *glowRecordLoopImage;
    IBOutlet UIImageView *glowRecordImage;
    
    IBOutlet ASValueTrackingSlider *sliderLoopLevel;
    
     IBOutlet UISegmentedControl *segmentLoopType;
    
    IBOutlet UAProgressView *progressViewLoopRecord;
    IBOutlet UAProgressView *progressViewLoopPlay;
    
    // AVAudioPlayer *mPlayer;
    
    IBOutlet DKCircleButton *buttonRecord;
    IBOutlet DKCircleButton *buttonRecordPlay;
    
    
    CsoundSingleton *csound;
    NSString* csdFile;
}

-(void)initSliders;
-(void)initRecordCurrentState;

@end
