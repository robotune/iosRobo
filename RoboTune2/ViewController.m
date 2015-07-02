
//  ViewController.m
//  RoboTune2
//
//  Created by Alan O'Sullivan on 21/09/2014.
//  Copyright (c) 2014 Alan O'Sullivan. All rights reserved.
//

#import "ViewController.h"
//#import "UIViewController+ENPopUp.h"
#import "RNBlurModalView.h"
#import "UIBarButtonItem+WithImageOnly.h"
#import "ControlHelper.h"
//#import "ViewControllerEffects.h"
//#import "ViewControllerLoop.h"
#import "UIView+Toast.h"
#import "ChannelNames.h"

@interface ViewController ()
{
    
}

@end

@implementation ViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    screenHelper = [ScreenDimensionHelper getInstance];
    colors = [ColorSingleton getInstance];
    
    [self initButtons];
    
  
    [self initCsound];
    //[csound loadDefaults];
    
    buttonInfo = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Monochrome_robo_title.png"] target:self action:@selector(infoPressed:)];
    //buttonInfo.enabled = false;
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects: buttonEffects,buttonInfo, nil]; // Or for fancy @[ rightA, rightB ];
    
    //CsoundUI *csoundUI = [[CsoundUI alloc] initWithCsoundObj:csound.csound];
    
    //[csound.csound setupBindings];
    
    [self addTouchHandlersToControls];
    
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [self initCsound]; //need to reset the view on each controller when "back" navigate is popped

    if(csound.preset!=0)
    {
        DKCircleButton *button=(DKCircleButton *)[self.view viewWithTag:csound.preset];
        //[button sendActionsForControlEvents:UIControlEventTouchUpInside];
        [self setSelectedButton:button];
        
    }
    
}


-(void)initCsound
{
    // Do any additional setup after loading the view.
    csound = [CsoundSingleton getInstance];
     [csound setShowingView:self.view];
    
}

-(void)infoPressed:(UIBarButtonItem *)sender
{
   
        //robo!
}


- (void)addTouchHandlersToControls
{
    UILongPressGestureRecognizer *userPresetLongPress1 = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressPreset1:)];
        UILongPressGestureRecognizer *userPresetLongPress2 = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressPreset2:)];
        UILongPressGestureRecognizer *userPresetLongPress3 = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressPreset3:)];
    [buttonUser1 addGestureRecognizer:userPresetLongPress1];
    [buttonUser2 addGestureRecognizer:userPresetLongPress2];
    [buttonUser3 addGestureRecognizer:userPresetLongPress3];
    
    UISwipeGestureRecognizer *swipeLeft = [[UISwipeGestureRecognizer alloc]
                                           initWithTarget:self
                                           action:@selector(swipeLeft:)] ;
    [swipeLeft setDirection:UISwipeGestureRecognizerDirectionLeft];
    [[self view] addGestureRecognizer:swipeLeft];
    
    
    UISwipeGestureRecognizer *swipeRight = [[UISwipeGestureRecognizer alloc]
                                            initWithTarget:self
                                            action:@selector(swipeRight:)] ;
    [swipeRight setDirection:UISwipeGestureRecognizerDirectionRight];
    [[self view] addGestureRecognizer:swipeRight];
    
    //need to manually add record button and perform segue
    UIBarButtonItem *buttonizeButton = [[UIBarButtonItem alloc] initWithTitle:@"Loop/Record"
                                                                        style:UIBarButtonItemStyleDone
                                                                       target:self
                                                                       action:@selector(recordButtonTapped:)];
    self.navigationItem.leftBarButtonItems = @[buttonizeButton];
    

}


-(void)longPressPreset1:(UILongPressGestureRecognizer *)preset
{
    [self showPresetSaveDialog:preset];
}

-(void)longPressPreset2:(UILongPressGestureRecognizer *)preset
{
    [self showPresetSaveDialog:preset];
}

