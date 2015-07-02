//
//  ViewController2.m
//  RoboTune2
//
//  Created by Alan O'Sullivan on 21/09/2014.
//  Copyright (c) 2014 Alan O'Sullivan. All rights reserved.
//

#import "ViewControllerEffects.h"
#import "RNBlurModalView.h"
#import "ColorSingleton.h"
#import "ControlHelper.h"
#import "UIView+Glow.h"
#import "ViewController.h"
#import "UIBarButtonItem+WithImageOnly.h"

@interface ViewControllerEffects () <ASValueTrackingSliderDataSource>
{
}
@end

@implementation ViewControllerEffects

@synthesize uiViewName;

static NSString *stop = @"stop";
static NSString *play = @"play";
static NSString *record = @"record";
static NSString *recordLengthKey = @"robo_record_len";


- (void)viewDidLoad
{
    
    [super viewDidLoad];
    
    //NSLog(@"self inited: %@", self.uiViewName);

    [self configureToolBar];
    
    [self addSwipeHandlers];
    
    screenHelper = [ScreenDimensionHelper getInstance];
    
    colors = [ColorSingleton getInstance];
    
    [self initCsound];
   
    [self initControlsFromCsound];
    
}


-(void)configureToolBar
{
    
    buttonInfo = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Monochrome_robo_title.png"] target:self action:@selector(infoPressed:)];
    self.navigationItem.rightBarButtonItems =  @[buttonInfo];

}

-(void)infoPressed:(UIBarButtonItem *)sender
{
    //robo!
}

- (void)addSwipeHandlers
{
    // Disable iOS 7 back gesture
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
        self.navigationController.interactivePopGestureRecognizer.delegate = self;
    }
    UISwipeGestureRecognizerDirection dir;
    dir = UISwipeGestureRecognizerDirectionRight;
 
    
    UISwipeGestureRecognizer *swipeLeft = [[UISwipeGestureRecognizer alloc]
                                           initWithTarget:self
                                           action:@selector(swipeLeft:)] ;
    [swipeLeft setDirection:dir];
    [[self view] addGestureRecognizer:swipeLeft];
    

}


- (void)swipeLeft:(UITapGestureRecognizer *)recognizer
{
   [self.navigationController popViewControllerAnimated:YES];
    
}

