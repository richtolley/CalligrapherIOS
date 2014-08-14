//
//  CCDataStore.m
//  Calligrapher
//
//  Created by Richard Tolley on 04/12/2012.
//  Copyright (c) 2012 Richard Tolley. All rights reserved.
//

#import "CCDataStore.h"
#import "CCAppDelegate.h"
#import "Manuscript.h"
#import "Stroke.h"
#import "Script.h"
#import "StrokeQuad.h"
#import "Page.h"
#import "CCSavedDefaults.h"
#define UNINITIALIZED_POINT_VAL -50000

@implementation CCDataStore
{
    CGPoint _lastPt;
    Manuscript *_msAsLoaded; //Used so that the original version of the MS can be saved if the user decides to save a version with a different name
}
- (id)init
{
    self = [super init];
    if (self)
    {
        CCAppDelegate *appDelegate = [[UIApplication sharedApplication]delegate];
        _moc = appDelegate.managedObjectContext;
        _lastStrokeQuadSequenceIssued = _lastStrokeSequenceIssued = 0;
        _defaults = [[CCSavedDefaults alloc]init];
        _lastPt = CGPointMake(UNINITIALIZED_POINT_VAL, UNINITIALIZED_POINT_VAL);
        [self getAllManuscripts];
    }
    return self;
}
//Generic factory method returning appropriate model object
-(id)modelObjectWithClassName:(NSString*)className
{
    NSEntityDescription *entity = [NSEntityDescription entityForName:className inManagedObjectContext:_moc];
    id newObject = [NSEntityDescription insertNewObjectForEntityForName:[entity name] inManagedObjectContext:_moc];
    return newObject;
}



-(void)createNewManuscriptWithPaperColor:(UIColor*)color
{
    _currentMS = [self modelObjectWithClassName:@"Manuscript"];
    _currentMS.paperColorVal = color;
    _currentMS.hasBeenSaved = NO;
    _currentMS.name = [self newDefaultTitle];
    _currentMS.creationDate = _currentMS.lastEditDate = [[NSDate date]timeIntervalSinceReferenceDate];
    _currentMS.page = [self modelObjectWithClassName:@"Page"];
    _lastStrokeQuadSequenceIssued = _lastStrokeSequenceIssued = 0;
    _unsavedChanges = NO;
}

-(void)addNewStrokeWithColor:(UIColor*)color
{
    @try {
        if(_currentMS != nil)
        {
            _currentStroke = [self modelObjectWithClassName:@"Stroke"];
            _currentStroke.sequence = ++_lastStrokeSequenceIssued;
            _currentStroke.inkColorVal = color;
            [_currentMS addStrokesObject:_currentStroke];
        }
        else @throw [NSException exceptionWithName:@"CCDataStore exception" reason:@"Attempt to add stroke to nil Script object" userInfo:nil];
    }
    @catch (NSException *exception) {
        NSLog(@"Exception thrown %@ : %@",exception.name,exception.reason);
    }
    
    
}

-(void)addNewPtToCurrentStroke:(CGPoint)point withNibWidth:(double)nibWidth andAngle:(double)nibAngle
{
    @try {
        if(_currentStroke != nil)
        {
            
            StrokeQuad *sQuad = [self modelObjectWithClassName:@"StrokeQuad"];
            
            sQuad.nibAngle = nibAngle;
            sQuad.nibWidth = nibWidth;
            sQuad.point1 = _lastPt;
            sQuad.point2 = point;
            sQuad.sequence = ++_lastStrokeQuadSequenceIssued;
            [_currentStroke addQuadsObject:sQuad];
            
        }
        else @throw [NSException exceptionWithName:@"CCDataStore exception" reason:@"Attempt to add StrokePoint to nil currentStroke object" userInfo:nil];
    }
    @catch (NSException *exception) {
        NSLog(@"Exception thrown %@ : %@",exception.name,exception.reason);
    }
}

