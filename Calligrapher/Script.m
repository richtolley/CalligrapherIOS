//
//  Script.m
//  Calligrapher
//
//  Created by Richard Tolley on 27/11/2012.
//  Copyright (c) 2012 Richard Tolley. All rights reserved.
//

#import "Script.h"
#import "Manuscript.h"
#import "Page.h"
#import "Stroke.h"
#import "CCAppDelegate.h"

@implementation Script

@dynamic paperColorVal;
@dynamic manuscript;
@dynamic strokes;
@dynamic page;


-(void)clear
{
    [self removeStrokes:self.strokes];
}

@end
