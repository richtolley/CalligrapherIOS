//
//  UIColor+AppColors.m
//  Calligrapher
//
//  Created by Richard Tolley on 14/11/2012.
//  Copyright (c) 2012 Richard Tolley. All rights reserved.
//

#import "UIColor+AppColors.h"

@implementation UIColor (AppColors)
+(UIColor*)paperBackgroundColor
{
    return [UIColor colorWithRed:248.0/255.0 green:240/255.0 blue:219.0/255.0 alpha:1.0];
}

-(void)logColorComponents
{
    CGFloat r,g,b,a;
    [self getRed:&r green:&g blue:&b alpha:&a];
    NSLog(@"Color components are red: %.2f,green: %.2f,blue: %.2f,alpha: %.2f",r,g,b,a);
}


@end
