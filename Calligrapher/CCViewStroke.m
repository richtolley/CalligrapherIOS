//
//  CCViewStroke.m
//  Calligrapher
//
//  Created by Richard Tolley on 04/12/2012.
//  Copyright (c) 2012 Richard Tolley. All rights reserved.
//

#import "CCViewStroke.h"
#import "CCViewStrokePoint.h"
#import "CCViewQuadrilateral.h"
#define UNINITIALIZED_PT -50000
@implementation CCViewStroke

- (id)init
{
    self = [super init];
    if (self) {
         _strokePaths = [[NSMutableArray alloc]init];
         _lastPt = CGPointMake(UNINITIALIZED_PT, UNINITIALIZED_PT);
         _strokeSequenceNo = 0;
    }
    return self;
}


-(id)initWithPointArray:(NSMutableArray*)points
{
    self = [self init];
    if (self) {
        
        for(int i=0;i<_points.count;i++)
        {
            if(i >= 1)
            {   
                CCViewQuadrilateral *newQuad = [self quadBetweenStartPoint:self.points[i-1] andFinishPoint:self.points[i]];
                [_strokePaths addObject:newQuad];
                newQuad.key = [NSString stringWithFormat:@"Stroke%dQuad%d",self.strokeSequenceNo,_strokePaths.count-1];
            }
        }
    }
    return self;
}



-(int)numPts
{
    return self.points.count;
}

-(void)addStrokePoint:(CCViewStrokePoint*)sPt
{
    if(self.points == nil)
    {    _points = [[NSMutableArray alloc]init];
         _lastPt = CGPointMake(sPt.point.x, sPt.point.y);
    
    }
    [self.points addObject:sPt];
    if(self.points.count > 1)
    {
        int lastIndex = self.points.count - 1;
        
        CCViewQuadrilateral *newQuad = [self quadBetweenStartPoint:self.points[lastIndex-1] andFinishPoint:self.points[lastIndex]];
        [_strokePaths addObject:newQuad];
        newQuad.key = [NSString stringWithFormat:@"Stroke%dQuad%d",self.strokeSequenceNo,_strokePaths.count-1];
    }
    
}



-(NSMutableArray*)strokePaths
{
    return _strokePaths;
}

-(UIBezierPath*)bezierPathBetweenStartPoint:(CCViewStrokePoint*)pt1 andFinishPoint:(CCViewStrokePoint*)pt2
{
    UIBezierPath *newPath = [[UIBezierPath alloc]init];
    newPath.lineWidth = 2.0;
    
    [newPath moveToPoint:pt1.leftPoint];
    [newPath addLineToPoint:pt1.point];
    [newPath addLineToPoint:pt1.rightPoint];
   
    [newPath addLineToPoint:pt2.rightPoint];
    [newPath addLineToPoint:pt2.point];
    [newPath addLineToPoint:pt2.leftPoint];
    
    [newPath closePath];
    return newPath;
    
}

-(CCViewQuadrilateral*)lastQuadInStroke
{
    
    if(_strokePaths != nil && _strokePaths.count > 0)
    {
        return _strokePaths.lastObject;
    
    }
    else return nil;
}

-(CCViewQuadrilateral*)quadBetweenStartPoint:(CCViewStrokePoint*)pt1 andFinishPoint:(CCViewStrokePoint*)pt2
{
    return [[CCViewQuadrilateral alloc]initWithTopLeft:pt1.leftPoint topRight:pt1.rightPoint bottomLeft:pt2.leftPoint bottomRight:pt2.rightPoint];
}


-(CGRect)strokeRect
{
    CGPoint minPt,maxPt;
    minPt = maxPt = [(CCViewStrokePoint*)self.points[0] point];
    for(CCViewStrokePoint *sPt in self.points)
    {
        minPt.x = sPt.point.x < minPt.x ? sPt.point.x : minPt.x;
        maxPt.x = sPt.point.x > maxPt.x ? sPt.point.x : maxPt.x;
        minPt.y = sPt.point.y < minPt.y ? sPt.point.y : minPt.y;
        maxPt.y = sPt.point.y > maxPt.y ? sPt.point.y : maxPt.y;
        
        minPt.x = sPt.leftPoint.x < minPt.x ? sPt.leftPoint.x : minPt.x;
        maxPt.x = sPt.leftPoint.x > maxPt.x ? sPt.leftPoint.x : maxPt.x;
        minPt.y = sPt.leftPoint.y < minPt.y ? sPt.leftPoint.y : minPt.y;
        maxPt.y = sPt.leftPoint.y > maxPt.y ? sPt.leftPoint.y : maxPt.y;
        
        minPt.x = sPt.rightPoint.x < minPt.x ? sPt.rightPoint.x : minPt.x;
        maxPt.x = sPt.rightPoint.x > maxPt.x ? sPt.rightPoint.x : maxPt.x;
        minPt.y = sPt.rightPoint.y < minPt.y ? sPt.rightPoint.y : minPt.y;
        maxPt.y = sPt.rightPoint.y > maxPt.y ? sPt.rightPoint.y : maxPt.y;
    }
    return CGRectMake(minPt.x, minPt.y, maxPt.x-minPt.x, maxPt.y-minPt.y);
}

-(bool)intersectsViewRect:(CGRect)viewRect
{
    for(CCViewStrokePoint *sPt in self.points)
    {
        if(CGRectContainsPoint(viewRect, [sPt point]))
            return true;
    }
    return false;
}

@end
