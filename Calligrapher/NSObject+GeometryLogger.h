//
//  NSObject+GeometryLogger.h
//  Calligrapher
//
//  Created by Richard Tolley on 21/01/2013.
//  Copyright (c) 2013 Richard Tolley. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (GeometryLogger)
-(void)logRect:(CGRect)r name:(NSString*)name;
-(void)logPoint:(CGPoint)r name:(NSString*)name;
-(void)logSize:(CGSize)r name:(NSString*)name;
@end
