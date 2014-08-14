//
//  CCHexStringParserTests.m
//  Calligrapher
//
//  Created by Richard Tolley on 09/11/2012.
//  Copyright (c) 2012 Richard Tolley. All rights reserved.
//

#import "CCHexStringParserTests.h"

@implementation CCHexStringParserTests

-(void)setUp
{
    _hexStringParser = [[HexStringParser alloc]init];
}

-(void)testHexCharConversions
{
    char hexLetters[] = {'0','1','2','3','4','5','6','7','8','9','A','B','C','D','E','F'};
    for(int i=0;i<16;i++)
    {
        int result = [_hexStringParser hexCharToInt:hexLetters[i]];
        STAssertEquals(i, result, [NSString stringWithFormat:@"Hex letter %c returned int %d, should have been %d",hexLetters[i],result,i]);
    }
    char hexLettersLowerCase[] = {'a','b','c','d','e','f'};
    for(int i=10;i<16;i++)
    {
        int result = [_hexStringParser hexCharToInt:hexLettersLowerCase[i]];
        STAssertEquals(i, result, [NSString stringWithFormat:@"Hex letter %c returned int %d, should have been %d",hexLetters[i],result,i]);
    }
    
}

@end
