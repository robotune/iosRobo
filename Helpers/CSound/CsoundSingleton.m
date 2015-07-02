//
//  CsoundSingleton.m
//  RoboTune2
//
//  Created by Alan O'Sullivan on 21/09/2014.
//  Copyright (c) 2014 Alan O'Sullivan. All rights reserved.
//

#import "CsoundSingleton.h"
#import "CsoundUI.h"

#import "OutputBinding.h"

#import "ChannelNames.h"
#import "SyncDelegate.h"
#import <AVFoundation/AVFoundation.h>
#import "UIView+Toast.h"

@implementation CsoundSingleton

@synthesize delegate;
@synthesize csound;

static CsoundSingleton * single=nil;

+(CsoundSingleton *)getInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        single = [[CsoundSingleton alloc] init];
        
        
        single = [[CsoundSingleton alloc] init];
        single.csdFile = ChannelNames.getCSDFile;
        single.csound = [[CsoundObj alloc] init];
        [single.csound addListener:single];
        
        single.isLoopRecordPaused = true;
        single.isPlayingTrack = false;
        single.isLoopPlayPaused = true;
        single.isRecordingTrack = false;
        
        single.csound.useAudioInput = YES;
        
        //[single.csound setMessageCallback:@selector(messageCallback:) withListener:single];
        
        // Microphone enabled code
        //NSLog(@"starting cssound");
        
        single.preset = 1; //bon by default
        
        single.channelNames = [ChannelNames getInstance];
        
        CsoundUI *csoundUI = [[CsoundUI alloc] initWithCsoundObj:single.csound];
        
        //add all base initial values TODO load from presets?
        
        [csoundUI addOutputBinding: single.channelNames.CHANNEL_SOURCE withDefaultValue:0];
        [csoundUI addOutputBinding:single.channelNames.CHANNEL_CROSS withDefaultValue:0.4];
        
        [csoundUI addOutputBinding:single.channelNames.CHANNEL_GATE withDefaultValue:0];
        [csoundUI addOutputBinding:single.channelNames.CHANNEL_GATEVALUE withDefaultValue:0.1];
        
        [csoundUI addOutputBinding:single.channelNames.CHANNEL_APPREVERB withDefaultValue:0];
        [csoundUI addOutputBinding:single.channelNames.CHANNEL_APPDELAY withDefaultValue:0];
        [csoundUI addOutputBinding:single.channelNames.CHANNEL_REVERBLEVEL withDefaultValue:0.5];
        [csoundUI addOutputBinding:single.channelNames.CHANNEL_REVERBTONE withDefaultValue:0.35];
        [csoundUI addOutputBinding:single.channelNames.CHANNEL_DELAYINTERVAL withDefaultValue:0.5];
        [csoundUI addOutputBinding:single.channelNames.CHANNEL_DELAYFDB withDefaultValue:0.5];
        
        [csoundUI addOutputBinding:single.channelNames.CHANNEL_SCALE withDefaultValue:0];
        [csoundUI addOutputBinding:single.channelNames.CHANNEL_CLICK withDefaultValue:0];
        [csoundUI addOutputBinding:single.channelNames.CHANNEL_KEY withDefaultValue:0];
        
        //harmony
        [csoundUI addOutputBinding:single.channelNames.CHANNEL_AUTOROBO withDefaultValue:2];
        [csoundUI addOutputBinding:single.channelNames.CHANNEL_HARMLEVEL1 withDefaultValue:0.5];
        [csoundUI addOutputBinding:single.channelNames.CHANNEL_HARMLEVEL2 withDefaultValue:0.625];
        [csoundUI addOutputBinding:single.channelNames.CHANNEL_HARMLEVEL3 withDefaultValue:0.75];
        
        [csoundUI addOutputBinding:single.channelNames.CHANNEL_HARM1 withDefaultValue:7];
        [csoundUI addOutputBinding:single.channelNames.CHANNEL_HARM2 withDefaultValue:-12];
        [csoundUI addOutputBinding:single.channelNames.CHANNEL_HARM3 withDefaultValue:-24];
        
        [csoundUI addOutputBinding:single.channelNames.CHANNEL_HARMFORM withDefaultValue:0];
        
        [csoundUI addOutputBinding:single.channelNames.CHANNEL_MAINLEVEL withDefaultValue:0.5];
        
        [csoundUI addOutputBinding:single.channelNames.CHANNEL_LOOP withDefaultValue:0];
        
        [csoundUI addOutputBinding:single.channelNames.CHANNEL_LOOPPLAY withDefaultValue:0];
        
        [csoundUI addOutputBinding:single.channelNames.CHANNEL_LOOPTYPE withDefaultValue:0];
        
        [csoundUI addOutputBinding:single.channelNames.CHANNEL_LOOPLEVEL withDefaultValue:0.5];
        
        
        [csoundUI addOutputBinding:single.channelNames.CHANNEL_TEMPO withDefaultValue:120];
        
        
        single.bindingLoopPos = [[InputBinding alloc]init:single.channelNames.CHANNEL_LOOPPOS];
        [single.bindingLoopPos setDelegate:(id<SyncDelegate>)single];
        [csoundUI addInputBinding:single.bindingLoopPos];
        
        single.bindingLoopSync = [[InputBinding alloc]init:single.channelNames.CHANNEL_LOOPSYNC];
        [single.bindingLoopSync setDelegate:(id<SyncDelegate>)single];
        [csoundUI addInputBinding:single.bindingLoopSync];
        
        [single loadBon]; //this initializes singletons properties
        
        //[single.channels addObject:single.channel_source];
        [single startAndDetermineHeadphones];

        
    });
    
   /* @synchronized(self)
    {
        if(!single)
        {
            
        }
        else if(!single.isRunning)
        {
             [single startAndDetermineHeadphones];
        }
        
    }*/
    
    return single;
    
}

