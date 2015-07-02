//
//  ViewController.h
//  RoboTune2
//
//  Created by Alan O'Sullivan on 21/09/2014.
//  Copyright (c) 2014 Alan O'Sullivan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CsoundSingleton.h"
#import "CsoundUI.h"
#import "DKCircleButton.h"
#import "ColorSingleton.h"
#import "ScreenDimensionHelper.h"

@interface ViewController : UIViewController<UIGestureRecognizerDelegate>
{
    ColorSingleton *colors;
     ScreenDimensionHelper *screenHelper;
    CsoundSingleton *csound;
    NSString* csdFile;
    
    DKCircleButton *buttonBon;
    DKCircleButton *buttonBonBuzz;
    DKCircleButton *buttonKan;
    DKCircleButton *buttonKanBuzz;
    DKCircleButton *buttonChip;
    DKCircleButton *buttonUser1;
    DKCircleButton *buttonUser2;
    DKCircleButton *buttonUser3;
    
    DKCircleButton *buttonHelpBon;
    DKCircleButton *buttonHelpKan;
    DKCircleButton *buttonHelpChip;
    DKCircleButton *buttonHelpUser;
    
    
    
    
    IBOutlet UIBarButtonItem *buttonInfo;
    IBOutlet UIBarButtonItem *buttonEffects;

    

    IBOutlet UITableViewCell *tableCellButtonBon;
    IBOutlet UITableViewCell *tableCellButtonKan;
    IBOutlet UITableViewCell *tableCellButtonChip;
    IBOutlet UITableViewCell *tableCellButtonUser;
    
}


@end
