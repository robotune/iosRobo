//
//  ViewControllerLoop.m
//  RoboTune2
//
//  Created by Alan O'Sullivan on 02/12/2014.
//  Copyright (c) 2014 Alan O'Sullivan. All rights reserved.
//


#import "ViewControllerLoop.h"
#import "RNBlurModalView.h"
#import "ColorSingleton.h"
#import "ControlHelper.h"
#import "UIView+Glow.h"
#import "ViewController.h"
#import "UIBarButtonItem+WithImageOnly.h"

@implementation ViewControllerLoop

//synthesize uiViewName;

static NSString *stop = @"stop";
static NSString *play = @"play";
static NSString *record = @"record";
static NSString *recordLengthKey = @"robo_record_len";

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self configureToolBar];
    
    [self addSwipeHandlers];
    
    screenHelper = [ScreenDimensionHelper getInstance];
    
    colors = [ColorSingleton getInstance];
    
    [self initCsound];
    
    [self initControlsFromCsound];
    
    [self initProgressViews];
    
    [self initRecordButtons];
    
    [self initProgressCurrentState];
    
    [self initRecordCurrentState];

        
   [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector(handleEnteredBackground:)
                                                 name: UIApplicationDidEnterBackgroundNotification
                                               object: nil];
   


}
//to avoid loop noise issue coming out of background
-(void)handleEnteredBackground:(UIApplication *)application
{
    csound.channel_loop = 0;
    csound.channel_loopplay = 0;
    csound.isLoopStored = false;
    [csound updateCsoundChannel:csound.channelNames.CHANNEL_LOOP];
    [csound updateCsoundChannel:csound.channelNames.CHANNEL_LOOPPLAY];

    if(!csound.isLoopPlayPaused)
    {
        [self stopLoopPlay];
        
    }
    if(!csound.isLoopRecordPaused)
    {
        [self stopLoopRecord];
    }
    
   
    [self disableLoopPlayButton];
    [self enableLoopRecordButton];
   
}



-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self initCsound]; //need to reset the view on each controller when "back" navigate is popped
  
    [self initSliders];
    
    
}


-(void)initCsound
{
    // Do any additional setup after loading the view.
    csound = [CsoundSingleton getInstance];
    [csound setShowingView:self.view];//TODO BAD DESIGN
    
}

- (void)initControlsFromCsound
{
    sliderLoopLevel.value = csound.channel_looplevel;
    [segmentLoopType setSelectedSegmentIndex:csound.channel_looptype];
    
}

-(void)initProgressCurrentState
{
    if(!csound.isLoopPlayPaused)
    {
        [self toggleProgress:csound.isLoopPlayPaused withTime:csound.timerLoopPlay];
        [self startLoopPlay];
    }
    if(!csound.isLoopRecordPaused)
    {
        [self toggleProgress:csound.isLoopRecordPaused withTime:csound.timerLoopRecord];
        [self startLoopRecord];
    }
    
}


-(void)initRecordCurrentState
{
    if(csound.isRecordingTrack)
    {
        [self startRecording];
        [buttonRecord setSelected:true];
        [buttonRecordPlay setSelected:false];
    }
    if(csound.isPlayingTrack)
    {
        [self startPlaying];
        [buttonRecordPlay setSelected:true];
        [buttonRecord setSelected:false];
    }
}

-(void)configureToolBar
{
    [self.navigationItem setHidesBackButton:YES animated:YES];
    
    UIBarButtonItem *buttonizeButton = [[UIBarButtonItem alloc] initWithTitle:@"Presets"
                                                                        style:UIBarButtonItemStyleDone
                                                                       target:self
                                                                       action:@selector(backButtonTapped:)];
    
    self.navigationItem.rightBarButtonItems = @[buttonizeButton];
    self.navigationItem.leftBarButtonItem = buttonInfo;
}

