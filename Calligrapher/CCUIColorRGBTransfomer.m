//
//  CCUIColorRGBTransfomer.m
//  Calligrapher
//
//  Created by Richard Tolley on 27/11/2012.
//  Copyright (c) 2012 Richard Tolley. All rights reserved.
//

#import "CCUIColorRGBTransfomer.h"

@implementation CCUIColorRGBTransfomer

+(Class)transformedValueClass
{
    return [NSData class];
}

+(BOOL)allowsReverseTransformation
{
    return YES;
}


-(id)transformedValue:(id)value
{
    UIColor *color = value;
    const CGFloat *components = CGColorGetComponents(color.CGColor);
    NSString *colorAsString = [NSString stringWithFormat:@"%f,%f,%f,%f",components[0],components[1],components[2],components[3]];
    return [colorAsString dataUsingEncoding:NSUTF8StringEncoding];
}


-(id)reverseTransformedValue:(id)value
{
    NSString *colorAsString = [[NSString alloc]initWithData:value encoding:NSUTF8StringEncoding];
    NSArray *components = [colorAsString componentsSeparatedByString:@","];
    CGFloat r,g,b,a;
    r = g = b = a = 0.0;
    CGFloat comps[] = {r,g,b,a};
    for(int i=0;i<4;i++)
        comps[i] = [components[i] floatValue];
    
    return [UIColor colorWithRed:r green:g blue:b alpha:a];
}
@end
