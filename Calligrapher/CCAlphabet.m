//
//  CCAlphabet.m
//  Calligrapher
//
//  Created by Richard Tolley on 22/11/2012.
//  Copyright (c) 2012 Richard Tolley. All rights reserved.
//

#import "CCAlphabet.h"

@implementation CCAlphabet

-(id)initWithFileName:(NSString*)fileName
{
    self = [super init];
    if (self) {
       NSData *alphabetData = [[NSData alloc]initWithContentsOfFile:fileName];
       NSError *error = nil;
       _letters = [NSJSONSerialization JSONObjectWithData:alphabetData options:NSJSONReadingMutableLeaves error:&error];
       
    }
    return self;
}


@end
