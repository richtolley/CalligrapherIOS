//
//  UIColor+ColorLogger.m
//  Calligrapher
//
//  Created by Richard Tolley on 30/11/2012.
//  Copyright (c) 2012 Richard Tolley. All rights reserved.
//

#import "UIColor+ColorLogger.h"

@implementation UIColor (ColorLogger)

-(void)logColorComponents
{
    CGFloat r,g,b,a;
    r = g = b = a = -1.0;
    [self getRed:&r green:&g blue:&b alpha:&a];
    NSLog(@"Color components for %@",self.description);
    printf("Red: %f\n",r);
    printf("Green: %f\n",g);
    printf("Blue: %f\n",b);
    printf("Alpha: %f\n",a);
}

@end
