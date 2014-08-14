//
//  CCNibView.h
//  Calligrapher
//
//  Created by Richard Tolley on 15/11/2012.
//  Copyright (c) 2012 Richard Tolley. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CCNibConfigurationType.h"
@interface CCNibView : UIView
{
    double _nibWidth, _minNibWidth, _maxNibWidth;
    UIColor *_nibColor;
    UIColor *_leftShadow;
    UIColor *_rightShadow;
    
    CCNibConfigurationType _type;
}
@property CCNibConfigurationType type;
@property double nibWidth;
@property double nibAngleRad;
@property (readonly) double nibAngleDeg;
@end
