//
//  CCOGLViewController.h
//  Calligrapher
//
//  Created by Richard Tolley on 27/01/2013.
//  Copyright (c) 2013 Richard Tolley. All rights reserved.
//

#import <GLKit/GLKit.h>
@class CCDataStore;
@class CCViewPage;
@interface CCOGLViewController : GLKViewController

@property (nonatomic,strong) CCDataStore *dataStore;
@property (nonatomic,strong) CCViewPage *viewPage;
@property (nonatomic,strong,readonly) NSString *currentMSName;
-(void)clear;
@property (nonatomic,strong) UIColor *paperColor;
@property (nonatomic,strong) UIColor *inkColor;
-(void)setupGL;
-(void)setGLPaperColor:(UIColor*)color;
-(void)setupGuidelines;
-(void)toggleGuidelines;
-(void)loadManuscriptWithName:(NSString*)name;
-(void)saveManuscriptWithName:(NSString*)name;
-(bool)currentMSHasBeenSaved;
-(void)newManuscript;
@end