-(void)backButtonTapped:(id)sender{
    [self performSegueWithIdentifier:@"seguePresets" sender:sender];
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

//TODO update via reflection from all channels in csound single channel list
- (void)initControlsFromCsound
{
    
    sliderSource.value = csound.channel_cross;
    [segmentSource setSelectedSegmentIndex:csound.channel_source];
    switch (segmentSource.selectedSegmentIndex) {
        case 0:
        case 2:
            sliderSource.enabled = false;
            break;
        case 1:
              sliderSource.enabled = true;
        default:
            break;
    }
    
    switchGate.on = csound.channel_gateswitch;
    sliderGate.enabled = switchGate.on;
    sliderGate.value = csound.channel_gate;
    
    //switchReverb.on = csound.channel_appreverb;
    [segmentReverb setSelectedSegmentIndex:csound.channel_appreverb];
    sliderReverb.value = csound.channel_reverblevel;
    sliderReverbTone.value = csound.channel_reverbtone;
    
   // switchDelay.on = csound.channel_appdelay;
    [segmentDelay setSelectedSegmentIndex:csound.channel_appdelay];
    sliderDelayFdb.value = csound.channel_fdb;
    sliderDelayInterval.value = csound.channel_delayinterval;
    
    [segmentAutoHarm setSelectedSegmentIndex:csound.channel_autorobo];
        
    sliderHarm1Level.value = csound.channel_harmlevel1;
    sliderHarm2Level.value = csound.channel_harmlevel2;
    sliderHarm3Level.value = csound.channel_harmlevel3;
    sliderMainLevel.value = csound.channel_mainlevel;

    sliderHarm1Value.value = csound.channel_harm1;
    sliderHarm2Value.value = csound.channel_harm2;
    sliderHarm3Value.value = csound.channel_harm3;
  
    switchFormant.on = csound.channel_harm1form;
    
    sliderKey.value = csound.channel_key;
    [segmentScale setSelectedSegmentIndex:csound.channel_scale];
    
    
    if(csound.channel_autorobo >0)
    {
        sliderHarm1Value.enabled = false;
        sliderHarm2Value.enabled = false;
        sliderHarm3Value.enabled = false;
    }
    
}


-(void)initSliders
{
    //** slider names are used to set values from a single slider change method **
    
    sliderSource.name = csound.channelNames.CHANNEL_CROSS;
    sliderGate.name = csound.channelNames.CHANNEL_GATEVALUE;
    sliderHarm1Level.name = csound.channelNames.CHANNEL_HARMLEVEL1;
    sliderHarm1Value.name = csound.channelNames.CHANNEL_HARM1;
    sliderHarm2Level.name = csound.channelNames.CHANNEL_HARMLEVEL2;
    sliderHarm2Value.name = csound.channelNames.CHANNEL_HARM2;
    sliderHarm3Level.name = csound.channelNames.CHANNEL_HARMLEVEL3;
    sliderHarm3Value.name = csound.channelNames.CHANNEL_HARM3;
    sliderMainLevel.name = csound.channelNames.CHANNEL_MAINLEVEL;
    sliderReverb.name = csound.channelNames.CHANNEL_REVERBLEVEL;
    sliderReverbTone.name = csound.channelNames.CHANNEL_REVERBTONE;
  
    sliderReverb.enabled = !segmentReverb.selectedSegmentIndex;
    sliderReverbTone.enabled = !segmentReverb.selectedSegmentIndex;
    
    sliderKey.name = csound.channelNames.CHANNEL_KEY;
    sliderDelayFdb.name = csound.channelNames.CHANNEL_DELAYFDB;
    sliderDelayInterval.name = csound.channelNames.CHANNEL_DELAYINTERVAL;
   
    sliderDelayFdb.enabled = !segmentDelay.selectedSegmentIndex;
    sliderDelayInterval.enabled = !segmentDelay.selectedSegmentIndex;
    
    //for ROUNDING sliders
    [sliderHarm1Value addTarget:self action:@selector(sliderChanged:) forControlEvents:UIControlEventValueChanged];
    [sliderHarm2Value addTarget:self action:@selector(sliderChanged:) forControlEvents:UIControlEventValueChanged];
    [sliderHarm3Value addTarget:self action:@selector(sliderChanged:) forControlEvents:UIControlEventValueChanged];
    
    [sliderKey addTarget:self action:@selector(sliderChanged:) forControlEvents:UIControlEventValueChanged];
    sliderKey.dataSource = self;
    
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterNoStyle];
    [sliderHarm1Value setNumberFormatter:formatter];
    [sliderHarm2Value setNumberFormatter:formatter];
    [sliderHarm3Value setNumberFormatter:formatter];
  
   

    [self initHarmLabels];
    
    [self initSourceLabels];
    
    [self initReverbLabels];
    
    [self initDelayLabels];
    
    [self initKeyLabel];
   
    
}

- (NSString *)getKeyString:(float)value
{
    value = roundf(value);
    int intValue = (int) value;
    NSString *s;
    
    switch (intValue) {
        case 0:
            s= @"C";
            break;
        case 1:
            s= @"C#";
            break;
        case 2:
            s= @"D";
            break;
        case 3:
            s= @"D#";
            break;
        case 4:
            s= @"E";
            break;
        case 5:
            s= @"E#";
            break;
        case 6:
            s= @"F";
            break;
        case 7:
            s= @"F#";
            break;
        case 8:
            s= @"G";
            break;
        case 9:
            s= @"G#";
            break;
        case 10:
            s= @"A";
            break;
        case 11:
            s= @"A#";
            break;
        case 12:
            s= @"B";
            break;
        default:
            break;
    }
    
    return s;
}

//only 1 slider can subscribe to this at the moment unless check slider Tag TODO
- (NSString *)slider:(ASValueTrackingSlider *)slider stringForValue:(float)value;
{
    return [self getKeyString:value];
}


