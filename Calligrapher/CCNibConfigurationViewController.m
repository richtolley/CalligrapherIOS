//
//  CCNibConfigurationViewController.m
//  Calligrapher
//
//  Created by Richard Tolley on 17/11/2012.
//  Copyright (c) 2012 Richard Tolley. All rights reserved.
//

#import "CCNibConfigurationViewController.h"
#import "CCNibConfigurationView.h"
#import "CCNibView.h"

@interface CCNibConfigurationViewController ()

@end

@implementation CCNibConfigurationViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewDidAppear:(BOOL)animated
{
    double lastNibAngle = [self lastNibAngle];
    _nibView.transform = CGAffineTransformMakeRotation(lastNibAngle);
    _nibConfigView.nibAngleRad = _nibView.nibAngleRad = lastNibAngle;
    _nibView.nibWidth = [self lastNibWidth];
    [_nibView setNeedsDisplay];
    _nibSelectionStyle = kPresetStyleNibSelection;
    [_nibConfigView updateLabel];
    
}

-(double)lastNibAngle
{
    double lastNibAngleDeg = [[NSUserDefaults standardUserDefaults] doubleForKey:@"LastNibAngle"];
    return -DEGTORAD(lastNibAngleDeg); //The UIKit drawing system has an inverted y-axis, so the sign of the degree angle has to be flipped in order to draw the nib correctly
}

-(double)lastNibWidth
{   
    double lastNibWidth=  [[NSUserDefaults standardUserDefaults]doubleForKey:@"LastNibWidth"];
    return lastNibWidth;
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

-(IBAction)scriptSelectionTypeChanged:(id)sender
{
    _nibSelectionStyle = _nibSelectionStyle == kPresetStyleNibSelection ? kCustomStyleNibSelection : kPresetStyleNibSelection;
    if (_nibSelectionStyle == kPresetStyleNibSelection) {
        _nibTableView.hidden = NO;
        _nibConfigView.hidden = YES;
        
    }
    else if(_nibSelectionStyle == kCustomStyleNibSelection) //defensive, in case more options are added later
    {
        _nibTableView.hidden = YES;
        _nibConfigView.hidden = NO;
        double lastNibAngle = [self lastNibAngle];
        _nibView.transform = CGAffineTransformMakeRotation(lastNibAngle);
        _nibConfigView.nibAngleRad = _nibView.nibAngleRad = lastNibAngle;
        [_nibConfigView updateLabel];
        
    }
}

@end
