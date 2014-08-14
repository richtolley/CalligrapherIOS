//
//  CCStrokePointTests.m
//  Calligrapher
//
//  Created by Richard Tolley on 06/11/2012.
//  Copyright (c) 2012 Richard Tolley. All rights reserved.
//

#import "CCStrokePointTests.h"
#import "CCStrokePoint.h"
@implementation CCStrokePointTests
-(void)setUp;
{
}

-(CCStrokePoint*)testPointWithAngle:(double)ang
{
    return [[CCStrokePoint alloc]initWithPoint:CGPointMake(50, 50) Angle:ang width:100];
}

-(void)testVerticalStroke
{
    CCStrokePoint *testPoint =  [self testPointWithAngle:90];
    CGPoint leftPt = testPoint.leftPoint;
    CGPoint rightPt = testPoint.rightPoint;
    
    STAssertEquals(leftPt.x, 50.0f, @"Left point x incorrect, should be 50 was %f",leftPt.x);
    STAssertEquals(leftPt.y, 0.0f, @"Left point y incorrect, should be 0 was %f",leftPt.y);
    STAssertEquals(rightPt.x, 50.0f, @"Left point x incorrect, should be 50 was %f",rightPt.x);
    STAssertEquals(rightPt.y, 100.0f, @"Left point y incorrect, should be 100 was %f",rightPt.y);
    
}

-(void)testHorizontalStroke
{
    CCStrokePoint *testPoint =  [self testPointWithAngle:0];
    CGPoint leftPt = testPoint.leftPoint;
    CGPoint rightPt = testPoint.rightPoint;
    
    STAssertEquals(leftPt.x, 0.0f, @"Left point x incorrect, should be 0 was %f",leftPt.x);
    STAssertEquals(leftPt.y, 50.0f, @"Left point y incorrect, should be 50 was %f",leftPt.y);
    STAssertEquals(rightPt.x, 100.0f, @"Left point x incorrect, should be 100 was %f",rightPt.x);
    STAssertEquals(rightPt.y, 50.0f, @"Left point y incorrect, should be 0 was %f",rightPt.y);
}

-(void)test45DegreeStroke
{
    CCStrokePoint *testPoint =  [self testPointWithAngle:45];
    CGPoint leftPt = testPoint.leftPoint;
    CGPoint rightPt = testPoint.rightPoint;
    
    double x = 35.35534483629908;
    double y = 35.35534483629908;
    
    CGPoint correctLeft = CGPointMake(50.0-x, 50-y);
    CGPoint correctRight = CGPointMake(50.0+x, 50.0+y);
    
    STAssertEqualsWithAccuracy(leftPt.x, correctLeft.x, 3, @"Left point x incorrect, should be %f was %f",correctLeft.x,leftPt.x);
    STAssertEqualsWithAccuracy(leftPt.y, correctLeft.y,3, @"Left point y incorrect, should be %f was %f",correctLeft.y,leftPt.y);
    STAssertEqualsWithAccuracy(rightPt.x, correctRight.x,3, @"Left point x incorrect, should be %f was %f",correctRight.x,rightPt.x);
    STAssertEqualsWithAccuracy(rightPt.y, correctRight.y,3, @"Left point y incorrect, should be %f was %f",correctRight.y,rightPt.y);
    
}


-(void)tearDown
{
    
}

@end
