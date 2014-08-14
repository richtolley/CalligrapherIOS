//
//  OGLDrawingTypes.h
//  Calligrapher
//
//  Created by Richard Tolley on 25/01/2013.
//  Copyright (c) 2013 Richard Tolley. All rights reserved.
//

#ifndef Calligrapher_OGLDrawingTypes_h
#define Calligrapher_OGLDrawingTypes_h

#define UNINIT_BOUNDS_VAL -500
#define UNINIT_QUADS_VAL -600
typedef struct OGLQuadrilateral
{
    CGPoint topLeft;
    CGPoint topRight;
    CGPoint bottomLeft;
    CGPoint bottomRight;
} OGLQuadrilateral;

typedef struct { float Position[3]; float Color[4];
} Vertex;
static const Vertex Vertices[] = {
    {{1, -1, 0}, {1, 0, 0, 1}},
    {{1, 1, 0}, {0, 1, 0, 1}},
    {{-1, 1, 0}, {0, 0, 1, 1}},
    {{-1, -1, 0}, {0, 0, 0, 1}}
};
static const GLushort Indices[] = { 0, 1, 2,
    2, 3, 0 };
/*
const CGFloat sizePosIncrement = 0.1;

const CGFloat Z_MAX = -12;
const CGFloat Z_MIN = -2;
const CGFloat PROJ_MAX = 12;
const CGFloat PROJ_MIN = 1;
*/
#endif
