//
//  CCThinView.m
//  Calligrapher
//
//  Created by Richard Tolley on 04/12/2012.
//  Copyright (c) 2012 Richard Tolley. All rights reserved.
//

#import "CCThinView.h"
#import "CCViewPage.h"
#import "CCViewStroke.h"
#import "CCViewStrokePoint.h"
#import "CCColorWellView.h"
#import "CCCalligraphyStyle.h"
#import "CCInkConfigViewController.h"
#import "CCPaperColorsTableViewController.h"
#import "CCNibView.h"
#import "Manuscript.h"
#import "Script.h"
#import "Stroke.h"
#import "StrokePoint.h"  
#import "NSObject+ForegroundColorForBackgroundColor.h"
#import "CCDataStore.h"
#import "UIView+ThumbnailCreator.h"


#define kIconSize CGSizeMake(100, 100)


@implementation CCThinView
{
    NSMutableArray *_strokes;
    CGRect currentRect;
    NSMutableArray *_guideLineBezierPaths;
}


-(void)setupWithPage:(CCViewPage*)page
{
     _strokes = [[NSMutableArray alloc]init];
     _unsavedChanges = NO;
     _unsavedMS = YES;
     _fullScreenRefreshNeeded = NO;
    double h = self.frame.size.height;
    double w = self.frame.size.width;
    _page = page;
    _page.leftMargin = _page.rightMargin = w *0.10;
    _page.topMargin = _page.bottomMargin = h *0.10;
    _page.height = h;
    _page.width = w;
    _page.lineSpacing = _page.nibWidth *2.0;
    //[_page generateGuideLines];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(paperColorChange:) name:@"paperColorChanged" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(tableViewPaperColorChange:) name:@"tableViewPaperColorChanged" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(inkColorChange:) name:@"inkColorChanged" object:nil];

}



-(void)clear
{
    [_strokes removeAllObjects];
    _fullScreenRefreshNeeded = YES;
    [self setNeedsDisplay];
}

-(void)clearLastStroke
{
    [_strokes removeLastObject];
    [self setNeedsDisplay];
}

-(void)loadManuscriptWithName:(NSString*)name fromDataStore:(CCDataStore*)dataStore
{   _unsavedChanges = NO;
    [_strokes removeAllObjects];
    NSLog(@"msName is %@",name);
    Manuscript *ms = [dataStore manuscriptWithName:name];
    Script *s = ms.script;
    self.backgroundColor = s.paperColorVal;
    NSArray *strokeArray = [s.strokes sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"sequence" ascending:YES]]];
    
    for(Stroke *s in strokeArray)
    {
        NSArray *pointArray = [s.points sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"sequence" ascending:YES]]];
        NSMutableArray *viewPointArray = [[NSMutableArray alloc]init];
        
        for(StrokePoint *spt in pointArray)
        {
           CCViewStrokePoint *vSpt = [[CCViewStrokePoint alloc]initWithWidth:spt.nibWidth Angle:spt.nibAngle andPoint:spt.point];
           [viewPointArray addObject:vSpt];
        }
        
        CCViewStroke *vStroke = [[CCViewStroke alloc]initWithPointArray:viewPointArray];
        
        vStroke.inkColor = s.inkColorVal;
        [_strokes addObject:vStroke];
    }
    
    
    _fullScreenRefreshNeeded = YES;
    [self setNeedsDisplay];
}

-(void)saveCurrentManuscriptToDataStore:(CCDataStore*)dataStore
{
    [self saveManuscriptWithName:nil toDataStore:dataStore];
}


-(void)saveNewManuscriptWithName:(NSString*)name toDataStore:(CCDataStore*)dataStore
{
    [self saveManuscriptWithName:name toDataStore:dataStore];
}

-(void)saveManuscriptWithName:(NSString *)name toDataStore:(CCDataStore *)dataStore
{
    if(name != nil)
        [dataStore createNewManuscriptWithPaperColor:self.backgroundColor];
    for(CCViewStroke *vs in _strokes)
    {   [dataStore addNewStrokeWithColor:vs.inkColor];
        for(CCViewStrokePoint *vspt in vs.points)
        {
            [dataStore addNewPtToCurrentStroke:vspt.point withNibWidth:vspt.nibWidth andAngle:vspt.nibAngle];
        }
    }
    [dataStore saveCurrentContextWithName:name andThumbnail:[self createThumbnailOfSize:kIconSize]];
}


