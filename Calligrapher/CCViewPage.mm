//
//  CCViewPage.m
//  Calligrapher
//
//  Created by Richard Tolley on 04/12/2012.
//  Copyright (c) 2012 Richard Tolley. All rights reserved.
//

#import "CCViewPage.h"
#import "CCCalligraphyStyle.h"
#import "CCNibScriptStyleTableViewController.h"
#import "CCInkConfigViewController.h"
#import "CCPaperConfigViewController.h"
#import "CCColorWellView.h"
#import "CCNibView.h"
#import "NSObject+GeometryLogger.h"
#import "Manuscript.h"
#import "Stroke.h"
#import "StrokeQuad.h"
#import "CCDataStore.h"
#import "NSObject+OGLQuadMethods.h"



#define kIconSize CGSizeMake(100, 100)

@implementation CCViewPage
{
    std::vector<OGLQuadrilateral> *_guideLines;
}
-(id)initWithStyle:(CCCalligraphyStyle*)style andNibWidth:(double)nibWidth andFrame:(CGRect)frame;
{
    self = [super init];
    if (self) {
        self.style = style;
        
        self.nibWidth = nibWidth;
        _currentRect = frame;
        _lastPtSet = NO;
        
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(alphabetChanged:) name:@"alphabetChanged" object:nil];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(widthChanged:) name:@"nibWidthChanged" object:nil];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(paperColorChange:) name:@"paperColorChanged" object:nil];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(tableViewPaperColorChange:) name:@"tableViewPaperColorChanged" object:nil];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(inkColorChange:) name:@"inkColorChanged" object:nil];
    }
    return self;
}

-(void)setStyle:(CCCalligraphyStyle*)newStyle;
{
    _style = newStyle;
    [[NSUserDefaults standardUserDefaults]setDouble:newStyle.nibAngle forKey:@"LastNibAngle"];
}

-(CCCalligraphyStyle*)style
{
    return _style;
}

-(double)nibAngle
{   
    return _style.nibAngle;
}

-(void)addPointToCurrentStroke:(CGPoint)point
{
   if(!_lastPtSet) {
       _lastPtSet = TRUE;
       _lastPt = point;
   }
   else {
       _lastQuadAdded = [_dataStore modelObjectWithClassName:@"StrokeQuad"];
       [_currentStroke addQuadsObject:_lastQuadAdded];
       _lastQuadAdded.point1 = _lastPt;
       _lastQuadAdded.point2 = point;
       _lastQuadAdded.nibAngle = self.nibAngle;
       _lastQuadAdded.nibWidth = self.nibWidth;
       _lastQuadAdded.sequence = ++_dataStore.lastStrokeQuadSequenceIssued;
       _lastPt = point;
       
   }
}

-(OGLQuadrilateral)lastQuadAdded
{
    OGLQuadrilateral rVal = [self blankQuad];
    if(_currentStroke.quads.count > 0)
    {
        rVal = _lastQuadAdded.oglQuad;
    }
    return rVal;
}

-(NSString*)lastQuadKey
{
    @try {
        if(_currentStroke == nil) {
            @throw [NSException exceptionWithName:@"Nil Stroke Exception" reason:@"View page current stroke is nil" userInfo:nil];
        }
        if(_currentStroke == nil) {
            @throw [NSException exceptionWithName:@"Nil StrokeQuad Exception " reason:@"View page last quad added is nil" userInfo:nil];
        }
        else return [NSString stringWithFormat:@"%@%@",_currentStroke.key,_lastQuadAdded.key];
    }
    @catch (NSException *exception) {
        NSLog(@"%@:%@",exception.name,exception.reason);
        return nil;
    }

}

-(std::vector<OGLQuadrilateral>)guideLines
{
    return *_guideLines;
}

#pragma mark - Guide line methods

-(void)generateGuideLines
{
    
    double h = _currentRect.size.height;
    double w = _currentRect.size.width;
    self.leftMargin = self.rightMargin = w *0.10;
    self.topMargin = self.bottomMargin = h *0.10;
    self.height = h;
    self.width = w;
    self.lineSpacing = self.nibWidth *2.0;
    CGPoint iterPt = CGPointMake(self.leftMargin, self.topMargin);
    _guideLines = new std::vector<OGLQuadrilateral>;
    for(int i=0;i<[self linesWithCurrentParameters];i++)
    {   
        std::vector<OGLQuadrilateral> linesForLine = [self guideLinesForLine:iterPt];
        for(int i=0;i<static_cast<int>(linesForLine.size());i++)
            _guideLines->push_back(linesForLine[i]);
        iterPt.y += [self totalLineHeight];
    }
    
    
}


