//
//  CCViewStroke.h
//  Calligrapher
//
//  Created by Richard Tolley on 04/12/2012.
//  Copyright (c) 2012 Richard Tolley. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CCViewStrokePoint;
@class CCViewQuadrilateral;
@interface CCViewStroke : NSObject
{
    NSMutableArray *_strokePaths;
    CGPoint _lastPt;
}
@property int strokeSequenceNo;
@property (nonatomic,strong) NSMutableArray *points;
@property (nonatomic,strong) UIColor *inkColor;
-(id)initWithPointArray:(NSMutableArray*)points;
-(void)addStrokePoint:(CCViewStrokePoint*)sPt;
-(bool)intersectsViewRect:(CGRect)viewRect;
-(CGRect)strokeRect;
-(NSMutableArray*)strokePaths; //Array of CCViewQuadrilateral
-(CCViewQuadrilateral*)lastQuadInStroke;
@end