- (void)drawRect:(CGRect)rect
{
    NSDate *startTime = [NSDate date];
    int strokesDrawn = 0;
    
    if(_fullScreenRefreshNeeded)
        [self drawRefreshAll];
    else
    {
        
    
    
    if(self.deleteModeActive)
    {
        NSMutableArray *toDelete = [[NSMutableArray alloc]init];
        for(CCViewStroke *stroke in _strokes)
        {
            if(CGRectIntersectsRect(stroke.strokeRect, currentRect))
                [toDelete addObject:stroke];
        }
        
        
        for(CCViewStroke *stroke in toDelete)
            [_strokes removeObject:stroke];
        
        [self drawRefreshAll];
    }
    else
    {
        if(_guideLinesVisible)
        {
            [[self foregroundColorForBackgroundColor:self.backgroundColor]setStroke];
            for(UIBezierPath *gLine in self.page.guideLines)
            {
                [gLine stroke];
                
            }
        }
        [[UIColor blackColor] setStroke];
        
            for(CCViewStroke *stroke in _strokes)
            {
                if(CGRectIntersectsRect(stroke.strokeRect, currentRect))
                {
                    [stroke.inkColor setFill];
                    [stroke.inkColor setStroke];
                    
                    for(UIBezierPath *b in stroke.strokePaths)
                    {
                        [b fillWithBlendMode:kCGBlendModeNormal alpha:1.0];
                        [b setLineWidth:2.0];
                        
                        //Clip
                        CGContextRef context = UIGraphicsGetCurrentContext();
                        CGContextSaveGState(context);
                        CGContextBeginPath(context);
                        CGContextAddPath(context, b.CGPath);
                        CGContextClosePath(context);
                        CGContextClip(context);
                        [b stroke];
                        CGContextRestoreGState(context);
                        
                    }
                    strokesDrawn++;
                }
            }        
            NSLog(@"%d strokes drawn",strokesDrawn);
        }
    }
    
    NSDate *stopTime = [NSDate date];
    NSTimeInterval interval = [stopTime timeIntervalSinceDate:startTime];
    NSLog(@"Time since last fire %f",interval);
}

-(void)drawRefreshAll
{
    _fullScreenRefreshNeeded = NO;
    
    if(_guideLinesVisible)
    {
        [[self foregroundColorForBackgroundColor:self.backgroundColor]setStroke];
        for(UIBezierPath *gLine in self.page.guideLines)
            [gLine stroke];
    }
    
    for(CCViewStroke *stroke in _strokes)
    {
        
            [stroke.inkColor setFill];
            [stroke.inkColor setStroke];
            
            for(UIBezierPath *b in stroke.strokePaths)
            {
                [b fillWithBlendMode:kCGBlendModeNormal alpha:1.0];
                [b setLineWidth:2.0];
                
                //Clip
                CGContextRef context = UIGraphicsGetCurrentContext();
                CGContextSaveGState(context);
                CGContextBeginPath(context);
                CGContextAddPath(context, b.CGPath);
                CGContextClosePath(context);
                CGContextClip(context);
                [b stroke];
                CGContextRestoreGState(context);
                
            }
        
    }
    
    
    
}

#pragma mark - Touch Methods

-(void)addPointToStrokeForTouches:(NSSet*)touches
{
    _unsavedChanges = YES;
    UITouch *t = [touches anyObject];
    CGPoint viewPt = [t locationInView:self];
    
    CCViewStrokePoint *sPoint = [[CCViewStrokePoint alloc]initWithWidth:_page.nibWidth Angle:_page.nibAngle andPoint:viewPt];
    CCViewStroke *currentStroke = [_strokes lastObject];
    [currentStroke addStrokePoint:sPoint];
    currentRect = [currentStroke strokeRect];
    if(_deleteModeActive)
    {
        [self setNeedsDisplay];
    }
    else [self setNeedsDisplayInRect:[currentStroke strokeRect]];
}

-(void)startNewStroke
{
    CCViewStroke *newStroke = [[CCViewStroke alloc]init];
    newStroke.inkColor = self.inkColor;
    [_strokes addObject:newStroke];
}


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if([[event allTouches]count]== 1)
    {
        [self startNewStroke];
        [self addPointToStrokeForTouches:touches];
    }
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    if([[event allTouches]count]== 1)
        [self addPointToStrokeForTouches:touches];
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if([[event allTouches]count]== 1)
        [self addPointToStrokeForTouches:touches];
}

#pragma mark - Notification methods


-(void)inkColorChange:(NSNotification*)notification
{
    CCInkConfigViewController *inkConfigController = (CCInkConfigViewController*)notification.object;
    self.inkColor = inkConfigController.colorWell.backgroundColor;
    
}

-(void)paperColorChange:(NSNotification*)notification
{
    CCInkConfigViewController *inkConfigController = (CCInkConfigViewController*)notification.object;
    self.backgroundColor = inkConfigController.colorWell.backgroundColor;
}

-(void)tableViewPaperColorChange:(NSNotification*)notification
{
    CCPaperColorsTableViewController *paperTableViewController = (CCPaperColorsTableViewController*)notification.object;
    self.backgroundColor = paperTableViewController.currentColor;
    
}



@end
