//
//  CCViewStrokePoint.m
//  Calligrapher
//
//  Created by Richard Tolley on 04/12/2012.
//  Copyright (c) 2012 Richard Tolley. All rights reserved.
//

#import "CCViewStrokePoint.h"

@implementation CCViewStrokePoint
-(id)initWithWidth:(double)nibWidth Angle:(double)nibAngle andPoint:(CGPoint)point
{
    self = [super init];
    if (self) {
        
        _nibAngle = -nibAngle;
        _nibWidth = nibWidth;
        _point = point;
    }
    return self;
}

-(CGPoint)leftPoint
{
    CGPoint offset = [self sidePointOffset];
    return CGPointMake(self.point.x - offset.x, self.point.y - offset.y);
    
}

-(CGPoint)rightPoint
{
    CGPoint offset = [self sidePointOffset];
    return CGPointMake(self.point.x + offset.x, self.point.y + offset.y);
}

-(CGPoint)sidePointOffset
{
    double rotAngle = 90 - self.nibAngle;
    CGPoint offsetPt;
    offsetPt.x = sin(DEGTORAD(rotAngle)) * (self.nibWidth/2.0);
    offsetPt.y = cos(DEGTORAD(rotAngle)) * (self.nibWidth/2.0);
    
    return offsetPt;
}
@end