- (void)startAndDetermineHeadphones
{
    [AVAudioSession sharedInstance];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(audioRouteChangeListenerCallback:)
                                                 name:AVAudioSessionRouteChangeNotification
                                               object:nil];
   
    if(self.isHeadsetPluggedIn!=true)
    {
        [self showDeviceDependantNoHeadphonesMessage];
    }
    
    else
    {
        [self startCsound:self.csdFile];
        
    }

}

- (void)setShowingView:(UIView *)currentView
{
    self.currentView = currentView;
}

// If the user pulls out he headphone jack, stop playing.
- (void)audioRouteChangeListenerCallback:(NSNotification*)notification
{
    NSDictionary *interuptionDict = notification.userInfo;
    NSInteger routeChangeReason = [[interuptionDict valueForKey:AVAudioSessionRouteChangeReasonKey] integerValue];
   
    NSString *headPhonesMessage;

    int isSuccessMessage = [self isHeadsetPluggedIn]; //initial
    
    switch (routeChangeReason) {
            
        case AVAudioSessionRouteChangeReasonNewDeviceAvailable:
             isSuccessMessage = 1;
            break;
            
        case AVAudioSessionRouteChangeReasonOldDeviceUnavailable:
            isSuccessMessage = 0;
            break;
        }
    
    if(isSuccessMessage==1)
    {
        headPhonesMessage = @"Headphone/Mic detected. Re-Initializing...";
        [self.currentView makeToast:@"" duration:5.0 position:CSToastPositionBottom title:headPhonesMessage];
    }
    else //headphones plugged out
    {
        [self showDeviceDependantNoHeadphonesMessage];
    }
    
   // NSLog(@"%@", headPhonesMessage);
    
}