-(void)longPressPreset3:(UILongPressGestureRecognizer *)preset
{
    [self showPresetSaveDialog:preset];
}

-(void)showPresetSaveDialog:(UILongPressGestureRecognizer *)preset
{
    if(preset.state == UIGestureRecognizerStateBegan)
    {
        DKCircleButton *button = (DKCircleButton *)preset.view;
    
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Saving Preset" message:@"Enter Preset Name" delegate:self cancelButtonTitle:@"Save" otherButtonTitles:@"Cancel", nil];
        alert.alertViewStyle = UIAlertViewStylePlainTextInput;
        alert.tag = 800 + button.tag;
        
        UITextField *textField = [alert textFieldAtIndex:0];
        //textField.placeholder = [button titleLabel].text;
        textField.text = [button titleLabel].text;
        
        [alert show];
    }

}

//save preset
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
    if([title isEqualToString:@"Save"])
    {
        
        NSString *buttonName = [[alertView textFieldAtIndex:0] text];
        //NSLog(@"Entered: %@ -- tag = %d",buttonName, alertView.tag);
        
        NSInteger senderTag = alertView.tag - 800;
        
        DKCircleButton *button = (DKCircleButton *)[self.view viewWithTag:senderTag];
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        
        NSString *valuesKey = [NSString stringWithFormat:@"%ld", (long)alertView.tag];
        NSString *buttonKey = [NSString stringWithFormat:@"%ld", (long)button.tag];
        
        //NSLog(@"valuesKey: %@ -- buttonKey = %@",valuesKey, buttonKey);
        
        
        //save current preset values to defaults for key
        //NSArray *presetValues = [csound.channels allValues];
        [defaults setObject:csound.channels forKey:valuesKey];
        
        //save the entered button name
        NSMutableArray *uiValues=[[NSMutableArray alloc]initWithCapacity: 1];
        [uiValues addObject:buttonName];
        [defaults setObject:uiValues forKey:buttonKey];
        
        [defaults synchronize];
        
        [self initPresetButtonName:button defaults:defaults];

    }
    
    
  
}

- (void)swipeLeft:(UITapGestureRecognizer *)recognizer
{
    [self performSegueWithIdentifier:@"segueEffects" sender: self];
}

- (void)swipeRight:(UITapGestureRecognizer *)recognizer
{
    [self performSegueWithIdentifier:@"segueLoop" sender: self];
}

-(void)recordButtonTapped:(id)sender
{
    
    [self performSegueWithIdentifier:@"segueLoop" sender:self];
}



- (IBAction) buttonTouchUpInside:(id)sender {
    DKCircleButton *buttonSelected = (DKCircleButton *)sender;
    
    
    
    switch (buttonSelected.tag) {
        case 1: case 2: case 3: case 4: case 5: case 6: case 7: case 8:
            csound.preset = (int)buttonSelected.tag;
            [self initButtonColors];
            [self setSelectedButton:buttonSelected];
            
            break;
        case 9: case 10: case 11: case 12:
            [self showDialog:buttonSelected];
        default:
            break;
    }
    
    
    
    switch (buttonSelected.tag) {
        case 1: //BON
            [csound loadBon];
            break;
        case 2: //BON BUZZ
            [csound loadBonBuzz];
            break;
        case 3: //KAN
            [csound loadKan];
            break;
        case 4: //KAN BUZZ
            [csound loadKanBuzz];
            break;
        case 5: //CHIP
            [csound loadChip];
            break;
        case 6: //USER 1
        case 7: //USER 2
        case 8: //USER 3
            [csound loadUserPreset:buttonSelected.tag];
            break;
        default:
            break;
    }
    
    
    
    //[buttonSelected setBorderSize:5.0];
    
    //do as you please with buttonClicked.argOne
}

