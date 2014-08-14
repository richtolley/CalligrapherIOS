//
//  HexStringParser_TestExtensions.h
//  Calligrapher
//
//  Created by Richard Tolley on 09/11/2012.
//  Copyright (c) 2012 Richard Tolley. All rights reserved.
//

#import "HexStringParser.h"
//Renders private methods public for unit testing
@interface HexStringParser (TestExtensions)

-(int)hexCharToInt:(char)hexChar;
@end