-(void)showDeviceDependantNoHeadphonesMessage
{
    if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
    {
        NSString *headPhonesMessage = @"Headphones or Mic removed. It is advised to use a headphones or a mic with RoboTune. If you experience feedback lower speaker volume or adjust the gate in the source effects setting.";
        [self.currentView makeToast:@"" duration:5.0 position:CSToastPositionBottom title:headPhonesMessage];
        [self startCsound:self.csdFile]; //safe to start this anyway
        
    }
    else //iPhone - stop this csound running until headphones back in
    {
        NSString *headPhonesMessage = @"RoboTune processing stopped. Headphones or a Mic are required for iPhone RoboTune. Please insert Headphones/Mic into the device and press 'Ok' to continue.";
        [self stopCsound];
        [self alertNoHeadphones:headPhonesMessage];
    }

}

-(void)alertNoHeadphones:(NSString*) message
{
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No headphones detected!"
                                                    message:message
                                                   delegate:self
                                          cancelButtonTitle:@"Ok"
                                          otherButtonTitles:nil];
    [alert show];
    
}

- (BOOL)isHeadsetPluggedIn {
    AVAudioSessionRouteDescription* route = [[AVAudioSession sharedInstance] currentRoute];
    //AVAudioSessionRouteDescription* route = [[[AVAudioSession]]];
    for (AVAudioSessionPortDescription* desc in [route outputs]) {
        if ([[desc portType] isEqualToString:AVAudioSessionPortHeadphones])
        {
            return YES;
        }
        
    }
    return NO;
}


//now respond to selecting ok on alertview but repeat message if no headphones
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0){
        
        if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) //only showing this alert on iPhone anyway
        {
            if(self.isHeadsetPluggedIn==true)
            {
                 [self startCsound: self.csdFile];
             
            }
            else
            {
                NSString *headPhonesMessage = @"RoboTune processing stopped. Headphones or a Mic are required for iPhone RoboTune. Please insert Headphones/Mic into the device and press 'Ok' to continue.";
                [self alertNoHeadphones:headPhonesMessage];
            }
       }
    }
}


- (void)savePresetValues
{
     self.channels =
    @{
        self.channelNames.CHANNEL_SOURCE : [NSNumber numberWithFloat:(self.channel_source)],
        self.channelNames.CHANNEL_CROSS: [NSNumber numberWithFloat:(self.channel_cross)],
        self.channelNames.CHANNEL_GATE: [NSNumber numberWithFloat:(self.channel_gateswitch)],
        self.channelNames.CHANNEL_APPREVERB: [NSNumber numberWithFloat:(self.channel_appreverb)],
        self.channelNames.CHANNEL_APPDELAY: [NSNumber numberWithFloat:(self.channel_appdelay)],
        self.channelNames.CHANNEL_REVERBLEVEL: [NSNumber numberWithFloat:(self.channel_reverblevel)],
        self.channelNames.CHANNEL_REVERBTONE: [NSNumber numberWithFloat:(self.channel_reverbtone)],
        self.channelNames.CHANNEL_DELAYINTERVAL: [NSNumber numberWithFloat:(self.channel_delayinterval)],
        self.channelNames.CHANNEL_DELAYFDB: [NSNumber numberWithFloat:(self.channel_fdb)],
        self.channelNames.CHANNEL_SCALE: [NSNumber numberWithFloat:(self.channel_scale)],
        self.channelNames.CHANNEL_KEY: [NSNumber numberWithFloat:(self.channel_key)],
        self.channelNames.CHANNEL_AUTOROBO: [NSNumber numberWithFloat:(self.channel_autorobo)],
        self.channelNames.CHANNEL_HARMLEVEL1: [NSNumber numberWithFloat:(self.channel_harmlevel1)],
        self.channelNames.CHANNEL_HARMLEVEL2: [NSNumber numberWithFloat:(self.channel_harmlevel2)],
        self.channelNames.CHANNEL_HARMLEVEL3: [NSNumber numberWithFloat:(self.channel_harmlevel3)],
        self.channelNames.CHANNEL_HARM1: [NSNumber numberWithFloat:(self.channel_harm1)],
        self.channelNames.CHANNEL_HARM2: [NSNumber numberWithFloat:(self.channel_harm2)],
        self.channelNames.CHANNEL_HARM3: [NSNumber numberWithFloat:(self.channel_harm3)],
        self.channelNames.CHANNEL_HARMFORM: [NSNumber numberWithFloat:(self.channel_harm1form)],
        self.channelNames.CHANNEL_MAINLEVEL: [NSNumber numberWithFloat:(self.channel_mainlevel)],
        self.channelNames.CHANNEL_LOOPTYPE: [NSNumber numberWithFloat:(self.channel_looptype)],
        self.channelNames.CHANNEL_LOOPLEVEL: [NSNumber numberWithFloat:(self.channel_looplevel)],
        
    };
                        
}