- (void)setSelectedButton:(DKCircleButton*)button
{
    button.selected = true;
    [button setBackgroundColor:colors.titleBarRed];
    [button setBorderColor:colors.white];
    [button setTitleColor:colors.white forState:UIControlStateSelected];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    
    
    if (cell == tableCellButtonBon) {
        //[tableCellButton1.superview bringSubviewToFront:sliderAttackCell];
        buttonBon.center = screenHelper.midButtonPoint;
        buttonBonBuzz.center = screenHelper.rightButtonPoint;
        [cell addSubview:buttonBon];
        [cell addSubview:buttonBonBuzz];
        buttonHelpBon.center = screenHelper.leftButtonPoint;
        [cell addSubview:buttonHelpBon];
        // [tableCellButtonBon.superview bringSubviewToFront:tableCellButtonBon];
        
    }
    
    if (cell == tableCellButtonKan) {
        //[tableCellButton1.superview bringSubviewToFront:sliderAttackCell];
        buttonKan.center = screenHelper.leftButtonPoint;
        buttonKanBuzz.center = screenHelper.midButtonPoint;
        [cell addSubview:buttonKan];
        [cell addSubview:buttonKanBuzz];
        
        buttonHelpKan.center = screenHelper.rightButtonPoint;
        [cell addSubview:buttonHelpKan];
        
        //     [tableCellButtonKan.superview bringSubviewToFront:tableCellButtonKan];
        
    }
    
    if (cell == tableCellButtonChip) {
        //[tableCellButton1.superview bringSubviewToFront:sliderAttackCell];
        buttonChip.center = screenHelper.midButtonPoint;
        buttonUser1.center = screenHelper.rightButtonPoint;
        [cell addSubview:buttonChip];
        [cell addSubview:buttonUser1];
        
        buttonHelpChip.center = screenHelper.leftButtonPoint;
        [cell addSubview:buttonHelpChip];
        
        [tableCellButtonChip.superview bringSubviewToFront:tableCellButtonChip];
        
        
    }
    
    if (cell == tableCellButtonUser) {
        //[tableCellButton1.superview bringSubviewToFront:sliderAttackCell];
        buttonUser2.center = screenHelper.leftButtonPoint;
        buttonUser3.center = screenHelper.midButtonPoint;
        [cell addSubview:buttonUser2];
        [cell addSubview:buttonUser3];
        
        buttonHelpUser.center = screenHelper.rightButtonPoint;
        [cell addSubview:buttonHelpUser];
        //[tableCellButtonUser.superview bringSubviewToFront:tableCellButtonUser];
        
    }
    
}


- (void)showDialog:(UIButton *)sender
{
    NSString *title = @"";
    NSString *message = @"";
    
    
    switch (sender.tag) {
        case 9:
            title = @"Bon Presets";
            message = @"Bon: Automatic harmonies adding a bright choir to your voice/source sound, with lots of delay \n\nBon Buzz: Like Bon, but adding a morphed Robo voice to your own, and changing the choir to a deeper, more powerful accompaniment. ";
            break;
        case 10:
            title = @"Kan Presets";
            message = @"No harmonies, just perfectly pitched output with some reverberation and delay.\n\nKan Buzz: Like Kan, but adding a morphed Robo voice to your own.";
            break;
        case 11:
            title = @"Chip Presets";
            message = @"A Chipmunk harmony voice higher than your own; try turning the 'formant' on/off in the 'harmony' effect section to see the difference between keeping your voice's tonal characteristics or not.";
            break;
        case 12:
            title = @"User Presets";
            message = @"User presets will save the current state of all effect settings. Long press on any user preset to save the current state";
            break;
        default:
            break;
    }
    
    RNBlurModalView *modal = [[RNBlurModalView alloc] initWithViewController:self
                                                                       title:title message:message fontSize:screenHelper.modalFontSize width:screenHelper.modalWidth];
    
    [modal show];
}