- (void)addSwipeHandlers
{
    // Disable iOS 7 back gesture
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
        self.navigationController.interactivePopGestureRecognizer.delegate = self;
    }
    UISwipeGestureRecognizerDirection dir;
    dir = UISwipeGestureRecognizerDirectionLeft;
    
    UISwipeGestureRecognizer *swipeLeft = [[UISwipeGestureRecognizer alloc]
                                           initWithTarget:self
                                           action:@selector(swipeLeft:)] ;
    [swipeLeft setDirection:dir];
    [[self view] addGestureRecognizer:swipeLeft];
    
    
}

- (void)swipeLeft:(UITapGestureRecognizer *)recognizer
{
   
   [self performSegueWithIdentifier:@"seguePresets" sender: self];
    
}

-(void)infoPressed:(UIBarButtonItem *)sender
{
    
    //robo!
}

-(void)backButtonTapped:(id)sender{
    [self performSegueWithIdentifier:@"seguePresets" sender:sender];
}

-(void)initSliders
{
    sliderLoopLevel.name = csound.channelNames.CHANNEL_LOOPLEVEL;
     UILabel *label = [ControlHelper getSliderLabel:sliderLoopLevel withTag:sliderLoopLevel.tag+500];
    label.text = [NSString stringWithFormat:@"%.2f", sliderLoopLevel.value];
}



//TODO REFACTOR SOME OF THESE COMMON BETWEEN EFFECTS AND LOOP

//only update label text on end of drag
- (IBAction)sliderValueDidEndSliding:(UISlider *)sender {
    
    //still using tags. need better system - TODO add to value slider
    NSString *sliderValueFormat = @"%.2f";
    
    UILabel *label = [ControlHelper getSliderLabel:sender withTag:sender.tag+500];
    label.text = [NSString stringWithFormat:sliderValueFormat, sender.value];
    
}


- (IBAction)sliderValueChanged:(ASValueTrackingSlider *)sender {
    
    NSNumber * channelSliderValue = [NSNumber numberWithFloat:sender.value];
    
    [csound setCsoundChannelValue:sender.name value:channelSliderValue];
    
    UILabel *label = [ControlHelper getSliderLabel:sender withTag:sender.tag+500];
    label.text = @"";
    
}



- (IBAction)segmentChanged:(UISegmentedControl  *)sender
{
    csound.channel_looptype = sender.selectedSegmentIndex;
    [csound updateCsoundChannel:csound.channelNames.CHANNEL_LOOPTYPE];
}

- (void)initProgressViews
{
    __weak typeof(self) weakSelf = self;
    
    progressViewLoopRecord.didSelectBlock = ^(UAProgressView *progressView){
        //AudioServicesPlaySystemSound(_horn);
        //csound.isLoopRecordPaused = !csound.isLoopRecordPaused;
        [weakSelf handleLoopRecordChanged];
    };
    
    progressViewLoopRecord.borderWidth = 3.0;
    progressViewLoopRecord.lineWidth = 4.0;
    progressViewLoopRecord.tintColor = colors.recordRedBorder;
    progressViewLoopRecord.progress = 0;
    
    progressViewLoopPlay.borderWidth = 3.0;
    progressViewLoopPlay.lineWidth = 4.0;
    
    progressViewLoopPlay.didSelectBlock = ^(UAProgressView *progressView){
        //AudioServicesPlaySystemSound(_horn);
        //csound.isLoopPlayPaused = !csound.isLoopPlayPaused;
        [weakSelf handleLoopPlayChanged];
    };
    
    if(!csound.isLoopStored)
    {
        [self disableLoopPlayButton];
        progressViewLoopPlay.progress = 0;
    }
    else
    {
        [self enableLoopPlayButton];
    }
    
}


-(void)handleLoopRecordChanged
{
    csound.isLoopRecordPaused = !csound.isLoopRecordPaused;
    
    if(csound.isLoopRecordPaused)
    {
        [self stopLoopRecord];
    }
    else
    {
        [self startLoopRecord];
        
    }
    
}

