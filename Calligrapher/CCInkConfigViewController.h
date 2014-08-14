//
//  CCInkConfigViewController.h
//  Calligrapher
//
//  Created by Richard Tolley on 09/11/2012.
//  Copyright (c) 2012 Richard Tolley. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CCAbstractColorConfigViewController.h"

@class CCSavedDefaults;
@class CCColorsTableViewController;
@interface CCInkConfigViewController : CCAbstractColorConfigViewController
@property (nonatomic,strong) CCSavedDefaults *defaults;
@property (nonatomic,strong) IBOutlet CCColorsTableViewController *tableViewController;
@end
