//
//  CCViewStrokePoint.h
//  Calligrapher
//
//  Created by Richard Tolley on 04/12/2012.
//  Copyright (c) 2012 Richard Tolley. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CCViewStrokePoint : NSObject

@property double nibWidth;
@property double nibAngle;
@property CGPoint point;
@property (readonly) CGPoint leftPoint;
@property (readonly) CGPoint rightPoint;
-(id)initWithWidth:(double)w Angle:(double)a andPoint:(CGPoint)point;
@end