-(void)handleLoopPlayChanged
{
    csound.isLoopPlayPaused = !csound.isLoopPlayPaused;
    
    if(csound.isLoopPlayPaused)
    {
        [self stopLoopPlay];
    }
    else
    {
        [self startLoopPlay];
        
    }
}

- (void)handleLoopChanged:(NSTimer *)timer forLoop:(NSInteger)loop
{
    
    switch (loop) {
        case 0: //record
            
            csound.isLoopRecordPaused = !csound.isLoopRecordPaused;
            csound.channel_loop = csound.isLoopRecordPaused+1;
            [self toggleProgress:csound.isLoopRecordPaused withTime:timer];
            
            break;
        case 1: //play
            
            csound.isLoopPlayPaused = !csound.isLoopPlayPaused;
            csound.channel_loopplay = csound.isLoopPlayPaused;
            [self toggleProgress:csound.isLoopPlayPaused withTime:timer];
            
            break;
        default:
            break;
    }
    
    
    
}

- (void)toggleProgress:(Boolean)isPaused withTime:(NSTimer *)timer
{
    switch (isPaused) {
        case 0: //start
            timer = [NSTimer scheduledTimerWithTimeInterval:0.05 target:self selector:@selector(updateProgress:) userInfo:nil repeats:YES];
            break;
        case 1: //pause
            [timer invalidate];
            timer = nil;
            break;
        default:
            break;
    }
    
}

-(void)updateProgress:(NSTimer *)timer
{
    if(!csound.isLoopPlayPaused)
    {
        [progressViewLoopPlay setProgress:csound.channel_loopPos];
    }
    
    else if(!csound.isLoopRecordPaused)
    {
        [progressViewLoopRecord setProgress:csound.channel_loopPos];
        if(csound.channel_loopsync  ==1)
        {
            [self stopLoopRecord];
        }
        
    }
    
}
-(void)startLoopRecord
{
    segmentLoopType.enabled = false;
    
    [glowRecordLoopImage startGlowingWithColor:colors.recordRedBorder intensity:0.6];
    
    csound.channel_loop = 1;
    [csound updateCsoundChannel:csound.channelNames.CHANNEL_LOOP];
   
    [self disableLoopPlayButton];
    
    [labelLoopRecord setText:stop];
    
    //we are returning while recording need to invalidate the old timer
    if(!csound.isLoopRecordPaused)
    {
        [csound.timerLoopRecord invalidate];
        csound.timerLoopRecord = nil;
        
    }
    
    csound.timerLoopRecord =  [NSTimer scheduledTimerWithTimeInterval:0.05 target:self selector:@selector(updateProgress:) userInfo:nil repeats:YES];
    
    //recordProgress = ((int)((recordProgress * 100.0f) + 1.01) % 100) / 100.0f;
    
}

-(void)stopLoopRecord
{
    segmentLoopType.enabled = true;
    
    [glowRecordLoopImage stopGlowing];
    
    [ csound.timerLoopRecord invalidate];
     csound.timerLoopRecord = nil;
    [self enableLoopPlayButton];
    [labelLoopRecord setText:record];
    csound.channel_loopsync = 0;
    csound.channel_loop = 2;
    [progressViewLoopRecord setProgress:0];
    [csound updateCsoundChannel:csound.channelNames.CHANNEL_LOOP];
    csound.isLoopStored = YES;
    csound.isLoopRecordPaused = YES;
    
}

-(void)startLoopPlay
{
    segmentLoopType.enabled = false;
    
    [glowRecordLoopImage startGlowingWithColor:colors.playGreenBorder intensity:0.6];
    
    csound.channel_loopplay = 1;
    [csound updateCsoundChannel:csound.channelNames.CHANNEL_LOOPPLAY];
    [self disableLoopRecordButton];
    
    [labelLoopPlay setText:stop];
     csound.timerLoopPlay =  [NSTimer scheduledTimerWithTimeInterval:0.05 target:self selector:@selector(updateProgress:) userInfo:nil repeats:YES];
    
    
    //playProgress = csound.channel_loopPos;//((int)((playProgress * 100.0f) + 1.01) % 100) / 100.0f;
    //[progressViewLoopPlay setProgress:csound.channel_loopPos];
}

