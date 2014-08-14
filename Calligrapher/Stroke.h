//
//  Stroke.h
//  Calligrapher
//
//  Created by Richard Tolley on 25/01/2013.
//  Copyright (c) 2013 Richard Tolley. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Manuscript, StrokeQuad;

@interface Stroke : NSManagedObject

@property (nonatomic, retain) id inkColorVal;
@property (nonatomic) int32_t sequence;
@property (nonatomic, retain) NSSet *quads;
@property (nonatomic, retain) Manuscript *manuscript;
@property (nonatomic,strong,readonly) NSString *key;

@end

@interface Stroke (CoreDataGeneratedAccessors)

- (void)addQuadsObject:(StrokeQuad *)value;
- (void)removeQuadsObject:(StrokeQuad *)value;
- (void)addQuads:(NSSet *)values;
- (void)removeQuads:(NSSet *)values;

@end