- (void)receivedSyncValue:(float)value forChannel:(NSString *)channelName{
    
    //NSLog(@" selfton receivedSyncValue: %f ", value);
    
    if([channelName isEqualToString:self.channelNames.CHANNEL_LOOPPOS])
    {
        self.channel_loopPos = value;
    }
    if([channelName isEqualToString:self.channelNames.CHANNEL_LOOPSYNC])
    {
        if(value==1)
        {
           // NSLog(@"loop sync: %f", value);
            self.channel_loopsync  =1;
            
        }
        
    }
    
    
}



-(void)startCsound:(NSString *)file

{
    [[AVAudioSession sharedInstance] requestRecordPermission:^(BOOL granted) {
        if (granted) {
            if(!self.isRunning)
            {
                // Microphone enabled code
                [self.csound play:file];
                self.isRunning = true;
                //NSLog(@"Csound not start so STARTING!");
            }
            
        }
    }];
}

- (void)stopCsound{
    if(self.isRunning)
    {
        [self.timerLoopRecord invalidate];
        self.timerLoopRecord = nil;
        
        [self.timerLoopPlay invalidate];
        self.timerLoopPlay = nil;
        
        [self.timerRecord invalidate];
        self.timerRecord = nil;
        
        [self.timerPlay invalidate];
        self.timerPlay = nil;

        [self.csound stopRecording];
        [self.csound stop];
        self.isRunning = false;
        
       //NSLog(@"Csound was start so STOPING!");
    }
    
}

-(void)loadDefaults
{
    //////////
    
    //self.channel_appdelay = 0; //force this off to update first
    //[self updateCsoundChannel:self.channelNames.CHANNEL_APPDELAY];
    
    //////////
    
    
    self.channel_tempo = 120;
    
    self.channel_source= 0;
    self.channel_cross = 0.4;
    self.channel_gateswitch = 0;
    self.channel_gate = 0.1;
    
    self.channel_appreverb = 0;
    self.channel_reverblevel = 0.3;
    self.channel_reverbtone = 0.35;
    
    self.channel_appdelay = 1;
    
    self.channel_delayinterval = 0.45;
    self.channel_fdb = 0.45;
    
    self.channel_autorobo = 2;
    
    self.channel_harmlevel1 = 0.5;
    self.channel_harmlevel2 = 0.625;
    self.channel_harmlevel3 = 0.75;
    
    self.channel_harm1 = 7;
    self.channel_harm2 = -12;
    self.channel_harm3 = -24;
    
    self.channel_harm1form = 1;
    
    self.channel_mainlevel = 0.5;
    
    self.channel_scale = 0;
    self.channel_click = 0;
    self.channel_key = 0;
    
    //self.channel_loop = 0;
    //self.channel_loopplay = 0;
    
    self.channel_looptype = 0;
    
    self.channel_looplevel = 0.5;
    
    //[self savePresetValues]; //save the state of current preset
    
}