-(void)stopLoopPlay
{
    [glowRecordLoopImage stopGlowing];
    
    segmentLoopType.enabled = true;
    
    [progressViewLoopPlay setProgress:0];
    
    csound.channel_loopplay = 0;
    [csound updateCsoundChannel:csound.channelNames.CHANNEL_LOOPPLAY];
    [ csound.timerLoopPlay invalidate];
     csound.timerLoopPlay = nil;
    [self enableLoopRecordButton];
    [labelLoopPlay setText:play];
    csound.isLoopPlayPaused = YES;
    
}


-(void)disableLoopRecordButton
{
    [progressViewLoopRecord setUserInteractionEnabled:false];
    progressViewLoopRecord.tintColor = colors.disabled;
    [labelLoopRecord setTextColor:colors.disabled];
}

-(void)enableLoopRecordButton
{
    [progressViewLoopRecord setUserInteractionEnabled:true];
    progressViewLoopRecord.tintColor = colors.recordRedBorder;
    [labelLoopRecord setTextColor:colors.black];}

-(void)enableLoopPlayButton
{
    [progressViewLoopPlay setUserInteractionEnabled:true];
    progressViewLoopPlay.tintColor = colors.playGreenBorder;
    [labelLoopPlay setTextColor:colors.black];
}

-(void)disableLoopPlayButton
{
    [progressViewLoopPlay setUserInteractionEnabled:false];
    progressViewLoopPlay.tintColor = colors.disabled;
    [labelLoopPlay setTextColor:colors.disabled];
}

- (void)initRecordButtons
{
    buttonRecord = [ControlHelper getDKButton:record withTag:601 forSelector:@selector(buttonRecordTouchUpInside:) owner:self radius:screenHelper.borderRadius fontSize:screenHelper.labelSize];
    buttonRecordPlay = [ControlHelper getDKButton:play withTag:602 forSelector:@selector(buttonRecordTouchUpInside:) owner:self radius:screenHelper.borderRadius fontSize:screenHelper.labelSize];
    
    
    if(!csound.isRecordingTrack && !csound.isPlayingTrack)
    {
    
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSArray *presets= [defaults arrayForKey:recordLengthKey];
    
        if(presets.count >0)
        {
            NSString *recordLen =[presets objectAtIndex:0];
            csound.recordTime = [recordLen floatValue];
            csound.isTrackStored = true;
            [self enableRecordButton:buttonRecordPlay enabledColor:colors.playGreenBorder];
        
        }
        else
        {
        
            csound.recordTime = 0;
            [buttonRecordPlay setBorderColor:colors.disabled];
            
        }
    }
    
    if(!csound.isPlayingTrack)
    {
        csound.playTime= 0;
    }
    else
    {
       
    }
    
    [buttonRecordPlay setTitleColor:colors.black forState:UIControlStateNormal];
    [buttonRecordPlay setTitle:play forState:UIControlStateNormal];
    [buttonRecordPlay setTitle:stop forState:UIControlStateSelected];
    [buttonRecordPlay setTitleColor:colors.disabled forState:UIControlStateDisabled];
    [buttonRecordPlay setBackgroundColor:colors.white];
    
    [buttonRecord setBorderColor:colors.recordRedBorder];
    
    [buttonRecord setBackgroundColor:colors.white];
    
    [buttonRecord setTitleColor:colors.black forState:UIControlStateNormal];
    [buttonRecord setTitle:record forState:UIControlStateNormal];
    [buttonRecord setTitle:stop forState:UIControlStateSelected];
 
    
}

// for all sliders in table cells - bring to the front
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UIView *cellContent = [cell contentView];
    NSArray *cellControls = [cellContent subviews];
    
    //slider cells need to be brought to front to show popup over other cells
    for(id cellControl in cellControls)
    {
        if([cellControl isKindOfClass:[UISlider class]])
        {
            [cell.superview bringSubviewToFront:cell];
        }
    }
    
    if(cell == tableCellRecord)
    {
        
        buttonRecord.center = screenHelper.leftRecordButtonPoint;
        buttonRecordPlay.center = screenHelper.rightRecordButtonPoint;
        [cell addSubview:buttonRecord];
        [cell addSubview:buttonRecordPlay];
        
    }
}