//only update label text on end of drag
- (IBAction)sliderValueDidEndSliding:(UISlider *)sender {
  
    //still using tags. need better system - TODO add to value slider
    NSString *sliderValueFormat = @"%.2f";
    switch (sender.tag) {
        case 2: //harm semitone
        case 4:
        case 6:
            sliderValueFormat = @"%0.0f";
            break;
        case 1: //harm1 level
        case 3: //harm2 level
        case 5: //harm3 level
        case 7: //source
        case 8: //gate
        case 18: //delay interval
        case 19: //delay fdb
        //case 20: //loop level
        case 16: //reverb level
        case 22: //main level
        case 21: //reverb tone
            sliderValueFormat = @"%.2f";
            break;
        default:
            sliderValueFormat = @"%0.0f";
            break;
    }
    
    UILabel *label = [ControlHelper getSliderLabel:sender withTag:sender.tag+500];
    if(sender.tag==17) //key is a string value
    {
        [self sliderValueChanged:(ASValueTrackingSlider *)sender];
        label.text = [self getKeyString:sender.value];
        
    }
    else
    {
        label.text = [NSString stringWithFormat:sliderValueFormat, sender.value];
    }
    
}



- (IBAction)sliderValueChanged:(ASValueTrackingSlider *)sender {
    
   // NSLog(@"Slider tag changed: %d - %@", sender.tag, sender.name);
    NSNumber * channelSliderValue = [NSNumber numberWithFloat:sender.value];
    
    [csound setCsoundChannelValue:sender.name value:channelSliderValue];
    
    UILabel *label = [ControlHelper getSliderLabel:sender withTag:sender.tag+500];
    label.text = @"";
    
    
}

- (void)sliderChanged:(UISlider *)mySlider {
    mySlider.value = round(mySlider.value);
    //self.valueLabel.text = [NSString stringWithFormat:@"%g", mySlider.value];
}



- (IBAction)segmentChanged:(UISegmentedControl  *)sender
{
    //TODO reflect over these controls
    switch (sender.tag) {
        case 101:
            csound.channel_source = sender.selectedSegmentIndex;
             [csound updateCsoundChannel:csound.channelNames.CHANNEL_SOURCE];
            
            switch (sender.selectedSegmentIndex) {
                case 0:
                case 2:
                    sliderSource.enabled = false;
                    break;
                case 1:
                    sliderSource.enabled = true;

                default:
                    break;
            }

            break;
        case 103:
            csound.channel_autorobo = sender.selectedSegmentIndex;
             [csound updateCsoundChannel:csound.channelNames.CHANNEL_AUTOROBO];
            
            switch (sender.selectedSegmentIndex) {
                case 1:
                case 2:
                    sliderHarm1Value.enabled = false;
                    sliderHarm2Value.enabled = false;
                    sliderHarm3Value.enabled = false;
                    
                    break;
                case 0:
                    sliderHarm1Value.enabled = true;
                    sliderHarm2Value.enabled = true;
                    sliderHarm3Value.enabled = true;
                default:
                    break;
            }
            
            break;
        case 102:
            csound.channel_scale = sender.selectedSegmentIndex;
             [csound updateCsoundChannel:csound.channelNames.CHANNEL_SCALE];
            break;
        case 105:
            csound.channel_click = sender.selectedSegmentIndex;
             [csound updateCsoundChannel:csound.channelNames.CHANNEL_CLICK];
            break;
        case 106:
            csound.channel_appdelay = sender.selectedSegmentIndex;
            [csound updateCsoundChannel:csound.channelNames.CHANNEL_APPDELAY];
             sliderDelayFdb.enabled = !sender.selectedSegmentIndex;
             sliderDelayInterval.enabled = !sender.selectedSegmentIndex;
            break;
        case 107:
            csound.channel_appreverb = sender.selectedSegmentIndex;
            [csound updateCsoundChannel:csound.channelNames.CHANNEL_APPREVERB];
             sliderReverb.enabled = !sender.selectedSegmentIndex;
            sliderReverbTone.enabled = !sender.selectedSegmentIndex;

            break;
        default:
            break;
    }
    
    // [csound overwriteCsoundChannels];

}