- (void)initButtons
{
    
    
    buttonBon = [ControlHelper getDKButton:@"BON" withTag:1 forSelector:@selector(buttonTouchUpInside:) owner:self radius:screenHelper.borderRadius fontSize:screenHelper.labelSize];
    
    buttonBonBuzz = [ControlHelper getDKButton:@"BON BUZZ" withTag:2 forSelector:@selector(buttonTouchUpInside:) owner:self radius:screenHelper.borderRadius fontSize:screenHelper.labelSize];
    buttonHelpBon = [ControlHelper getDKButton:@"INFO" withTag:9 forSelector:@selector(buttonTouchUpInside:) owner:self radius:screenHelper.borderRadius fontSize:screenHelper.labelSize];
    

    
    buttonBon.center = screenHelper.midButtonPoint;
    buttonBonBuzz.center = screenHelper.rightButtonPoint;
    buttonHelpBon.center = screenHelper.leftButtonPoint;

    [self.view setBackgroundColor:colors.white];
    
    [self.view addSubview:(buttonBon)];
    [self.view addSubview:(buttonBonBuzz)];
    [self.view addSubview:(buttonHelpBon)];
    
    buttonKan = [ControlHelper getDKButton:@"KAN" withTag:3 forSelector:@selector(buttonTouchUpInside:) owner:self radius:screenHelper.borderRadius fontSize:screenHelper.labelSize];
    buttonKanBuzz = [ControlHelper getDKButton:@"KAN BUZZ" withTag:4 forSelector:@selector(buttonTouchUpInside:) owner:self radius:screenHelper.borderRadius fontSize:screenHelper.labelSize];
     buttonHelpKan = [ControlHelper getDKButton:@"INFO" withTag:10 forSelector:@selector(buttonTouchUpInside:) owner:self radius:screenHelper.borderRadius fontSize:screenHelper.labelSize];
    
    CGPoint kanPos =  screenHelper.leftButtonPoint;
    kanPos.y  = kanPos.y +(screenHelper.buttonCellHeight *2);
    CGPoint kanBuzzPos =  screenHelper.midButtonPoint;
     kanBuzzPos.y  = kanBuzzPos.y + (screenHelper.buttonCellHeight *2);
    CGPoint kanHelpPos =  screenHelper.rightButtonPoint;
     kanHelpPos.y  = kanHelpPos.y + (screenHelper.buttonCellHeight *2);
    
    buttonKan.center =kanPos;
    buttonKanBuzz.center = kanBuzzPos;
    buttonHelpKan.center = kanHelpPos;

    
    [self.view addSubview:(buttonKan)];
    [self.view addSubview:(buttonKanBuzz)];
    [self.view addSubview:(buttonHelpKan)];

    
    buttonChip = [ControlHelper getDKButton:@"CHIP" withTag:5 forSelector:@selector(buttonTouchUpInside:) owner:self radius:screenHelper.borderRadius fontSize:screenHelper.labelSize];
    buttonUser1 = [ControlHelper getDKButton:@"EMPTY" withTag:6 forSelector:@selector(buttonTouchUpInside:) owner:self radius:screenHelper.borderRadius fontSize:screenHelper.labelSize] ;
    buttonHelpChip = [ControlHelper getDKButton:@"INFO" withTag:11 forSelector:@selector(buttonTouchUpInside:) owner:self radius:screenHelper.borderRadius fontSize:screenHelper.labelSize];
    
    CGPoint user1Pos =  screenHelper.rightButtonPoint;
    user1Pos.y  = user1Pos.y + (screenHelper.buttonCellHeight *4);
    CGPoint chipPos =  screenHelper.midButtonPoint;
    chipPos.y  = chipPos.y + (screenHelper.buttonCellHeight *4);
    CGPoint user1HelpPos =  screenHelper.leftButtonPoint;
    user1HelpPos.y  = user1HelpPos.y + (screenHelper.buttonCellHeight *4);
    
    buttonChip.center =chipPos;
    buttonUser1.center = user1Pos;
    buttonHelpChip.center = user1HelpPos;
    
    
    [self.view addSubview:(buttonChip)];
    [self.view addSubview:(buttonUser1)];
    [self.view addSubview:(buttonHelpChip)];
    
    
    buttonUser2 = [ControlHelper getDKButton:@"EMPTY" withTag:7 forSelector:@selector(buttonTouchUpInside:) owner:self radius:screenHelper.borderRadius fontSize:screenHelper.labelSize];
    buttonUser3 = [ControlHelper getDKButton:@"EMPTY" withTag:8 forSelector:@selector(buttonTouchUpInside:) owner:self radius:screenHelper.borderRadius fontSize:screenHelper.labelSize];
   
    buttonHelpUser = [ControlHelper getDKButton:@"INFO" withTag:12 forSelector:@selector(buttonTouchUpInside:) owner:self radius:screenHelper.borderRadius fontSize:screenHelper.labelSize];
    
    CGPoint user2Pos =  screenHelper.leftButtonPoint;
    user2Pos.y  = user2Pos.y + (screenHelper.buttonCellHeight *6);
    CGPoint user3Pos =  screenHelper.midButtonPoint;
    user3Pos.y  = user3Pos.y + (screenHelper.buttonCellHeight *6);
    CGPoint user3HelpPos =  screenHelper.rightButtonPoint;
    user3HelpPos.y  = user3HelpPos.y + (screenHelper.buttonCellHeight *6);
    
    buttonUser2.center =user2Pos;
    buttonUser3.center = user3Pos;
    buttonHelpUser.center = user3HelpPos;

    
    [self.view addSubview:(buttonUser2)];
    [self.view addSubview:(buttonUser3)];
    [self.view addSubview:(buttonHelpUser)];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    [self initPresetButtonName:buttonUser1 defaults:defaults];
    [self initPresetButtonName:buttonUser2 defaults:defaults];
    [self initPresetButtonName:buttonUser3 defaults:defaults];
    
    
    buttonHelpBon.animateTap = false;
    buttonHelpKan.animateTap = false;
    buttonHelpChip.animateTap = false;
    buttonHelpUser.animateTap = false;
    
    [self initButtonColors];
    
    
}