-(void)saveCurrentContextWithName:(NSString*)fileName andThumbnail:(UIImage*)thumbnailImage
{
    self.currentMS.lastEditDate = [[NSDate date]timeIntervalSinceReferenceDate];
    [self validateCurrentFileName:fileName];
    if(_msAsLoaded != nil && _currentMS.hasBeenSaved && [fileName isEqualToString:_currentMS.name]) //If saving under the same name, destroy duplicate stored when MS loaded
    {
        [_moc deleteObject:_msAsLoaded];
        _msAsLoaded = nil;
        
    }
    
    if(_msAsLoaded != nil)
    {
        _msAsLoaded.hasBeenSaved = TRUE;
        _msAsLoaded.lastEditDate = [[NSDate date]timeIntervalSinceReferenceDate];
    }

    _currentMS.hasBeenSaved = TRUE;
    _currentMS.name = fileName;
    _currentMS.thumbnailImage = thumbnailImage;
    [_allManuscripts addObject:self.currentMS];
    
    for(Manuscript *m in _allManuscripts)
    {
            if(!m.hasBeenSaved)
            {
                [_moc deleteObject:m];
            }
    }

    NSError *error;
    if(![_moc save:&error])
    {
        NSLog(@"Error saving entity: %@",[error localizedDescription]);
        NSArray* detailedErrors = [[error userInfo] objectForKey:NSDetailedErrorsKey];
		if(detailedErrors != nil && [detailedErrors count] > 0)
        {
			for(NSError* detailedError in detailedErrors)
            {
				NSLog(@"  DetailedError: %@", [detailedError userInfo]);
			}
		}
		else {
			NSLog(@"  %@", [error userInfo]);
		}
        
    }
    else
    {
        _unsavedChanges = NO;
        
    }
    
}

-(void)validateCurrentFileName:(NSString*)fileName
{
        
    int maxFilenameLen = 50;
    if(fileName == nil)
        @throw [NSException exceptionWithName:@"Bad filename exception" reason:@"Save Manuscript filename cannot be nil" userInfo:nil];
    if(fileName.length == 0)
        @throw [NSException exceptionWithName:@"Bad filename exception" reason:@"Save Manuscript filename too short" userInfo:nil];
    if(fileName.length > maxFilenameLen)
        @throw [NSException exceptionWithName:@"Bad filename exception" reason:[NSString stringWithFormat:@"Save Manuscript filename cannot be longer than %d",maxFilenameLen] userInfo:nil];
}

-(NSString*)newDefaultTitle
{   static int untitledCount = 1;
    
    return [NSString stringWithFormat:@"Untitled %d",untitledCount++];
}

-(void)removeUnsavedManuscripts:(NSArray*)manuscripts
{
    for(Manuscript *m in manuscripts)
    {
        if(!m.hasBeenSaved)
        {
            [_moc deleteObject:m];
        }
    }
}

-(void)deleteObject:(NSManagedObject *)object
{
    [_moc deleteObject:object];
}


-(Manuscript*)manuscriptWithName:(NSString*)msName
{
    
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name = %@",msName];
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc]initWithKey:@"name" ascending:YES];
    NSArray *results = [self executeFetchRequestForEntity:@"Manuscript" withPredicate:predicate andSortDescriptors:@[sortDescriptor]];
    
    if(results != nil && results.count > 0)
    {   self.currentMS = results[0];
        _msAsLoaded = [self duplicateMS:self.currentMS];
        
        _lastStrokeSequenceIssued = self.currentMS.strokes.count;
        _lastStrokeQuadSequenceIssued = 0;
        return results[0];
    
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Unable to load manuscript" message:@"No manuscripts have been saved" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
       return nil; 
    } 
}

-(Manuscript*)duplicateMS:(Manuscript*)toCopy
{
    Manuscript *newMS = [self modelObjectWithClassName:@"Manuscript"];
    newMS.creationDate = [[NSDate date]timeIntervalSinceReferenceDate];
    newMS.lastEditDate = [[NSDate date]timeIntervalSinceReferenceDate];
    newMS.thumbnailImage = toCopy.thumbnailImage;
    newMS.paperColorVal = toCopy.paperColorVal;
    newMS.page = [self duplicatePage:toCopy.page];
    newMS.name = toCopy.name;
    for(Stroke *s in toCopy.strokes)
    {   Stroke *newStroke = [self duplicateStroke:s];
        [newMS addStrokesObject:newStroke];
    }
    return newMS;
}

