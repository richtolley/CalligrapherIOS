//
//  CCThinView.h
//  Calligrapher
//
//  Created by Richard Tolley on 04/12/2012.
//  Copyright (c) 2012 Richard Tolley. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CCDataStore;
@class CCCalligraphyStyle;
@class CCViewPage;
@interface CCThinView : UIView
@property (nonatomic,strong) CCViewPage *page;
@property (nonatomic,strong) UIColor *inkColor;
@property double nibAngle;
@property double nibWidth;
@property bool guideLinesVisible;
@property bool unsavedChanges;
@property bool unsavedMS;
@property bool deleteModeActive;
@property bool fullScreenRefreshNeeded;
-(void)clear;
-(void)clearLastStroke;
-(void)loadManuscriptWithName:(NSString*)name fromDataStore:(CCDataStore*)dataStore;
-(void)saveCurrentManuscriptToDataStore:(CCDataStore*)dataStore;
-(void)saveNewManuscriptWithName:(NSString*)name toDataStore:(CCDataStore*)dataStore;

@end