- (void)initPresetButtonName:(DKCircleButton *)presetButton defaults:(NSUserDefaults *)defaults
{
    NSString *key = [NSString stringWithFormat:@"%ld", (long)presetButton.tag];
    NSArray *user= [defaults arrayForKey:key];
    if(user.count >0)
    {
        NSString *buttonName =[user objectAtIndex:0];
        [presetButton setTitle:buttonName forState:UIControlStateNormal];
        [presetButton setTitle:buttonName forState:UIControlStateSelected];
    }
}

-(void)initButtonColors
{
    
    [buttonBon setBorderColor:colors.presetborder];
    [buttonBonBuzz setBorderColor:colors.presetborder];
    [buttonKan setBorderColor:colors.presetborder];
    [buttonKanBuzz setBorderColor:colors.presetborder];
    
    [buttonChip setBorderColor:colors.presetborder];
    [buttonUser1 setBorderColor:colors.presetborder];
    [buttonUser2 setBorderColor:colors.presetborder];
    [buttonUser3 setBorderColor:colors.presetborder];
    
    [buttonBon setTitleColor:colors.presettitle forState:UIControlStateNormal];
    [buttonBonBuzz setTitleColor:colors.presettitle forState:UIControlStateNormal];
    [buttonKan setTitleColor:colors.presettitle forState:UIControlStateNormal];
    [buttonKanBuzz setTitleColor:colors.presettitle forState:UIControlStateNormal];
    [buttonChip setTitleColor:colors.presettitle forState:UIControlStateNormal];
    [buttonUser1 setTitleColor:colors.presettitle forState:UIControlStateNormal];
    [buttonUser2 setTitleColor:colors.presettitle forState:UIControlStateNormal];
    [buttonUser3 setTitleColor:colors.presettitle forState:UIControlStateNormal];
    
    [buttonHelpBon setTitleColor:colors.greyinfo forState:UIControlStateNormal];
    [buttonHelpKan setTitleColor:colors.greyinfo forState:UIControlStateNormal];
    [buttonHelpChip setTitleColor:colors.greyinfo forState:UIControlStateNormal];
    [buttonHelpUser setTitleColor:colors.greyinfo forState:UIControlStateNormal];
    
    
    [buttonHelpBon setBorderColor:colors.greyinfo];
    [buttonHelpKan setBorderColor:colors.greyinfo];
    [buttonHelpChip setBorderColor:colors.greyinfo];
    [buttonHelpUser setBorderColor:colors.greyinfo];
    
    
    // [buttonInfo setTitleColor:colors.white forState:UIControlStateNormal];
    
    buttonBon.selected = false;
    buttonBonBuzz.selected = false;
    buttonKan.selected = false;
    buttonKanBuzz.selected = false;
    buttonChip.selected = false;
    buttonUser1.selected = false;
    buttonUser2.selected = false;
    buttonUser3.selected = false;
    
    
    [buttonHelpBon setBackgroundColor:colors.white];
    [buttonHelpKan setBackgroundColor:colors.white];
    [buttonHelpChip setBackgroundColor:colors.white];
    [buttonHelpUser setBackgroundColor:colors.white];
    
    
    /*[buttonBon setBackgroundColor:colors.ffcccc];
     [buttonBonBuzz setBackgroundColor:colors.ffcccc];
     [buttonKan setBackgroundColor:colors.ffcccc];
     [buttonKanBuzz setBackgroundColor:colors.ffcccc];
     [buttonChip setBackgroundColor:colors.cc9999];
     [buttonUser1 setBackgroundColor:colors.cc9999];
     [buttonUser2 setBackgroundColor:colors.cc9999];
     [buttonUser3 setBackgroundColor:colors.cc9999];
     */
    
    [buttonBon setBackgroundColor:colors.presetbg];
    [buttonBonBuzz setBackgroundColor:colors.presetbg];
    [buttonKan setBackgroundColor:colors.presetbg];
    [buttonKanBuzz setBackgroundColor:colors.presetbg];
    [buttonChip setBackgroundColor:colors.presetbg];
    [buttonUser1 setBackgroundColor:colors.presetbg];
    [buttonUser2 setBackgroundColor:colors.presetbg];
    [buttonUser3 setBackgroundColor:colors.presetbg];
    
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    //ViewControllerEffects *vc = (ViewControllerEffects *)[segue destinationViewController];
    
    
    if([segue.identifier isEqualToString:@"segueLoop"])
    {
        // vc.uiViewName = @"LoopView";
        
        //ViewControllerLoop *viewControllerLoop = (ViewControllerLoop *)[segue destinationViewController];
        //[viewControllerLoop initSliders];
        
        /*CATransition* transition = [CATransition animation];
        transition.duration = 0.75f;
        transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        transition.type = kCATransitionPush; //kCATransitionMoveIn; //, kCATransitionPush, kCATransitionReveal, kCATransitionFade
        transition.subtype = kCATransitionFromLeft; //kCATransitionFromLeft, kCATransitionFromRight, kCATransitionFromTop, kCATransitionFromBottom
        
        [vc.view.layer addAnimation:transition forKey:kCATransition];
         
         */
        
    }
    
    else
    {
       // vc.uiViewName = @"SelectEffectView";

    }
   
   
    /*[UIView animateWithDuration:0.75
                     animations:^{
                         [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
                         [self.navigationController pushViewController:[segue destinationViewController] animated:NO];
                         [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:self.navigationController.view cache:NO];
                     }];
    */
    // selectedEffect = (UIButton)sender.tag;
    
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    //ViewControllerEffects *viewControllerEffects = [segue destinationViewController];
    //viewControllerEffects.uiViewName = segue.identifier;
    
}


-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    //[csound.csound removeBinding:rateSlider];
    //[csound.csound removeBinding:durationSlider];
    //[csound.csound removeBindings];
    
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