- (IBAction)switchChanged:(UISwitch *)sender {
    
    //TODO reflect over these controls
    switch (sender.tag) {
        case 204:
            csound.channel_harm1form = sender.on;
            break;
        case 201:
            csound.channel_gateswitch = sender.on;
              sliderGate.enabled = sender.on;
            break;
        case 202:
            csound.channel_appreverb = sender.on;
            sliderReverb.enabled = !sender.on;
        case 203:
            csound.channel_appdelay = sender.on;
              sliderDelayFdb.enabled = !sender.on;
              sliderDelayInterval.enabled = !sender.on;
            break;
        default:
            break;
    }
    
     [csound overwriteCsoundChannels];
}

- (void)initKeyLabel
{
   // NSLog(@"slider key sub views: %d", sliderKey.subviews.count);
    UILabel *label = [ControlHelper getSliderLabel:sliderKey withTag:sliderKey.tag+500];
    label.text = [self getKeyString:sliderKey.value];
    
}


- (void)initReverbLabels
{
    
    UILabel *label = [ControlHelper getSliderLabel:sliderReverb withTag:sliderReverb.tag+500];
    label.text = [NSString stringWithFormat:@"%.2f", sliderReverb.value];
    UILabel *label2 = [ControlHelper getSliderLabel:sliderReverbTone withTag:sliderReverbTone.tag+500];
    label2.text = [NSString stringWithFormat:@"%.2f", sliderReverbTone.value];

}

- (void)initDelayLabels
{
    
    UILabel *label = [ControlHelper getSliderLabel:sliderDelayFdb withTag:sliderDelayFdb.tag+500];
    label.text = [NSString stringWithFormat:@"%.2f", sliderDelayFdb.value];
    
    UILabel *label2 = [ControlHelper getSliderLabel:sliderDelayInterval withTag:sliderDelayInterval.tag+500];
    label2.text = [NSString stringWithFormat:@"%.2f", sliderDelayInterval.value];
    
}


- (void)initSourceLabels
{
    
    UILabel *label = [ControlHelper getSliderLabel:sliderSource withTag:sliderSource.tag+500];
    label.text = [NSString stringWithFormat:@"%.2f", sliderSource.value];
    UILabel *label2 = [ControlHelper getSliderLabel:sliderGate withTag:sliderGate.tag+500];
    label2.text = [NSString stringWithFormat:@"%.2f", sliderGate.value];
    UILabel *label3 = [ControlHelper getSliderLabel:sliderMainLevel withTag:sliderMainLevel.tag+500];
    label3.text = [NSString stringWithFormat:@"%.2f", sliderMainLevel.value];

    
}

- (void)initHarmLabels
{
    
    UILabel *label = [ControlHelper getSliderLabel:sliderHarm1Value withTag:sliderHarm1Value.tag+500];
    label.text = [NSString stringWithFormat:@"%0.0f", sliderHarm1Value.value];
    UILabel *label2 = [ControlHelper getSliderLabel:sliderHarm2Value withTag:sliderHarm2Value.tag+500];
    label2.text = [NSString stringWithFormat:@"%0.0f", sliderHarm2Value.value];
    UILabel *label3 = [ControlHelper getSliderLabel:sliderHarm3Value withTag:sliderHarm3Value.tag+500];
    label3.text = [NSString stringWithFormat:@"%0.0f", sliderHarm3Value.value];
    
    UILabel *label4 = [ControlHelper getSliderLabel:sliderHarm1Level withTag:sliderHarm1Level.tag+500];
    label4.text = [NSString stringWithFormat:@"%.2f", sliderHarm1Level.value];
    UILabel *label5 = [ControlHelper getSliderLabel:sliderHarm2Level withTag:sliderHarm2Level.tag+500];
    label5.text = [NSString stringWithFormat:@"%.2f", sliderHarm2Level.value];
    UILabel *label6 = [ControlHelper getSliderLabel:sliderHarm3Level withTag:sliderHarm3Level.tag+500];
    label6.text = [NSString stringWithFormat:@"%.2f", sliderHarm3Level.value];

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
    
}

