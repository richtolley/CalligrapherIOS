//
//  CCOGLViewController.m
//  Calligrapher
//
//  Created by Richard Tolley on 27/01/2013.
//  Copyright (c) 2013 Richard Tolley. All rights reserved.
//

#import "CCOGLViewController.h"
#import "CCCoordinateConverter.h"
#import "CCViewPage.h"
#import "CCDataStore.h"
#import "Manuscript.h"
#import "Stroke.h"
#import "StrokeQuad.h"
#import "CCSavedDefaults.h"
#import "CCCalligraphyStyle.h"
#import "OGLDrawingTypes.h"
#import "NSObject+OGLQuadMethods.h"
#import "NSObject+ForegroundColorForBackgroundColor.h"
#import "UIColor+ColorLogger.h"
//C++
#import <map>
#import <string>
#import <vector>

//test
#import "NSObject+GeometryLogger.h"


#define kIconSize CGSizeMake(100, 100)

typedef std::map<std::string, GLuint> OGLStrokeDictionary;

@interface CCOGLViewController ()
{
    NSString *_fileNameToDelete; //temp ivar used to pass file name to delete to alertview delegate method
    
    //OGL ivars
    CCCoordinateConverter *_coordinateConverter;
    GLuint _paperVertexArray;
    
    CGFloat _squareSize;
    CGFloat _rotation;
    CGFloat _fovyRad;
    CGFloat _curZ;
    CGFloat _projectionDepth;
    
    OGLStrokeDictionary *_oglStrokeDict;
    std::vector<GLuint> *_guideLineVBAs;
    GLuint *_vbaAddress;
    CGFloat _yOffset; //Expressed in % of screen height. So scrolling down 1.5 screens is 150

}

@property (nonatomic,strong) EAGLContext *context;
@property (nonatomic,strong) GLKBaseEffect *effect;
@property BOOL paperDrawn;
@end

@implementation CCOGLViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [super viewDidLoad];
        self.context = [[EAGLContext alloc]initWithAPI:kEAGLRenderingAPIOpenGLES2];
        if(!self.context)
        {
            NSLog(@"Failed to create ES context"); 
        }
        _fovyRad = DEGTORAD(65.0);
        
        _dataStore = [[CCDataStore alloc]init];
        
        CCCalligraphyStyle *style = [CCCalligraphyStyle styleWithName:_dataStore.defaults.lastStyleName];
        CGRect pageFrame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height * 2);
        self.viewPage = [[CCViewPage alloc]initWithStyle:style andNibWidth:_dataStore.defaults.lastNibWidth andFrame:pageFrame];
        _viewPage.backgroundColor = _dataStore.defaults.lastPaperColor;
        _viewPage.inkColor = _dataStore.defaults.lastInkColor;
    
        if(_dataStore.defaults.lastMSName != nil)
        {
            [self loadManuscriptWithName:_dataStore.defaults.lastMSName];
        }
        else [_dataStore createNewManuscriptWithPaperColor:_viewPage.backgroundColor];
        _viewPage.dataStore = _dataStore;
       [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(nibWidthChanged:) name:@"nibWidthChanged" object:nil];
    }
    return self;
}

-(void)viewDidAppear:(BOOL)animated
{   
    self.paused = NO;
    self.paperDrawn = NO;
}

