//
//  NSObject+OGLQuadMethods.m
//  Calligrapher
//
//  Created by Richard Tolley on 25/01/2013.
//  Copyright (c) 2013 Richard Tolley. All rights reserved.
//

#import "NSObject+OGLQuadMethods.h"

@implementation NSObject (OGLQuadMethods)

-(OGLQuadrilateral)makeOGLQuadWithTopLeft:(CGPoint)tl topRight:(CGPoint)tr bottomLeft:(CGPoint)bl bottomRight:(CGPoint)br
{
    OGLQuadrilateral rVal;
    rVal.topLeft = tl;
    rVal.topRight = tr;
    rVal.bottomLeft = bl;
    rVal.bottomRight = br;
    return rVal;
}

-(OGLQuadrilateral)blankQuad
{
    CGPoint unPt = CGPointMake(UNINIT_QUADS_VAL, UNINIT_QUADS_VAL);
    return [self makeOGLQuadWithTopLeft:unPt topRight:unPt bottomLeft:unPt bottomRight:unPt];
}

-(bool)quadValid:(OGLQuadrilateral)ogQuad
{
    return ogQuad.topLeft.x != UNINIT_QUADS_VAL;
}

-(void)makeQuadrilateralForPoints:(CGPoint)br tr:(CGPoint)tr tl:(CGPoint)tl bl:(CGPoint)bl zVal:(CGFloat)zVal color:(UIColor *)color vertex:(Vertex *)v
{
    CGFloat r,g,b,a;
    [color getRed:&r green:&g blue:&b alpha:&a];
    
    Vertex verts[] = {
        {{br.x,br.y,zVal},{r,g,b,a}}, //br
        {{tr.x,tr.y,zVal},{r,g,b,a}}, //tr
        {{tl.x,tl.y,zVal},{r,g,b,a}}, //tl
        {{bl.x,bl.y,zVal},{r,g,b,a}} //bl
    };
    for(int i=0;i<4;i++)
    {
        v[i] = verts[i];
    }
}

-(void)printVertex:(Vertex *)v
{
	int i;
	for(i=0;i<4;i++)
	{
		printf("x:%f, y: %f z: %f\n",v[i].Position[0],v[i].Position[1],v[i].Position[2]);
        printf("Color r: %f g: %f b: %f a: %f\n",v[i].Color[0],v[i].Color[1],v[i].Color[2],v[i].Color[3]);
    }
}

@end