- (IBAction)showSourceInfo:(UIButton *)sender {
    RNBlurModalView *modal = [[RNBlurModalView alloc] initWithViewController:self
                                                                       title:@"Source" message:@"Clean Tune: Sing/Play perfectly in pitch, in the key you choose in the 'scale' effect section.\nRobo Tune: Your voice/source, perfectly pitched, morphed with a Robot! Use the slider for more or less Robo!\nBypass:Bypass any pitch tuning effects. This setting disables 'scale' and 'harmony' effects as they are based on the Clean Tune and Robo Tune settings.\n'gate' allows you to remove background noise; move the slider to the right to remove more noise. Try listening without performing, and move the slider to the point where all background noise is removed in your headphones.\nControl the loudness of your main source sound with 'main level'. "
                                                                    fontSize:screenHelper.modalFontSize
                                                                       width:screenHelper.modalWidth];
    [modal show];
}

- (IBAction)showReverbInfo:(UIButton *)sender {
    RNBlurModalView *modal = [[RNBlurModalView alloc] initWithViewController:self
                                                                       title:@"Reverb" message:@"Add space to your sounds! Move the 'level' slider to the right to move from a bedroom-like reverberation to a cathedral-like effect.\n\nUse the tone control for a darker reverb .\n\nNOTE 1: Turn reverb off to alter the controls to avoid clicky sounds in your output.\n\nNOTE 2: Turn reverb back on for your settings to take effect!. "
                                                                    fontSize:screenHelper.modalFontSize
                                                                       width:screenHelper.modalWidth];
    [modal show];
}
- (IBAction)showDelayInfo:(UIButton *)sender {
    RNBlurModalView *modal = [[RNBlurModalView alloc] initWithViewController:self
                                                                       title:@"Reverb" message:@"The 'time' slider decides how much time there is between echoes (for longer delays between each echo).\n\nThe 'echoes' slider allows you to select the loudness of each echo in your delay effect. Quieter delays fade out sooner, louder ones last longer.\n\nNOTE 1: Turn delay off to alter the controls to avoid clicky sounds in your output.\n\nNOTE 2: Turn delay back on for your settings to take effect!. "
                                                                    fontSize:screenHelper.modalFontSize
                                                                       width:screenHelper.modalWidth];
    [modal show];
}

- (IBAction)showScaleInfo:(UIButton *)sender {
    
    RNBlurModalView *modal = [[RNBlurModalView alloc] initWithViewController:self
                                                                       title:@"Scale" message:@"Choose the scale your source sound is being tuned to (for example, 'C' and 'major' refers to all the white notes on the piano, 'C' and 'chromatic' refers to all notes on the piano, white and black. Major for happy scales, minor for sad; read more about music theory for more details). \n\n'Hear scale' plays your scale back to you on a synthesiser; these are the notes your source sound will be tuned to"
                                                                    fontSize:screenHelper.modalFontSize
                                                                       width:screenHelper.modalWidth];
    [modal show];
}




- (IBAction)showHarmonyInfo:(UIButton *)sender {
    
    RNBlurModalView *modal = [[RNBlurModalView alloc] initWithViewController:self
                                                                       title:@"Harmonies" message:@"Control 3 harmony voices. 'Auto low' harmony automatically harmonises your source sound with chords that fit your musical scale, with deep, powerful harmonies. 'Auto high' harmony works similarly, with higher, lighter voices. 'Manual' allows you to choose the semitones above/below(-) your source sound of each harmony voice (semitone controls are disabled in 'auto' modes).\n\nYou can also choose the loudness of each harmony voice here with a 'level' slider for each.\nThe first voice has the option of a 'formant' filter, allowing you to keep its characteristic tone while altering its pitch."
                                                                    fontSize:screenHelper.modalFontSize
                                                                       width:screenHelper.modalWidth];
    [modal show];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

    /*
     * REVISIT - MAYBE NOT

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.

    if([segue.identifier isEqualToString:@"seguePresets"])
    {
        //ViewController *vc = (ViewController  *)[segue destinationViewController];
       
        [UIView animateWithDuration:0.75
                         animations:^{
                             [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
                             //[self.navigationController pushViewController:vc animated:NO];
                             [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:self.navigationController.view cache:NO];
                         }];
        
    }

}

     */

@end