-(NSString*)currentMSName
{
    return _dataStore.currentMS.name;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

-(void)setupGL
{   
    GLKView *view = (GLKView*)self.view;
    view.context = self.context;
    view.drawableMultisample = GLKViewDrawableMultisample4X;
    [EAGLContext setCurrentContext:self.context];
    self.effect = [[GLKBaseEffect alloc]init];
    _curZ = -6;
    _projectionDepth = abs(_curZ);
    _coordinateConverter = [[CCCoordinateConverter alloc]initWithScreenRect:self.view.bounds zVal:_projectionDepth fovyRad:_fovyRad];
   
    UIColor *paperColor = _dataStore.defaults.lastPaperColor;
    
    [self setGLPaperColor:paperColor];
    _oglStrokeDict = new OGLStrokeDictionary;
    _guideLineVBAs = new std::vector<GLuint>;
    [self setupGuidelines];
    self.paused = NO;
    
    float aspect = fabsf(self.view.bounds.size.width / self.view.bounds.size.height);
    
    GLKMatrix4 projectionMatrix = GLKMatrix4MakePerspective(_fovyRad, aspect, 0.0f, 20.0f);
    self.effect.transform.projectionMatrix = projectionMatrix;
    GLKMatrix4 modelViewMatrix = GLKMatrix4MakeTranslation(0.0f, _yOffset, _curZ);
    self.effect.transform.modelviewMatrix = modelViewMatrix;
    
}

-(void)setupGuidelines
{
    self.viewPage.currentRect = self.view.bounds;
    [self.viewPage generateGuideLines];
    _guideLineVBAs->clear();
    std::vector<OGLQuadrilateral> guidelines = [self.viewPage guideLines];
    UIColor *guidelineColor = [self foregroundColorForBackgroundColor:_dataStore.currentMS.paperColorVal];
    for(int i=0;i<static_cast<int>(guidelines.size());i++) {
        
        _guideLineVBAs->push_back(0);
        int lastVBA =_guideLineVBAs->size() -1;
        glGenVertexArraysOES(1, &_guideLineVBAs->at(lastVBA));
        glBindVertexArrayOES(_guideLineVBAs->at(lastVBA));
        [self addVBAForQuad:guidelines[i] ofColor:guidelineColor];
    }
}

-(void)setGLPaperColor:(UIColor*)color
{
    
    glDeleteVertexArraysOES(1, &_paperVertexArray);
    glGenVertexArraysOES(1, &_paperVertexArray);
    glBindVertexArrayOES(_paperVertexArray);
    
    CGPoint tl = self.view.bounds.origin;
    CGFloat w = self.view.bounds.size.width;
    CGFloat h = self.view.bounds.size.height;
    CGPoint tr = CGPointMake(tl.x + w, tl.y);
    CGPoint bl = CGPointMake(tl.x,tl.y +h);
    CGPoint br = CGPointMake(tl.x + w, tl.y + h);
    OGLQuadrilateral viewQuad = [self makeOGLQuadWithTopLeft:tl topRight:tr bottomLeft:bl bottomRight:br];
    
    [self addVBAForQuad:viewQuad ofColor:color];
    
    self.paperDrawn = NO;
    
}

-(void)addVBAForQuad:(OGLQuadrilateral)quad ofColor:(UIColor*)color
{
    OGLQuadrilateral glQuad = [_coordinateConverter convertViewQuadToOGL:quad];
    GLuint quadBuffer;
    
    glGenBuffers(1, &quadBuffer);
    glBindBuffer(GL_ARRAY_BUFFER, quadBuffer);
    Vertex quadVertices[4];
    
    [self makeQuadrilateralForPoints:glQuad.topLeft tr:glQuad.topRight tl:glQuad.bottomRight bl:glQuad.bottomLeft zVal:0.0 color:color vertex:quadVertices];
    glBufferData(GL_ARRAY_BUFFER, sizeof(quadVertices), quadVertices, GL_STATIC_DRAW);
    
    GLuint indexB;
    glGenBuffers(1, &indexB);
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, indexB);
    glBufferData(GL_ELEMENT_ARRAY_BUFFER, sizeof(Indices), Indices, GL_STATIC_DRAW);
    
    glEnableVertexAttribArray(GLKVertexAttribPosition);
    glVertexAttribPointer(GLKVertexAttribPosition, 3, GL_FLOAT, GL_FALSE, sizeof(Vertex), (const GLvoid*) offsetof(Vertex, Position));
    
    glEnableVertexAttribArray(GLKVertexAttribColor);
    glVertexAttribPointer(GLKVertexAttribColor, 4, GL_FLOAT, GL_FALSE, sizeof(Vertex), (const GLvoid*) offsetof(Vertex, Color));
    
}



-(void)glkView:(GLKView*)view drawInRect:(CGRect)rect
{
    
    
    [self.effect prepareToDraw];
    
    
        glBindVertexArrayOES(_paperVertexArray);
        glDrawElements(GL_TRIANGLES, sizeof(Indices)/sizeof(Indices[0]),GL_UNSIGNED_SHORT, 0);
        self.paperDrawn = YES;
    
    
    for(std::map<std::string, GLuint>::iterator it = _oglStrokeDict->begin(); it != _oglStrokeDict->end();++it)
    {
        glBindVertexArrayOES(it->second);
        glDrawElements(GL_TRIANGLES, sizeof(Indices)/sizeof(Indices[0]),GL_UNSIGNED_SHORT, 0);
    }
    
    
    if(self.viewPage.guideLinesVisible)
    {
        for(int i=0;i<static_cast<int>(_guideLineVBAs->size());i++)
        {
            glBindVertexArrayOES(_guideLineVBAs->at(i));
            glDrawElements(GL_TRIANGLES, sizeof(Indices)/sizeof(Indices[0]),GL_UNSIGNED_SHORT, 0);
        }
    }
    
    glBindVertexArrayOES(0);
    
    
}

-(void)checkForUnsavedChanges
{
    if(self.dataStore.unsavedChanges)
    {
        UIAlertView *unsavedChangesAlert = [[UIAlertView alloc]initWithTitle:@"Changes have not been saved" message:@"The current manuscript contains unsaved changes" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:@"Save and Continue", nil];
        [unsavedChangesAlert show];
    }
}

-(void)clear
{
    for(Stroke *s in _dataStore.currentMS.strokes)
    {
        [_dataStore deleteObject:s];
    }
    [self clearOGLVertexArrays];
}

