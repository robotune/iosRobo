//
//  PopupViewController.m
//  RoboTune2
//
//  Created by Alan O'Sullivan on 11/10/2014.
//  Copyright (c) 2014 Alan O'Sullivan. All rights reserved.
//

#import "PopupViewController.h"
#import "UIViewController+ENPopUp.h"

@interface PopupViewController ()

@end

@implementation PopupViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)dismissPressed:(UIButton *)sender {
    //[self dismissPopUpViewController];
    [self dismissPopUpViewController];
    
    /*[self dismissPopUpViewControllerWithcompletion:^{
        [self returnToParentView];
    }];
     */
}

- (void) returnToParentView
{
     UIViewController *vc = [[UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil] instantiateViewControllerWithIdentifier:@"Presets"];
    //[self presentViewController:vc animated:YES completion:nil];
    [self.navigationController pushViewController:vc animated:YES];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