-(Page*)duplicatePage:(Page*)toCopy
{
    Page *newPage = [self modelObjectWithClassName:@"Page"];
    newPage.topMargin = toCopy.topMargin;
    newPage.bottomMargin = toCopy.bottomMargin;
    newPage.leftMargin = toCopy.leftMargin;
    newPage.rightMargin = toCopy.rightMargin;
    newPage.width = toCopy.width;
    newPage.height = toCopy.height;
    newPage.lineSpacing = toCopy.lineSpacing;
    newPage.nibWidth = toCopy.nibWidth;
    return newPage;
}

-(Stroke*)duplicateStroke:(Stroke*)toCopy;
{
    Stroke *newStroke = [self modelObjectWithClassName:@"Stroke"];
    newStroke.sequence = toCopy.sequence;
    newStroke.inkColorVal = toCopy.inkColorVal;
    for(StrokeQuad *sQuad in toCopy.quads)
    {
        StrokeQuad *newStrokeQuad = [self duplicateStrokeQuad:sQuad];
        [newStroke addQuadsObject:newStrokeQuad];
    }
    return newStroke;
}

-(StrokeQuad*)duplicateStrokeQuad:(StrokeQuad*)toCopy;
{
    StrokeQuad *newStrokeQuad = [self modelObjectWithClassName:@"StrokeQuad"];
    newStrokeQuad.sequence = toCopy.sequence;
    newStrokeQuad.nibWidth = toCopy.nibWidth;
    newStrokeQuad.nibAngle = toCopy.nibAngle;
    newStrokeQuad.point1 = toCopy.point1;
    newStrokeQuad.point2 = toCopy.point2;
    
    return newStrokeQuad;
}

-(void)deleteManuscriptWithName:(NSString*)fileName
{
    
    Manuscript *m;
    if([fileName isEqualToString:self.currentMS.name])
    {
        m = self.currentMS;
    }
    else m = [self manuscriptWithName:fileName];
    
    
    [_allManuscripts removeObject:m];
    [_moc deleteObject:m];
    if(_msAsLoaded != nil)
    {
        [_moc deleteObject:_msAsLoaded];
    }
    
    NSError *mocSaveError;
    if(![_moc save:&mocSaveError])
    {
        NSLog(@"save failed %@",mocSaveError.localizedDescription);
    }
}



-(NSArray*)executeFetchRequestForEntity:(NSString*)entityName withPredicate:(NSPredicate*)predicate andSortDescriptors:(NSArray*)sortDescriptors
{
    NSEntityDescription *entityDesc = [NSEntityDescription entityForName:entityName inManagedObjectContext:_moc];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc]init];
    [fetchRequest setEntity:entityDesc];
    [fetchRequest setShouldRefreshRefetchedObjects:YES];
    [fetchRequest setIncludesPendingChanges:NO];
    [fetchRequest setPredicate:predicate];
    
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    NSError *error;
    NSArray *results = [_moc executeFetchRequest:fetchRequest error:&error];
    
    if(error)
    {
        NSLog(@"Error: %@",error.localizedDescription);
    }
    
    return results;
}


-(bool)filenameAlreadyExists:(NSString*)filename
{
    bool rVal = NO;
    for(Manuscript *ms in _allManuscripts)
    {
        if([ms.name isEqualToString:filename])
        {
            rVal = YES;
        }
    }
    
    return rVal;
}

-(void)getAllManuscripts
{
    
    NSEntityDescription *entityDesc = [NSEntityDescription entityForName:@"Manuscript" inManagedObjectContext:_moc];
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc]init];
    [fetchRequest setEntity:entityDesc];
    [fetchRequest setSortDescriptors:@[sortDescriptor]];
    NSError *fetchError;
    NSArray *fetchedItems = [_moc executeFetchRequest:fetchRequest error:&fetchError];
    if(fetchError)
    {
        NSLog(@"Fetch error %@,%@",fetchError.localizedDescription,fetchError.localizedFailureReason);
    }
    
    _allManuscripts = [[NSMutableArray alloc]init];
    for(Manuscript *m in fetchedItems)
    {
        
        if(m.name.length > 0)
        {
            [_allManuscripts addObject:m];
        }
    }
    
    if(fetchError)
    {
        NSLog(@"Fetch error: %@",fetchError.localizedDescription);
        
    }
    
    
}


@end
