//
//  UIView+ThumbnailCreator.m
//  Calligrapher
//
//  Created by Richard Tolley on 23/11/2012.
//  Copyright (c) 2012 Richard Tolley. All rights reserved.
//

#import "UIView+ThumbnailCreator.h"
#import <QuartzCore/QuartzCore.h>
@implementation UIView (ThumbnailCreator)

-(UIImage*)createThumbnailOfSize:(CGSize)size
{
    UIImage *viewAsImage = [self createImageFromView];
    return [self scaleImage:viewAsImage toSize:size];
}

-(UIImage*)scaleImage:(UIImage*)image toSize:(CGSize)destinationSize
{   
    UIGraphicsBeginImageContext(destinationSize);
    [image drawInRect:CGRectMake(0, 0, destinationSize.width, destinationSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

-(UIImage*)createImageFromView
{
    CGSize size = self.bounds.size;
    UIGraphicsBeginImageContext(size);
    [[self layer]renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}


@end
