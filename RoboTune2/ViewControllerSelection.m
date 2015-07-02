//
//  ViewControllerSelection.m
//  RoboTune2
//
//  Created by Alan O'Sullivan on 05/10/2014.
//  Copyright (c) 2014 Alan O'Sullivan. All rights reserved.
//

#import "ViewControllerSelection.h"
#import "ViewControllerEffects.h"
#import "ColorSingleton.h"
#import "RNBlurModalView.h"
#import "UIBarButtonItem+WithImageOnly.h"

@interface ViewControllerSelection ()
{
}

@end

@implementation ViewControllerSelection

@synthesize uiViewName;


-(void)initCsound
{
    // Do any additional setup after loading the view.
    csdFile = [[NSBundle mainBundle] pathForResource:@"finalrobo8" ofType:@"csd"];
    csound = [CsoundSingleton getInstance];
   [csound setShowingView:self.view];    
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //NSLog(@"self inited: %@", self.uiViewName);
    
    [self initCsound]; //required for headphone change detections on all views
    
    screenHelper = [ScreenDimensionHelper getInstance];
 
    [self setButtonColors];
    
    buttonInfo = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Monochrome_robo_title.png"] target:self action:@selector(infoPressed:)];
    //buttonInfo.enabled = false;
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects: buttonInfo, nil]; // Or for fancy @[ rightA, rightB ];

    [self addSwipeHandlers];

    // csdFile = [[NSBundle mainBundle] pathForResource:@"finalrobo7" ofType:@"csd"];
    // csound = [CsoundSingleton getInstance:csdFile];
    
    ///[csound overwriteCsoundChannels];
}

-(void)viewDidAppear:(BOOL)animated
{
    
    [self initCsound]; //need to reset the view on each controller when "back" navigate is popped

}

- (void)addSwipeHandlers
{
    // Disable iOS 7 back gesture
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
        self.navigationController.interactivePopGestureRecognizer.delegate = self;
    }
    
    UISwipeGestureRecognizer *swipeRight = [[UISwipeGestureRecognizer alloc]
                                            initWithTarget:self
                                            action:@selector(swipeRight:)] ;
    [swipeRight setDirection:UISwipeGestureRecognizerDirectionRight];
    [[self view] addGestureRecognizer:swipeRight];
    
    
}

- (void)swipeRight:(UITapGestureRecognizer *)recognizer
{
   // [self performSegueWithIdentifier:@"segueEffectsToPresets" sender: self];
    [self.navigationController popViewControllerAnimated:YES];
}


-(void)infoPressed:(UIBarButtonItem *)sender
{
    
    //robo!
}

- (void) setButtonColors
{
    ColorSingleton *colors = [ColorSingleton getInstance];
    
    buttonDelay.imageView.image =[  buttonDelay.imageView.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    buttonDelay.tintColor = colors.cc6666;
    
    buttonReverb.imageView.image =[  buttonReverb.imageView.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    buttonReverb.tintColor = colors.cc3333;
    
    buttonHarmony.imageView.image =[  buttonHarmony.imageView.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    buttonHarmony.tintColor = colors.c993333;
    
    buttonScale.imageView.image =[  buttonScale.imageView.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    buttonScale.tintColor = colors.c660000;
    
    buttonSource.imageView.image =[  buttonSource.imageView.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    buttonSource.tintColor = colors.ff6666;
    
    //buttonHelp.imageView.image =[  buttonHelp.imageView.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    //buttonHelp.tintColor = colors.greyinfo;
  
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)helpPressed:(UIButton *)sender {
    
    RNBlurModalView *modal = [[RNBlurModalView alloc] initWithViewController:self
                                                                       title:@"Effects" message:@"Select an effect button to load the available effects. set the effects as desired and use the user presets (long press) to save the current state."
                                                                    fontSize:screenHelper.modalFontSize
                                                                       width:screenHelper.modalWidth];
    [modal show];

}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    ViewControllerEffects *viewControllerEffects = [segue destinationViewController];

     // selectedEffect = (UIButton)sender.tag;
    
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if([segue.identifier isEqualToString:@"segueEffects"])
    {
          viewControllerEffects.uiViewName = segue.identifier;
       // viewControllerEffects.uiViewName = @"EffectView";
        
      
    }
    else{
          viewControllerEffects.uiViewName = @"EffectView";
    }
    
}


@end
