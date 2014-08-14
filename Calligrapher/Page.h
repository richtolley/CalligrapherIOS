//
//  Page.h
//  Calligrapher
//
//  Created by Richard Tolley on 25/01/2013.
//  Copyright (c) 2013 Richard Tolley. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Manuscript;

@interface Page : NSManagedObject
@property (nonatomic) double topMargin;
@property (nonatomic) double bottomMargin;
@property (nonatomic) double leftMargin;
@property (nonatomic) double rightMargin;

@property (nonatomic) double width;
@property (nonatomic) double height;

@property (nonatomic) double lineSpacing;
@property (nonatomic) double nibWidth;

@property (nonatomic, retain) Manuscript *manuscript;

@end