-(void)loadBon
{
    [self loadDefaults];
    [self overwriteCsoundChannels];
    
    self.channel_appdelay = 1;
    [self updateCsoundChannel:self.channelNames.CHANNEL_APPDELAY];
    
}
-(void)loadBonBuzz
{
    [self loadBon];
    self.channel_source = 1; //robo
    self.channel_autorobo = 1; //auto harmony low
    
    [self updateCsoundChannel:self.channelNames.CHANNEL_SOURCE];
    [self updateCsoundChannel:self.channelNames.CHANNEL_AUTOROBO];
    
    self.channel_appdelay = 1;
    [self updateCsoundChannel:self.channelNames.CHANNEL_APPDELAY];
}
-(void)loadKan
{
    [self loadBon];
    self.channel_autorobo = 0; //manual
    self.channel_mainlevel = 0.7;
    self.channel_harmlevel1 = 0;
    self.channel_harmlevel2 = 0;
    self.channel_harmlevel3 = 0;
    self.channel_appreverb = 1;
    self.channel_fdb = 0.5;
    [self updateCsoundChannel:self.channelNames.CHANNEL_AUTOROBO];
    [self updateCsoundChannel:self.channelNames.CHANNEL_MAINLEVEL];
    [self updateCsoundChannel:self.channelNames.CHANNEL_HARMLEVEL1];
    [self updateCsoundChannel:self.channelNames.CHANNEL_HARMLEVEL2];
    [self updateCsoundChannel:self.channelNames.CHANNEL_HARMLEVEL3];
    [self updateCsoundChannel:self.channelNames.CHANNEL_APPREVERB];
    [self updateCsoundChannel:self.channelNames.CHANNEL_DELAYFDB];
    
    self.channel_appdelay = 1;
    [self updateCsoundChannel:self.channelNames.CHANNEL_APPDELAY];
    
}
-(void)loadKanBuzz
{
    [self loadKan];
    self.channel_source = 1; //robo
    [self updateCsoundChannel:self.channelNames.CHANNEL_SOURCE];
    
    self.channel_appdelay = 1;
    [self updateCsoundChannel:self.channelNames.CHANNEL_APPDELAY];
    
}
-(void)loadChip
{
    [self loadKan];
    self.channel_mainlevel = 0;
    self.channel_harm1 = 12;
    self.channel_harmlevel1 = 1;
    self.channel_harm1form = 0;
   
    self.channel_appdelay = 1;
    [self updateCsoundChannel:self.channelNames.CHANNEL_APPDELAY];
    
    [self updateCsoundChannel:self.channelNames.CHANNEL_MAINLEVEL];
    [self updateCsoundChannel:self.channelNames.CHANNEL_HARM1];
    [self updateCsoundChannel:self.channelNames.CHANNEL_HARMLEVEL1];
    [self updateCsoundChannel:self.channelNames.CHANNEL_HARMFORM];

 
    
}

-(void)loadUserPreset:(NSInteger)userPreset
{
    /////
    
    //self.channel_appdelay = 0; //force this off to update first
    //[self updateCsoundChannel:self.channelNames.CHANNEL_APPDELAY];
    
    /////
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *key = [NSString stringWithFormat:@"%ld", (long)(userPreset + 800)];
    NSDictionary *presets = [defaults dictionaryForKey:key];
    if(presets.count > 0)
    {
        for(NSString* key in presets)
        {
            //id obj = [presets objectForKey:key];
            NSString *dataChannel = @"channel_";
            dataChannel =[dataChannel stringByAppendingString:key];
        
            @try
            {
                //id value = [self valueForKey:dataChannel]; //current value of channel property on selfton
                id presetValue =[presets valueForKey:key]; //preset value- overwrite current value and update csound
                [self setValue:presetValue forKey:dataChannel];
                
                [self updateCsoundChannel:key];
                
                float presetFloatValue = [[presets valueForKey:key] floatValue];
                //NSLog(@"Preset %@ value is %f ",key, presetFloatValue);

                
                if([key isEqualToString:(@"appdelay")])
                {
                    if((float)presetFloatValue == 1.0)
                    {
                        NSLog(@"Preset is setting delay to on");
                    }
                }
                
                //[self setValue:presetValue];
                //NSLog(@"key: %@  -- preset value: %@", key, presetValue);
            }
            @catch (NSException *e)
            {
                NSLog(@"%@ does not recognize the property \"name\" -- %@", dataChannel, e.reason);
            
            }
        
        }
        //[self overwriteCsoundChannels];

    }
    else
    {
        [self loadBon];
    }
    
   
}



