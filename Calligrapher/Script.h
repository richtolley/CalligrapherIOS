//
//  Script.h
//  Calligrapher
//
//  Created by Richard Tolley on 27/11/2012.
//  Copyright (c) 2012 Richard Tolley. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Manuscript, Page, Stroke;
//Represents components of the manuscript which must be drawn in order to render the ms on the screen
@interface Script : NSManagedObject
{
    int _strokeSequence;
}

@property (nonatomic, retain) UIColor* paperColorVal;
@property (nonatomic, retain) Manuscript *manuscript;
@property (nonatomic, retain) NSSet *strokes;
@property (nonatomic, retain) Page *page;
-(void)clear;
@end

@interface Script (CoreDataGeneratedAccessors)

- (void)addStrokesObject:(Stroke *)value;
- (void)removeStrokesObject:(Stroke *)value;
- (void)addStrokes:(NSSet *)values;
- (void)removeStrokes:(NSSet *)values;

@end
