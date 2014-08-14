//
//  CCPaperColorsTableViewController.m
//  Calligrapher
//
//  Created by Richard Tolley on 18/11/2012.
//  Copyright (c) 2012 Richard Tolley. All rights reserved.
//

#import "CCPaperColorsTableViewController.h"
#import "CCColorTableViewCell.h"
#import "UIColor+AppColors.h"
@interface CCPaperColorsTableViewController ()

@end

@implementation CCPaperColorsTableViewController

- (void)viewDidLoad
{
    
    _colorDict = @{
            @"White" : [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0],
            @"Cream" : [UIColor paperBackgroundColor],
            @"Pink" : [UIColor colorWithRed:1.0 green:0.84 blue:0.84 alpha:1.0],
            @"Light Grey" : [UIColor colorWithRed:0.98 green:0.98 blue:0.98 alpha:1.0],
            @"Grey":[UIColor colorWithRed:0.67 green:0.67 blue:0.67 alpha:1.0],
            @"Dark Grey":[UIColor colorWithRed:0.33 green:0.33 blue:0.33 alpha:1.0],
            @"Black":[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:1.0],
            @"Dark blue":[UIColor colorWithRed:0.0 green:0.0 blue:0.5 alpha:1.0]
            };
    self.view.backgroundColor = [UIColor paperBackgroundColor];

    _userDefaultsKeyString = @"paperColorsTableViewLastIndexPath";
    _notificationPostedNameString = @"tableViewPaperColorChanged";
    _customSelectionNotificationString = @"CustomPaperColorSelectionMade";
    [super viewDidLoad];
}


@end
