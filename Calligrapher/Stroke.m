//
//  Stroke.m
//  Calligrapher
//
//  Created by Richard Tolley on 25/01/2013.
//  Copyright (c) 2013 Richard Tolley. All rights reserved.
//

#import "Stroke.h"
#import "Manuscript.h"
#import "StrokeQuad.h"


@implementation Stroke

@dynamic inkColorVal;
@dynamic sequence;
@dynamic quads;
@dynamic manuscript;

-(NSString*)key
{
    return [NSString stringWithFormat:@"Stroke%d",self.sequence];
}

@end
