//
//  StrokeQuad.m
//  Calligrapher
//
//  Created by Richard Tolley on 25/01/2013.
//  Copyright (c) 2013 Richard Tolley. All rights reserved.
//

#import "StrokeQuad.h"
#import "Stroke.h"
#import "OGLDrawingTypes.h"
#import "NSObject+OGLQuadMethods.h"

@implementation StrokeQuad
{
    CGRect _boundingRect;
    bool _boundingRectSet;
}
@dynamic nibAngle;
@dynamic nibWidth;
@dynamic point1X;
@dynamic point1Y;
@dynamic sequence;
@dynamic point2X;
@dynamic point2Y;
@dynamic stroke;

-(void)awakeFromFetch
{
    [super awakeFromFetch];
    _boundingRectSet = FALSE;
}


-(NSString*)key
{
    return [NSString stringWithFormat:@"Quad%d",self.sequence];
}

-(CGPoint)point1
{
    return CGPointMake(self.point1X, self.point1Y);
}

-(void)setPoint1:(CGPoint)point1
{
    self.point1X = point1.x;
    self.point1Y = point1.y;
    [self clearBoundingRect];
}

-(CGPoint)point2
{
    return CGPointMake(self.point2X, self.point2Y);
}

-(void)setPoint2:(CGPoint)point2
{
    self.point2X = point2.x;
    self.point2Y = point2.y;
    [self clearBoundingRect];
}

-(void)clearBoundingRect
{
    _boundingRect = CGRectMake(UNINIT_BOUNDS_VAL, UNINIT_BOUNDS_VAL, UNINIT_BOUNDS_VAL, UNINIT_BOUNDS_VAL);
}


-(CGPoint)leftPointForPt:(CGPoint)point
{
    CGPoint offset = [self sidePointOffset];
    return CGPointMake(point.x - offset.x,point.y - offset.y);
    
}

-(CGPoint)rightPointForPt:(CGPoint)point
{
    CGPoint offset = [self sidePointOffset];
    return CGPointMake(point.x + offset.x,point.y + offset.y);
}

-(CGPoint)sidePointOffset
{
    double rotAngle = 90 + self.nibAngle;
    CGPoint offsetPt;
    offsetPt.x = sin(DEGTORAD(rotAngle)) * (self.nibWidth/2.0);
    offsetPt.y = cos(DEGTORAD(rotAngle)) * (self.nibWidth/2.0);
    
    return offsetPt;
}

-(CGRect)boundingRect
{
    if(!_boundingRectSet)
    {
        CGPoint topLeft = [self leftPointForPt:self.point1];
        CGPoint topRight = [self rightPointForPt:self.point1];
        CGPoint bottomLeft = [self leftPointForPt:self.point2];
        CGPoint bottomRight = [self rightPointForPt:self.point2];
        
        CGPoint origin;
        origin.x = MIN(topLeft.x,bottomLeft.x);
        origin.y = MIN(bottomRight.y,bottomLeft.y);
        CGSize size;
        CGFloat rightMost = MAX(topRight.x,bottomRight.x);
        CGFloat topMost = MAX(topLeft.y,topRight.y);
        size.width = rightMost - origin.x;
        size.height = topMost - origin.y;
        _boundingRect =  CGRectMake(origin.x, origin.y, size.width, size.height);
        _boundingRectSet = TRUE;
    }
    
    return _boundingRect;
}

-(OGLQuadrilateral)oglQuad
{
    
    CGPoint tl = [self leftPointForPt:self.point1];
    CGPoint tr = [self rightPointForPt:self.point1];
    CGPoint bl = [self leftPointForPt:self.point2];
    CGPoint br = [self rightPointForPt:self.point2];
    return [self makeOGLQuadWithTopLeft:tl topRight:tr bottomLeft:bl bottomRight:br];
}

@end
