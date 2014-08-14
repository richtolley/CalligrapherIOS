//
//  CCPaperConfigViewController.m
//  Calligrapher
//
//  Created by Richard Tolley on 17/11/2012.
//  Copyright (c) 2012 Richard Tolley. All rights reserved.
//

#import "CCPaperConfigViewController.h"
#import "CCPaperColorsTableViewController.h"
#import "CCSavedDefaults.h"
#import "CCColorWellView.h"
@interface CCPaperConfigViewController ()

@end

@implementation CCPaperConfigViewController



- (void)viewDidLoad
{
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(setColorFromTableView:) name:@"tableViewPaperColorChanged" object:nil];
    
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidAppear:(BOOL)animated
{
    self.colorWell.backgroundColor = self.currentColor = [self.defaults lastPaperColor];
    [self setRgbValsForColor:self.currentColor];
    
    [super viewDidAppear:animated];
    
}



-(void)awakeFromNib
{   [self colorTypeChoiceChanged:nil];
    [self colorChooserTypeChanged:nil];
    self.view.backgroundColor = [UIColor paperBackgroundColor];
    self.customColorsView.backgroundColor = [UIColor paperBackgroundColor];
}


-(void)refreshColorWell
{
    [super refreshColorWell];
    UIColor *newColor = [UIColor colorWithRed:self.red green:self.green blue:self.blue alpha:1.0];
    
    self.currentColor = newColor;
    self.colorWell.backgroundColor = newColor;
    [self.defaults setLastPaperColor:self.currentColor];
    [self deselectTableViewColorSelection];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"CustomPaperColorSelectionMade" object:self];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"paperColorChanged" object:self];
    
}

-(void)deselectTableViewColorSelection
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setValue:[NSNumber numberWithInt:-1] forKey:@"paperColorsTableViewLastIndexPath"];
    [defaults synchronize];
}


-(void)setColorFromTableView:(NSNotification*)notification
{
    CCPaperColorsTableViewController *paperColorTableViewController = (CCPaperColorsTableViewController*)notification.object;
    UIColor *newColor = paperColorTableViewController.currentColor;
    [self setRgbValsForColor:newColor];
    self.colorWell.backgroundColor = newColor;
    [self.defaults setLastPaperColor:self.currentColor];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"paperColorChanged" object:self];
}

@end
