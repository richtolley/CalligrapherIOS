//
//  Manuscript.h
//  Calligrapher
//
//  Created by Richard Tolley on 30/01/2013.
//  Copyright (c) 2013 Richard Tolley. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Page, Stroke;

@interface Manuscript : NSManagedObject

@property (nonatomic) NSTimeInterval creationDate;
@property (nonatomic) NSTimeInterval lastEditDate;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) id paperColorVal;
@property (nonatomic, retain) id thumbnailImage;
@property (nonatomic) BOOL hasBeenSaved;
@property (nonatomic, retain) Page *page;
@property (nonatomic, retain) NSSet *strokes;
@end

@interface Manuscript (CoreDataGeneratedAccessors)

- (void)addStrokesObject:(Stroke *)value;
- (void)removeStrokesObject:(Stroke *)value;
- (void)addStrokes:(NSSet *)values;
- (void)removeStrokes:(NSSet *)values;

@end
