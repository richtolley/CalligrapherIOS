//
//  CCCalligraphyStyle.m
//  Calligrapher
//
//  Created by Richard Tolley on 15/11/2012.
//  Copyright (c) 2012 Richard Tolley. All rights reserved.
//

#import "CCCalligraphyStyle.h"
#import "CCNibScriptStyleTableViewController.h"
#import "CCNibView.h"
@implementation CCCalligraphyStyle



+(id)styleWithName:(NSString*)name;
{
    if([name isEqualToString:@"italic"])
        return [CCCalligraphyStyle italicStyle];
    if([name isEqualToString:@"gothic"])
        return [CCCalligraphyStyle gothicStyle];
    
    if([name isEqualToString:@"foundational"])
        return [CCCalligraphyStyle foundationalStyle];
    if([name isEqualToString:@"uncial"])
        return [CCCalligraphyStyle uncialStyle];
    return nil;
}

- (id)init
{
    self = [super init];
    if (self) {
        [self setupNotifications];
    }
    return self;
}

-(void)setupNotifications
{
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(angleChanged:) name:@"nibAngleChanged" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(alphabetChange:) name:@"alphabetChanged" object:nil];
    
}

+(id)italicStyle
{
    CCCalligraphyStyle *retVal = [[CCCalligraphyStyle alloc]init];
    retVal.styleNameValue = kItalic;
    retVal.name = @"italic";
    retVal.nibAngle = 45;
    retVal.xHeight = 5;
    retVal.footerXheight = 3;
    retVal.headerXHeight = 3;
    return retVal;
}
+(id)gothicStyle
{
    CCCalligraphyStyle *retVal = [[CCCalligraphyStyle alloc]init];
    retVal.styleNameValue = kGothic;
    retVal.name = @"gothic";
    retVal.nibAngle = 40;
    retVal.xHeight = 5;
    retVal.footerXheight = 2;
    retVal.headerXHeight = 2;
    return retVal;
}
+(id)foundationalStyle
{
    CCCalligraphyStyle *retVal = [[CCCalligraphyStyle alloc]init];
    retVal.styleNameValue = kFoundational;
    retVal.name = @"foundational";
    retVal.nibAngle = 30;
    retVal.xHeight = 4;
    retVal.footerXheight = 3;
    retVal.headerXHeight = 3;
    return retVal;
}
+(id)uncialStyle
{
    CCCalligraphyStyle *retVal = [[CCCalligraphyStyle alloc]init];
    retVal.styleNameValue = kUncial;
    retVal.name = @"uncial";
    retVal.nibAngle = 25;
    retVal.xHeight = 4;
    retVal.footerXheight = 3;
    retVal.headerXHeight = 3;
    return retVal;
}

+(NSArray*)availableStyles
{
    return @[@"italic",@"foundational",@"gothic",@"uncial"];
}

-(void)alphabetChange:(NSNotification*)notification
{
    CCNibScriptStyleTableViewController *nibController = (CCNibScriptStyleTableViewController*)notification.object;
    _nibAngle = -[nibController nibAngleForStyle:nibController.currentStyle];
    
    
}

-(void)angleChanged:(NSNotification*)notification
{
    CCNibView *nibView = (CCNibView*)notification.object;
    _nibAngle = -nibView.nibAngleRad * 180.0/M_PI;
    [[NSUserDefaults standardUserDefaults]setDouble:_nibAngle forKey:@"LastNibAngle"];
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}



@end
