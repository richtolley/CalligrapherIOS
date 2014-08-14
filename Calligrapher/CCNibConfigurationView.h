//
//  CCNibConfigurationView.h
//  Calligrapher
//
//  Created by Richard Tolley on 08/11/2012.
//  Copyright (c) 2012 Richard Tolley. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CCNibConfigurationType.h"

@class CCNibView;
@interface CCNibConfigurationView : UIView
{
    IBOutlet UISegmentedControl *_segmentedControl;
    IBOutlet CCNibView *_nibView;
}
@property double nibAngleRad;
@property (readonly) double nibAngleDeg;
@property (readonly) double nibWidth;
-(IBAction)segmentChanged:(id)sender;
-(void)updateLabel;

@end
