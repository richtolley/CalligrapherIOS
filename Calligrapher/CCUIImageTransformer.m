//
//  CCUIImageTransformer.m
//  Calligrapher
//
//  Created by Richard Tolley on 27/11/2012.
//  Copyright (c) 2012 Richard Tolley. All rights reserved.
//

#import "CCUIImageTransformer.h"

@implementation CCUIImageTransformer
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

    if(value == nil)
        return nil;
    UIImage *image = value;
    return UIImagePNGRepresentation(image);
    
}


-(id)reverseTransformedValue:(id)value
{
    return [UIImage imageWithData:(NSData*)value];
}
@end
