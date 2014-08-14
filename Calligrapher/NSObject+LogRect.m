//
//  NSObject+LogRect.m
//  Calligrapher
//
//  Created by Richard Tolley on 30/11/2012.
//  Copyright (c) 2012 Richard Tolley. All rights reserved.
//

#import "NSObject+LogRect.h"

@implementation NSObject (LogRect)

-(void)logRect:(CGRect)rect withName:(NSString*)name
{
    NSLog(@"Rect %@ x: %f y %f w %f h %f",name,rect.origin.x,rect.origin.y,rect.size.width,rect.size.height);
}

@end