-(void)setCsoundChannelValue:(NSString *)channel value:(NSNumber *)value
{
    @try
    {
        NSString *dataChannel = @"channel_";
        dataChannel =[dataChannel stringByAppendingString:channel];
        
        //set the property of the selfton by reflection
        [self setValue:value forKey:dataChannel];
        [self updateCsoundChannel:channel];
        //[csound overwriteCsoundChannels];
        
    }
    @catch (NSException *e)
    {
        if ([[e name] isEqualToString:NSUndefinedKeyException]) {
            NSLog(@"%@ slider change: does not recognize the property \"name\"", channel);
        }
    }

}


-(void)updateCsoundChannel:(NSString *)channelName
{
    NSPredicate * predicate = [NSPredicate predicateWithFormat:@"self.channelName == %@", channelName];
    NSArray * filteredArray = [self.csound.bindings filteredArrayUsingPredicate:predicate];
    if(filteredArray.count > 0)
    {
        OutputBinding *binding =  (OutputBinding *)[filteredArray objectAtIndex:0];
        NSString *dataChannel = [self getChannelName:binding];
        [self updateBinding:dataChannel forBinding:binding];
    }
    
    
    [self savePresetValues]; //save the state of current preset

}

-(void)overwriteCsoundChannels
{
   for (OutputBinding *binding in self.csound.bindings) {
        
        NSString *dataChannel = [self getChannelName:binding];
        if([binding isKindOfClass:[OutputBinding class]])
        {
            [self updateBinding:dataChannel forBinding:binding];
        }
       
    }
    
    
    //[self savePresetValues]; //save the state of current preset

}

-(void)updateBinding:(NSString *)dataChannel forBinding:(OutputBinding *)binding
{
    @try
    {
        id value = [self valueForKey:dataChannel];
        float propertyValue = [value floatValue];
        [binding setValue:propertyValue];
        //[binding updateValuesToCsound];
        //NSLog(@"%@ setting to %f", dataChannel, propertyValue);
        
        
    }
    @catch (NSException *e)
    {
        if ([[e name] isEqualToString:NSUndefinedKeyException]) {
            NSLog(@"%@ does not recognize the property \"name\"", dataChannel);
        }
    }

}

- (NSString *) getChannelName:(OutputBinding *)binding
{
    NSString *dataChannel = @"channel_";
    dataChannel =[dataChannel stringByAppendingString:binding.channelName];
    return dataChannel;

}

#pragma logging
- (void)updateUIWithNewMessage:(NSString *)newMessage
{
    NSLog(@"%@",newMessage);
	//NSString *oldText = self.debugTextView.text;
	//NSString *fullText = [oldText stringByAppendingString:newMessage];
    //uncomment below and show the textview in the ipad storyboard for debug on the ipad - could be huge resource hog
	//self.debugTextView.text = fullText;
}

- (void)messageCallback:(NSValue *)infoObj
{
	@autoreleasepool {
		Message info;
		[infoObj getValue:&info];
		char message[1024];
		vsnprintf(message, 1024, info.format, info.valist);
		NSString *messageStr = [NSString stringWithFormat:@"%s", message];
		[self performSelectorOnMainThread:@selector(updateUIWithNewMessage:)
							   withObject:messageStr
							waitUntilDone:NO];
	}
}

- (void)csoundObjStarted:(CsoundObj *)csoundObj
{
    NSLog(@"csoundObjCompleted %hhu", self.isRunning);

}
- (void)csoundObjCompleted:(CsoundObj *)csoundObj;
{

    [self stopCsound];
    NSLog(@"csoundObjCompleted %hhu", self.isRunning);
}

@end
