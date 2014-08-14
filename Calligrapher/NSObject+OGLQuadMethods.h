//
//  NSObject+OGLQuadMethods.h
//  Calligrapher
//
//  Created by Richard Tolley on 25/01/2013.
//  Copyright (c) 2013 Richard Tolley. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OGLDrawingTypes.h"
@interface NSObject (OGLQuadMethods)
-(OGLQuadrilateral)makeOGLQuadWithTopLeft:(CGPoint)tl topRight:(CGPoint)tr bottomLeft:(CGPoint)bl bottomRight:(CGPoint)br;
-(OGLQuadrilateral)blankQuad;
-(bool)quadValid:(OGLQuadrilateral)ogQuad;
-(void)makeQuadrilateralForPoints:(CGPoint)br tr:(CGPoint)tr tl:(CGPoint)tl bl:(CGPoint)bl zVal:(CGFloat)zVal color:(UIColor *)color vertex:(Vertex *)v;
-(void)printVertex:(Vertex *)v;
@end
