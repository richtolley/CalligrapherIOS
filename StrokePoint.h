//
//  StrokePoint.h
//  Calligrapher
//
//  Created by Richard Tolley on 25/01/2013.
//  Copyright (c) 2013 Richard Tolley. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Stroke;

@interface StrokePoint : NSManagedObject

@property (nonatomic) double nibAngle;
@property (nonatomic) double nibWidth;
@property (nonatomic) float point1X;
@property (nonatomic) float point1Y;
@property (nonatomic) int32_t sequence;
@property (nonatomic) float point2X;
@property (nonatomic) float point2Y;
@property (nonatomic, retain) Stroke *stroke;

@end
