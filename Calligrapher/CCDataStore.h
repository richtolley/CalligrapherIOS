//
//  CCDataStore.h
//  Calligrapher
//
//  Created by Richard Tolley on 04/12/2012.
//  Copyright (c) 2012 Richard Tolley. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Manuscript;
@class CCSavedDefaults;
@class Stroke;
@interface CCDataStore : NSObject
{
    NSManagedObjectContext *_moc;
    Stroke *_currentStroke;
}
@property int lastStrokeSequenceIssued;
@property int lastStrokeQuadSequenceIssued;
@property bool unsavedChanges;
@property (nonatomic,strong) Manuscript *currentMS;
@property (nonatomic,strong) CCSavedDefaults *defaults;
@property (nonatomic,strong) NSMutableArray *allManuscripts;
-(id)modelObjectWithClassName:(NSString*)className;
-(Manuscript*)manuscriptWithName:(NSString*)msName;
-(void)createNewManuscriptWithPaperColor:(UIColor*)color;
-(void)addNewStrokeWithColor:(UIColor*)color;
-(void)addNewPtToCurrentStroke:(CGPoint)point withNibWidth:(double)nibWidth andAngle:(double)nibAngle;
-(void)saveCurrentContextWithName:(NSString*)fileName andThumbnail:(UIImage*)thumbnailImage;
-(void)deleteManuscriptWithName:(NSString*)fileName;
-(bool)filenameAlreadyExists:(NSString*)filename;
-(void)deleteObject:(NSManagedObject *)object;
@end
