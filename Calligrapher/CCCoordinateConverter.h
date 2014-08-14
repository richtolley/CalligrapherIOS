//
//  CCCoordinateConverter.h
//  Calligrapher
//
//  Created by Richard Tolley on 21/01/2013.
//  Copyright (c) 2013 Richard Tolley. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OGLDrawingTypes.h"
@interface CCCoordinateConverter : NSObject
{
	CGFloat _tanVal;
	CGFloat _zVal;
	CGFloat _aspectVal;
	CGRect _screenRect;
	CGRect _glRect;
}
@property CGRect screenRect;
@property CGRect glRect;
-(id)initWithScreenRect:(CGRect)screenRect zVal:(CGFloat)z fovyRad:(CGFloat)fovyRad;
-(CGPoint)screenPtToOGLPt:(CGPoint)screenPt;
-(OGLQuadrilateral)convertViewQuadToOGL:(OGLQuadrilateral)toConvert;

@end