-(std::vector<OGLQuadrilateral>)guideLinesForLine:(CGPoint)lineStart
{
    CGPoint leftEdge = lineStart;
    
    CGPoint rightEdge = CGPointMake(self.width - self.rightMargin,lineStart.y);
    CGPoint (^moveLine)(CGPoint,double) = ^(CGPoint pt,double yMove)
    {
        return CGPointMake(pt.x, pt.y + yMove);
    };
    std::vector<OGLQuadrilateral> retVal;
    
    double lineGaps[4] = {0,[self headerToTopLine],[self topLineToBottomLine],[self bottomLineToFooter]};
    for(int i=0;i<4;i++)
    {   double lineWidth;
        if(i == 2)
            lineWidth = 4.0;
        else lineWidth = 2.0;
        leftEdge = moveLine(leftEdge,lineGaps[i]);
        rightEdge = moveLine(rightEdge,lineGaps[i]);
        OGLQuadrilateral oglQuad = [self guideLineQuadFrom:leftEdge to:rightEdge width:lineWidth];
        retVal.push_back(oglQuad);
    }
    
    return retVal;
}

-(OGLQuadrilateral)guideLineQuadFrom:(CGPoint)startPoint to:(CGPoint)finishPoint width:(CGFloat)width
{
    CGPoint tl = startPoint;
    CGPoint tr = finishPoint;
    CGPoint bl = CGPointMake(startPoint.x,startPoint.y + width);
    CGPoint br = CGPointMake(finishPoint.x,finishPoint.y + width);
    return [self makeOGLQuadWithTopLeft:tl topRight:tr bottomLeft:bl bottomRight:br];
}

-(double)headerToTopLine
{
    return self.style.headerXHeight * self.nibWidth;
}
-(double)topLineToBottomLine
{
    return self.style.xHeight * self.nibWidth;
}
-(double)bottomLineToFooter
{
    return self.style.footerXheight * self.nibWidth;
}
-(double)totalLineHeight
{
    double retVal = [self headerToTopLine] + [self topLineToBottomLine] + [self bottomLineToFooter] + self.lineSpacing;
    return retVal;
}
-(int)linesWithCurrentParameters
{
    double heightAfterMarginsRemoved = self.height - self.topMargin - self.bottomMargin;
    int retVal = heightAfterMarginsRemoved / [self totalLineHeight];
    return retVal;
}

#pragma mark - Loading and saving


-(void)startNewStroke
{
    Stroke *s = [_dataStore modelObjectWithClassName:@"Stroke"];
    s.sequence = ++_dataStore.lastStrokeSequenceIssued;
    s.inkColorVal = self.inkColor;
    [_dataStore.currentMS addStrokesObject:s];
    _currentStroke = s;
    _dataStore.lastStrokeQuadSequenceIssued = 0;
    _lastQuadAdded = nil;
    _lastPtSet = FALSE;
}

#pragma mark - Notification methods

-(void)alphabetChanged:(NSNotification*)notification
{
    CCNibScriptStyleTableViewController *nibScriptController = (CCNibScriptStyleTableViewController*)notification.object;
    NSString *newStyleName = nibScriptController.currentStyle;
    
    if ([newStyleName isEqualToString:@"gothic"])
        self.style = [CCCalligraphyStyle gothicStyle];
    else if([newStyleName isEqualToString:@"foundational"])
        self.style = [CCCalligraphyStyle foundationalStyle];
    else if([newStyleName isEqualToString:@"uncial"])
        self.style = [CCCalligraphyStyle uncialStyle];
    else self.style = [CCCalligraphyStyle italicStyle];
    [self generateGuideLines];
}

-(void)widthChanged:(NSNotification*)notification
{
    CCNibView *nibView = (CCNibView*)notification.object;
    self.nibWidth = nibView.nibWidth;
    [[NSUserDefaults standardUserDefaults]setDouble:_nibWidth forKey:@"LastNibWidth"];
    [self generateGuideLines];
}

-(void)inkColorChange:(NSNotification*)notification
{
    CCInkConfigViewController *inkConfigController = (CCInkConfigViewController*)notification.object;
    self.inkColor = inkConfigController.colorWell.backgroundColor;
    
}

-(void)paperColorChange:(NSNotification*)notification
{
    CCInkConfigViewController *inkConfigController = (CCInkConfigViewController*)notification.object;
    self.backgroundColor = inkConfigController.colorWell.backgroundColor;
    self.dataStore.currentMS.paperColorVal = self.backgroundColor;
}

-(void)tableViewPaperColorChange:(NSNotification*)notification
{
    CCPaperColorsTableViewController *paperTableViewController = (CCPaperColorsTableViewController*)notification.object;
    self.backgroundColor = paperTableViewController.currentColor;
    self.dataStore.currentMS.paperColorVal = self.backgroundColor;
    
}

-(NSMutableArray*)deleteQuadsIntersectingRect:(CGRect)r
{
    NSMutableArray *rVals = [[NSMutableArray alloc]init];
    NSSet *strokes = _dataStore.currentMS.strokes;
    
    for(Stroke* s in strokes)
    {
        
        for(StrokeQuad *vQuad in s.quads)
            {
                if(CGRectIntersectsRect(r, vQuad.boundingRect)) {
                    NSString *key = [NSString stringWithFormat:@"%@%@",s.key,vQuad.key];
                    [rVals addObject:key];
                    [_dataStore deleteObject:vQuad];
                    
                }
        }
        
        
        if(s.quads.count == 0){
            [_dataStore deleteObject:s];
        }
        
    }
    return rVals;
}

-(void)dealloc
{
   [[NSNotificationCenter defaultCenter]removeObserver:self];
}

@end
