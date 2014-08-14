//
//  CCViewPage.h
//  Calligrapher
//
//  Created by Richard Tolley on 04/12/2012.
//  Copyright (c) 2012 Richard Tolley. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OGLDrawingTypes.h"
#import <vector>
@class CCCalligraphyStyle;
@class CCDataStore;
@class Stroke;
@class StrokeQuad;
@interface CCViewPage : NSObject
{
    Stroke *_currentStroke;
    StrokeQuad *_lastQuadAdded;
    CGPoint _lastPt;
    bool _lastPtSet;
    CCCalligraphyStyle *_style;
}
@property (nonatomic,strong) CCDataStore *dataStore;
@property bool guideLinesVisible;
@property bool deleteModeActive;


@property double nibWidth;
@property (readonly) double nibAngle;
@property (nonatomic) double width;
@property (nonatomic) double topMargin;
@property (nonatomic) double bottomMargin;
@property (nonatomic) double rightMargin;
@property (nonatomic) double leftMargin;
@property (nonatomic) double height;
@property (nonatomic) double lineSpacing;
@property (nonatomic,strong) CCCalligraphyStyle *style;
@property (nonatomic,strong) UIColor *backgroundColor;
@property (nonatomic,strong) UIColor *inkColor;
@property CGRect currentRect;
-(id)initWithStyle:(CCCalligraphyStyle*)style andNibWidth:(double)nibWidth andFrame:(CGRect)frame;
-(void)generateGuideLines;
-(void)startNewStroke;
-(void)addPointToCurrentStroke:(CGPoint)point;
-(OGLQuadrilateral)lastQuadAdded;
-(NSString*)lastQuadKey;
-(std::vector<OGLQuadrilateral>)guideLines;
-(NSMutableArray*)deleteQuadsIntersectingRect:(CGRect)r;
@end
