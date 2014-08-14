//
//  CCSavedDefaults.m
//  Calligrapher
//
//  Created by Richard Tolley on 04/12/2012.
//  Copyright (c) 2012 Richard Tolley. All rights reserved.
//

#import "CCSavedDefaults.h"
#import "UIColor+AppColors.h"
#define kLastMSName @"LastMSName"
#define kLastStyleName @"LastStyleName"
#define kLastNibWidth  @"LastNibWidth"
#define KLastNibAngle  @"LastNibAngle"
#define KLastInkColor  @"LastInkColor"
#define KLastPaperColor @"LastPaperColor"
@implementation CCSavedDefaults

- (id)init
{
    self = [super init];
    if (self) {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSNumber *storedAngle = [defaults objectForKey:KLastNibAngle];
        if(storedAngle == nil)
        {    self.lastNibAngle = 40;
             [defaults setDouble:self.lastNibAngle forKey:KLastNibAngle];
        }
        else self.lastNibAngle = storedAngle.doubleValue;
        
        self.lastNibWidth = [defaults doubleForKey:kLastNibWidth];
        if(self.lastNibWidth == 0)
        {    self.lastNibWidth = 30;
             [defaults setDouble:self.lastNibWidth forKey:kLastNibWidth];
        }
        
        self.lastMSName = [defaults objectForKey:kLastMSName];
        
        self.lastStyleName  = [defaults objectForKey:kLastStyleName];
        if(self.lastStyleName == nil)
        {    self.lastStyleName = @"italic";
             [defaults setValue:self.lastStyleName forKey:kLastStyleName];
        }
    
    }
    return self;
}

-(void)saveDefaults
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:self.lastMSName forKey:kLastMSName];
    [defaults setObject:self.lastStyleName forKey:kLastStyleName];
    NSNumber *storedAngle = [NSNumber numberWithDouble:self.lastNibAngle];
    [defaults setObject:storedAngle forKey:kLastNibWidth];
    [defaults setDouble:self.lastNibWidth forKey:kLastNibWidth];
}

-(UIColor*)colorForKey:(NSString*)key
{
    NSData *colorData = [[NSUserDefaults standardUserDefaults]objectForKey:key];
    if(colorData == nil)
        return nil;
    return [NSKeyedUnarchiver unarchiveObjectWithData:colorData];
}

-(void)setColor:(UIColor*)color forKey:(NSString*)key
{
    NSData *colorData = [NSKeyedArchiver archivedDataWithRootObject:color];
    [[NSUserDefaults standardUserDefaults]setObject:colorData forKey:key];
}


-(UIColor*)lastInkColor
{
    UIColor *color = [self colorForKey:KLastInkColor];
    if(color == nil)
    {
        color = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:1.0];
        [self setLastInkColor:color];
    }
    return color;
}

-(void)setLastInkColor:(UIColor *)lastInkColor
{
    [self setColor:lastInkColor forKey:KLastInkColor];
}

-(UIColor*)lastPaperColor
{
    UIColor *color = [self colorForKey:KLastPaperColor];
    if(color == nil)
    {
        color = [UIColor paperBackgroundColor];
        [self setLastPaperColor:color];
    }
    return color;
}

-(void)setLastPaperColor:(UIColor*)lastPaperColor
{
    [self setColor:lastPaperColor forKey:KLastPaperColor];
}

@end