- (IBAction) buttonRecordTouchUpInside:(id)sender {
    DKCircleButton *button = (DKCircleButton *)sender;
    
    //button.selected = !button.selected;
    //NSLog(@"button record clicked: %hhd", button.selected);

    switch (button.tag) {
        case 601: //record
            [self toggleRecord];
            break;
        case 602: //play
            [self togglePlay];
            break;
        default:
            break;
    }
    
    [csound overwriteCsoundChannels]; //updates loop
    
}



- (NSURL *)recordingURL
{
    NSURL *localDocDirURL = nil;
    if (localDocDirURL == nil) {
        NSString *docDirPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)
                                objectAtIndex:0];
        localDocDirURL = [NSURL fileURLWithPath:docDirPath];
        //NSLog(@" localDocDirURL path: %@  --- doc dir path: %@", localDocDirURL, docDirPath);
    }
    return [localDocDirURL URLByAppendingPathComponent:@"recording.wav"];
}

- (void)recordTimerFired:(NSTimer *)timer {
    
    if(csound.isRecordingTrack)
    {
        // NSNumber *previousTime = timer.userInfo;
        csound.recordTime += 0.1; //not too accurate but....
        //NSLog(@"record timer : has gone off: %f", csound.recordTime);
    }
    else{
        [timer invalidate];
        timer = nil;
    }
    
}

- (void)toggleRecord
{
    if(csound.isRecordingTrack)
    {
        [self stopRecording];
    }
    else
    {
        [self startRecording];
    }
}

-(void)startRecording
{
    [buttonRecord setTitle:stop forState:UIControlStateNormal];
    [buttonRecord setTitle:stop forState:UIControlStateSelected];
    [buttonRecord setBorderColor:colors.recordRedBorder];
    [glowRecordImage startGlowingWithColor:colors.recordRedBorder intensity:0.6];
    [self disableRecordButton:buttonRecordPlay];
    
    //this will already be actually recording when coming back to the view if pressed
    if(!csound.isRecordingTrack)
    {
        csound.recordTime = 0; //reset
        [csound.csound  recordToURL:[self recordingURL]];
       
    }
    
    //NSLog(@"kicking of record timer %f", csound.recordTime);
    
    csound.timerRecord = [NSTimer scheduledTimerWithTimeInterval:0.1
                                                          target:self
                                                        selector:@selector(recordTimerFired:)
                                                        userInfo:nil//[NSNumber numberWithFloat:csound.recordTime]
                                                         repeats:true];
    
    
       csound.isRecordingTrack = true;

}

- (void)stopRecording
{
    [buttonRecord setTitle:record forState:UIControlStateNormal];
    [buttonRecord setTitle:record forState:UIControlStateSelected];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSMutableArray *uiValues=[[NSMutableArray alloc]initWithCapacity: 1];
    NSString *value = [NSString stringWithFormat:@"%f", csound.recordTime];
    [uiValues addObject:value];
    [defaults setObject:uiValues forKey:recordLengthKey];
    [defaults synchronize]; // this method is optional
    
    csound.isRecordingTrack = false;
    [csound.csound stopRecording];
    [self enableRecordButton:buttonRecordPlay enabledColor:colors.playGreenBorder];
    [csound.timerRecord invalidate];
    csound.timerRecord = nil;
    csound.isTrackStored = true;
}

- (void)togglePlay
{
    if(csound.isPlayingTrack)
    {
        [self stopPlayingTrack];
    }
    else
    {
        [self startPlaying];
    }
}

