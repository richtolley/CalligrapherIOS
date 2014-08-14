//
//  CCCoordinateConverter.m
//  Calligrapher
//
//  Created by Richard Tolley on 21/01/2013.
//  Copyright (c) 2013 Richard Tolley. All rights reserved.
//

#import "CCCoordinateConverter.h"
#import "NSObject+OGLQuadMethods.h"
@implementation CCCoordinateConverter

- (id)initWithScreenRect:(CGRect)screenRect zVal:(CGFloat)z fovyRad:(CGFloat)fovyRad
{
	if((self = [super init]))
	{
		_tanVal = tan(fovyRad/2.0);
		_aspectVal = screenRect.size.width/screenRect.size.height;
		_zVal = z;
		self.screenRect = screenRect;
		
	}
	return self;
}

-(CGRect)refreshGLRect;
{
	CGFloat halfH = _tanVal * _zVal;
	CGFloat halfW = halfH * _aspectVal;
	CGFloat x = 0 - halfW;
	CGFloat y = 0 - halfH;
	return CGRectMake(x,y,halfW*2,halfH*2);
}

-(CGRect)screenRect
{
	return _screenRect;
}

-(void)setScreenRect:(CGRect)screenRect
{   
	_screenRect = screenRect;
    _aspectVal = _screenRect.size.width/_screenRect.size.height;
	_glRect = [self refreshGLRect];
}

-(CGPoint)screenPtToOGLPt:(CGPoint)screenPt
{
    
    
    CGPoint percentPt = [self percentagePtFromPt:screenPt inRect:_screenRect];
    percentPt.y = [self flipPercentageVal:percentPt.y]; //y coord inverted between CocoaTouch and OGL
    
    return [self ptWithPercentagePt:percentPt inRect:_glRect];
}

-(CGPoint)percentagePtFromPt:(CGPoint)pt inRect:(CGRect)rect
{
    CGPoint rVal = CGPointMake(-1.0, -1.0); //default init with error value
    CGFloat x = pt.x - rect.origin.x;
    CGFloat y = pt.y - rect.origin.y;
    rVal = CGPointMake(x/rect.size.width, y/rect.size.height);
    
    return rVal;
}

-(CGPoint)ptWithPercentagePt:(CGPoint)pt inRect:(CGRect)rect
{   
    CGFloat x = rect.origin.x + (pt.x * rect.size.width);
    CGFloat y = rect.origin.y + (pt.y * rect.size.height);
    return CGPointMake(x, y);
}

-(CGFloat)flipPercentageVal:(CGFloat)val
{
    return 1.0 - val;
}


-(OGLQuadrilateral)convertViewQuadToOGL:(OGLQuadrilateral)toConvert;
{
    CGPoint tl = [self screenPtToOGLPt:toConvert.topLeft];
    CGPoint tr = [self screenPtToOGLPt:toConvert.topRight];
    CGPoint bl = [self screenPtToOGLPt:toConvert.bottomLeft];
    CGPoint br = [self screenPtToOGLPt:toConvert.bottomRight];
    return [self makeOGLQuadWithTopLeft:tl topRight:tr bottomLeft:bl bottomRight:br];
}


@end

