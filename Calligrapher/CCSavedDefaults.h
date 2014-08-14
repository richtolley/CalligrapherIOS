//
//  CCSavedDefaults.h
//  Calligrapher
//
//  Created by Richard Tolley on 04/12/2012.
//  Copyright (c) 2012 Richard Tolley. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CCSavedDefaults : NSObject

@property (nonatomic,strong) NSString *lastMSName;
@property (nonatomic,strong) NSString *lastStyleName;
@property double lastNibWidth;
@property double lastNibAngle; //need to be able to tell the difference between a nib angle of 0º and uninitialized value
@property (nonatomic,strong) UIColor *lastInkColor;
@property (nonatomic,strong) UIColor *lastPaperColor;
@end
