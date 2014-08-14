//
//  NSObject+ForegroundColorForBackgroundColor.m
//  Calligrapher
//
//  Created by Richard Tolley on 01/12/2012.
//  Copyright (c) 2012 Richard Tolley. All rights reserved.
//

#import "NSObject+ForegroundColorForBackgroundColor.h"

@implementation NSObject (ForegroundColorForBackgroundColor)


-(UIColor*)foregroundColorForBackgroundColor:(UIColor*)backgroundColor
{
        const CGFloat *componentColors = CGColorGetComponents(backgroundColor.CGColor);
        CGFloat colorBrightness = ((componentColors[0] * 299) + (componentColors[1] * 587) + (componentColors[2] * 114))/1000;
        if(colorBrightness < 0.5)
                return [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0];
        else    return [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:1.0];
    
}

@end
