//
//  ViewControllerSelection.h
//  RoboTune2
//
//  Created by Alan O'Sullivan on 05/10/2014.
//  Copyright (c) 2014 Alan O'Sullivan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DKCircleButton.h"
#import "CsoundSingleton.h"
#import "CsoundUI.h"
#import "ScreenDimensionHelper.h"

@interface ViewControllerSelection : UIViewController<UIGestureRecognizerDelegate>
{
    IBOutlet UIButton *buttonSource;
    IBOutlet UIButton *buttonReverb;
    IBOutlet UIButton *buttonDelay;
    IBOutlet UIButton *buttonHarmony;
    IBOutlet UIButton *buttonScale;
    
    IBOutlet UIButton *buttonHelp;
    
    CsoundSingleton *csound;
    ScreenDimensionHelper *screenHelper;

    NSString* csdFile;
    
    IBOutlet UIBarButtonItem *buttonInfo;
    IBOutlet UIBarButtonItem *buttonEffects;

}

@property (nonatomic, strong) NSString  *uiViewName;

@end
