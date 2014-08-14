//
//  StrokeQuad.h
//  Calligrapher
//
//  Created by Richard Tolley on 25/01/2013.
//  Copyright (c) 2013 Richard Tolley. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "OGLDrawingTypes.h"
@class Stroke;

@interface StrokeQuad : NSManagedObject

@property (nonatomic,strong,readonly) NSString *key;
@property (nonatomic) double nibAngle;
@property (nonatomic) double nibWidth;
@property (nonatomic) float point1X;
@property (nonatomic) float point1Y;
@property (nonatomic) int32_t sequence;
@property (nonatomic) float point2X;
@property (nonatomic) float point2Y;
@property (nonatomic, retain) Stroke *stroke;
@property CGPoint point1;
@property CGPoint point2;
@property (readonly) CGRect boundingRect;

-(OGLQuadrilateral)oglQuad;

@end
