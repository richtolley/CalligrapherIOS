//
//  CCInkConfigViewController.m
//  Calligrapher
//
//  Created by Richard Tolley on 09/11/2012.
//  Copyright (c) 2012 Richard Tolley. All rights reserved.
//

#import "CCInkConfigViewController.h"
#import "CCInkColorsViewController.h"
#import "UIColor+AppColors.h"
#import "CCSavedDefaults.h"
#import "CCColorWellView.h"
@interface CCInkConfigViewController ()

@end

@implementation CCInkConfigViewController



- (void)viewDidLoad
{
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(tableViewInkColorChanged:) name:@"tableViewInkColorChanged" object:nil];
	
}

-(void)awakeFromNib
{   [self colorTypeChoiceChanged:nil];
    [self colorChooserTypeChanged:nil];
    
    self.view.backgroundColor = [UIColor paperBackgroundColor];
    self.customColorsView.backgroundColor = [UIColor paperBackgroundColor];
    

    
    
}

-(void)viewDidAppear:(BOOL)animated
{
    
    
    self.colorWell.backgroundColor = self.currentColor = self.defaults.lastInkColor;
    [self setRgbValsForColor:self.currentColor];
    
    [super viewDidAppear:animated];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)sliderValueChanged:(id)sender
{
    self.red = self.redSlider.value;
    self.green = self.greenSlider.value;
    self.blue = self.blueSlider.value;
    self.alpha = self.alphaSlider.value;
    [self refreshColorWell];
    
    [self deselectTableViewColorSelection];
    [self updateLabels];
}

-(void)deselectTableViewColorSelection
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setValue:[NSNumber numberWithInt:-1] forKey:@"standardColorsTableViewLastIndexPath"];
    [defaults synchronize];
    
}

-(void)refreshColorWell
{
    self.colorWell.backgroundColor = [UIColor colorWithRed:self.red green:self.green blue:self.blue alpha:1.0];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"inkColorChanged" object:self];
    [self deselectTableViewColorSelection];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"CustomInkColorSelectionMade" object:self];
    [self.defaults setLastInkColor:self.currentColor];
}

-(void)tableViewInkColorChanged:(NSNotification*)notification
{
    CCInkColorsViewController *tableViewController = (CCInkColorsViewController*)notification.object;
    [self setColorFromTableView:tableViewController.currentColor];
    
}

-(void)setColorFromTableView:(UIColor*)newColor
{
    [self setRgbValsForColor:newColor];
    self.colorWell.backgroundColor = newColor;
    [self.defaults setLastInkColor:newColor];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"inkColorChanged" object:self];
}








@end