-(void)startPlaying
{
    //if already playing the view loaded while the track was playing
    if(!csound.isPlayingTrack)
    {
        csound.mPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:[self recordingURL] error:nil];
        [csound.mPlayer setDelegate:self];
        [csound.mPlayer play];
      
    }
    else //need a new instance of play timer to auto update buttons when it finishes
    {
        [csound.timerPlay invalidate];
        csound.timerPlay = nil;
    }
    csound.timerPlay = [NSTimer scheduledTimerWithTimeInterval:0.1
                                                        target:self
                                                      selector:@selector(playTimerFired:)
                                                      userInfo:nil//[NSNumber numberWithFloat:csound.playTime]
                                                       repeats:true];
    
    [self disableRecordButton:buttonRecord];
    csound.isPlayingTrack = true;

    [glowRecordImage startGlowingWithColor:colors.playGreenBorder intensity:0.6];
    [buttonRecordPlay setBorderColor:colors.playGreenBorder];
    [buttonRecordPlay setTitle:stop forState:UIControlStateNormal];
    [buttonRecordPlay setTitle:stop forState:UIControlStateSelected];
    
}

-(void)stopPlayingTrack
{
    [self enableRecordButton:buttonRecord enabledColor:colors.recordRedBorder];
    [buttonRecordPlay setTitle:play forState:UIControlStateNormal];
    [buttonRecordPlay setTitle:play forState:UIControlStateSelected];
    [buttonRecordPlay setBorderColor:colors.playGreenBorder];

    [buttonRecordPlay setSelected:false];
   // NSLog(@"Stop playing track: play button is selected: %hhd title is: %@", buttonRecordPlay.isSelected,[buttonRecordPlay currentTitle]);
    [csound.mPlayer stop];
    [csound.timerPlay invalidate];
    csound.timerPlay = nil;
    csound.playTime = 0;
    csound.isPlayingTrack = false;
   
}

- (void)playTimerFired:(NSTimer *)timer {
   
    csound.playTime += 0.1;
    
    if(csound.playTime >= csound.recordTime)
    {
        [buttonRecordPlay sendActionsForControlEvents:UIControlEventTouchUpInside];
    }
    
}

-(void)disableRecordButton:(DKCircleButton*)button
{
    [button setEnabled:false];
    [button setTitleColor:colors.disabled forState:UIControlStateDisabled];
    [button setBorderColor:colors.disabled];
   
}

- (void)enableRecordButton:(DKCircleButton*)button enabledColor:(UIColor*)color
{
    [button setEnabled:true];
    [button setTitleColor:colors.black forState:UIControlStateNormal];
    [button setBorderColor:color];
    [glowRecordImage stopGlowing];
    
   // NSLog(@"enabling record button. isEnabled: %hhd titleColor: %@ actual title: %@", button.isEnabled, [button titleColorForState:UIControlStateNormal], [button currentTitle]);
}

- (IBAction)showLoopInfo:(UIButton *)sender {
    RNBlurModalView *modal = [[RNBlurModalView alloc] initWithViewController:self
                                                                       title:@"Loop" message:@"Use 'record' to record up to 11 seconds of sound for looping. 'stop' when finished (RoboTune will stop automatically if you run out of space), 'play' to play your loop back. Note you will need to practice getting your timings right!\n\nPlay your loop back 'Forward', 'backward' or 'Both' for back/forward. Control the loudness of playback with 'loop level'."
                                                                    fontSize:screenHelper.modalFontSize
                                                                       width:screenHelper.modalWidth];
    [modal show];
    
}

- (IBAction)showRecordInfo:(UIButton *)sender {
    
    RNBlurModalView *modal = [[RNBlurModalView alloc] initWithViewController:self
                                                                       title:@"Recording" message:@"When recording your piece, we write your performances to a file on your device. Currently we don’t support encoding this so you can retrieve the WAV file using external tools for now. See http://support.apple.com/kb/ph1693 for details.\n\n Don’t worry, coming soon is SoundCloud integration and encoding of saved performances. Stay tuned."
                                                                    fontSize:screenHelper.modalFontSize
                                                                       width:screenHelper.modalWidth];
    [modal show];
    
}



@end
