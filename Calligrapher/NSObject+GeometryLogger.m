//
//  NSObject+GeometryLogger.m
//  Calligrapher
//
//  Created by Richard Tolley on 21/01/2013.
//  Copyright (c) 2013 Richard Tolley. All rights reserved.
//

#import "NSObject+GeometryLogger.h"

@implementation NSObject (GeometryLogger)
-(void)logRect:(CGRect)r name:(NSString*)name
{
    NSLog(@"Rect: %@ x %f y %f w %f h %f",name,r.origin.x,r.origin.y,r.size.width,r.size.height);
}

-(void)logPoint:(CGPoint)r name:(NSString*)name
{
    NSLog(@"Point: %@ x %f y %f",name,r.x,r.y);
}

-(void)logSize:(CGSize)r name:(NSString*)name
{
    NSLog(@"Size: %@ w %f h %f",name,r.width,r.height);
}

@end