-(void)clearOGLVertexArrays
{

    for(std::map<std::string, GLuint>::iterator it = _oglStrokeDict->begin(); it != _oglStrokeDict->end();++it)
    {
        glDeleteVertexArraysOES(1, &it->second);
   
        
    }
    
    _oglStrokeDict->clear();
    
}

#pragma mark - Touch Methods

-(void)addPointToStrokeForTouches:(NSSet*)touches
{
    self.dataStore.unsavedChanges = YES;
    UITouch *t = [touches anyObject];
    CGPoint viewPt = [t locationInView:self.view];
    
    self.paused = NO;
    
    
    if(self.viewPage.deleteModeActive)
    {
        CGFloat touchWidth = 5;
        CGRect touchRect = CGRectMake(viewPt.x-touchWidth, viewPt.y+touchWidth, touchWidth*2, touchWidth*2);
        NSMutableArray *touchStrings = [self.viewPage deleteQuadsIntersectingRect:touchRect];
        for(NSString *s in touchStrings)
        {   
            std::string cppStr(s.UTF8String);
            if(_oglStrokeDict->find(cppStr) != _oglStrokeDict->end())
            {   glDeleteVertexArraysOES(1, &_oglStrokeDict->at(cppStr));
                (*_oglStrokeDict).erase(cppStr);
            }
        }
    }
    else 
    {
        [self.viewPage addPointToCurrentStroke:viewPt];
        OGLQuadrilateral vQuad = [self.viewPage lastQuadAdded];
    
        if([self quadValid:vQuad])
        {
            std::string k(self.viewPage.lastQuadKey.UTF8String);
            (*_oglStrokeDict)[k] = 0;
            glGenVertexArraysOES(1, &(*_oglStrokeDict)[k]);
            glBindVertexArrayOES((*_oglStrokeDict)[k]);
            
            [self addVBAForQuad:vQuad ofColor:self.viewPage.inkColor];
        }
    }
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    if([[event allTouches]count]== 1)
    {
        [self.viewPage startNewStroke];
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)applicationWillResignActive:(NSNotification*)notification
{
    CCSavedDefaults *defaults = [[CCSavedDefaults alloc]init];
    [defaults setLastPaperColor:self.viewPage.backgroundColor];
    [defaults setLastInkColor:self.viewPage.inkColor];
}

-(void)setupNotifications
{
    UIApplication *app = [UIApplication sharedApplication];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(applicationWillResignActive:) name:UIApplicationWillResignActiveNotification object:app];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(widthChanged:) name:@"nibWidthChanged" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(inkColorChange:) name:@"inkColorChanged" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(paperColorChange:) name:@"paperColorChanged" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(tableViewPaperColorChange:) name:@"tableViewPaperColorChanged" object:nil];
    
}

-(void)toggleGuidelines
{
    _viewPage.guideLinesVisible = !_viewPage.guideLinesVisible;
    
    if(!_viewPage.guideLinesVisible)
    {
        self.paperDrawn = NO;
    }
    
    
    
}

#pragma mark - Saving and Loading

-(bool)currentMSHasBeenSaved
{
    return _dataStore.currentMS.hasBeenSaved;
}

-(void)loadManuscriptWithName:(NSString*)name
{
    
    self.dataStore.unsavedChanges = NO;
    [self clearOGLVertexArrays];
    
    Manuscript *ms = [_dataStore manuscriptWithName:name];
    self.viewPage.backgroundColor = ms.paperColorVal;
    [self setGLPaperColor:self.viewPage.backgroundColor];
    
    NSArray *strokeArray = [ms.strokes sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"sequence" ascending:YES]]];
    
    for(Stroke *s in strokeArray)
    {   
        NSArray *quadArray = [s.quads sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"sequence" ascending:YES]]];
        for(StrokeQuad *sQuad in quadArray)
        {
            NSString *key = [NSString stringWithFormat:@"%@%@",s.key,sQuad.key];
            std::string k(key.UTF8String);
            (*_oglStrokeDict)[k] = 0;
            glGenVertexArraysOES(1, &(*_oglStrokeDict)[k]);
            glBindVertexArrayOES((*_oglStrokeDict)[k]);
            
            [self addVBAForQuad:sQuad.oglQuad ofColor:s.inkColorVal];
            
            
        }
        self.viewPage.inkColor = s.inkColorVal;   
    }
    self.paused = NO;
}

-(void)saveManuscriptWithName:(NSString *)name
{
    UIImage *snapshot = [(GLKView*)self.view snapshot];
    [_dataStore saveCurrentContextWithName:name andThumbnail:snapshot];
}

-(void)newManuscript
{   [self clearOGLVertexArrays];
    [_dataStore createNewManuscriptWithPaperColor:self.viewPage.backgroundColor];
}

#pragma mark - Notification callback

-(void)nibWidthChanged:(NSNotification*)notification
{
    [self setupGuidelines];
}

@end
