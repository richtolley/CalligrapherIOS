//
//  CCNibConfigurationViewController.h
//  Calligrapher
//
//  Created by Richard Tolley on 17/11/2012.
//  Copyright (c) 2012 Richard Tolley. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum
{
    kPresetStyleNibSelection,
    kCustomStyleNibSelection
} NibSelectionStyle;

@class CCNibConfigurationView;
@class CCNibView;
@class CCNibScriptStyleTableViewController;
@interface CCNibConfigurationViewController : UIViewController
{
    NibSelectionStyle _nibSelectionStyle;
}
@property (nonatomic,strong) IBOutlet CCNibView *nibView;
@property (nonatomic,strong) IBOutlet CCNibConfigurationView *nibConfigView;
@property (nonatomic,strong) IBOutlet UIView *nibTableView;
@property (nonatomic,strong) IBOutlet CCNibScriptStyleTableViewController *nibTableViewController;
@property (nonatomic,strong) IBOutlet UISegmentedControl *scriptSelectionSegmentedControl;
@end
