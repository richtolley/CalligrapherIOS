//
//  CCCalligraphyStyle.h
//  Calligrapher
//
//  Created by Richard Tolley on 15/11/2012.
//  Copyright (c) 2012 Richard Tolley. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CCCalligraphyStyleNames.h"

@interface CCCalligraphyStyle : NSObject
@property CCCalligraphyStyleName styleNameValue;
@property (nonatomic,strong) NSString *name;
@property double xHeight;
@property double headerXHeight;
@property double footerXheight;
@property double nibAngle;
+(id)styleWithName:(NSString*)name;
+(id)italicStyle;
+(id)gothicStyle;
+(id)foundationalStyle;
+(id)uncialStyle;
+(NSArray*)availableStyles;
@end
