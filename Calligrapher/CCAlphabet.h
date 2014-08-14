//
//  CCAlphabet.h
//  Calligrapher
//
//  Created by Richard Tolley on 22/11/2012.
//  Copyright (c) 2012 Richard Tolley. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CCAlphabet : NSObject
@property (nonatomic,strong) NSString* name;
@property (nonatomic,strong) NSDictionary* letters;
-(id)initWithFileName:(NSString*)fileName;

@end
