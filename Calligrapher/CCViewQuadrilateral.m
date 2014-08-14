//
//  CCViewQuadrilateral.m
//  Calligrapher
//
//  Created by Richard Tolley on 22/01/2013.
//  Copyright (c) 2013 Richard Tolley. All rights reserved.
//

#import "CCViewQuadrilateral.h"

@implementation CCViewQuadrilateral

- (id)initWithTopLeft:(CGPoint)tl topRight:(CGPoint)tr bottomLeft:(CGPoint)bl bottomRight:(CGPoint)br
{
    self = [super init];
    if (self) {
        _topLeft = tl;
        _topRight = tr;
        _bottomLeft = bl;
        _bottomRight = br;
    }
    return self;
}
-(CGRect)boundingRect
{
    CGPoint origin;
    origin.x = MIN(_topLeft.x, _bottomLeft.x);
    origin.y = MIN(_bottomRight.y,_bottomLeft.y);
    CGSize size;
    CGFloat rightMost = MAX(_topRight.x, _bottomRight.x);
    CGFloat topMost = MAX(_topLeft.y,_topRight.y);
    size.width = rightMost - origin.x;
    size.height = topMost - origin.y;
    return CGRectMake(origin.x, origin.y, size.width, size.height);
}
@end
