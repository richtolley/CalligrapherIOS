//
//  CCNibScriptStyleTableViewController.h
//  Calligrapher
//
//  Created by Richard Tolley on 23/11/2012.
//  Copyright (c) 2012 Richard Tolley. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CCCalligraphyStyle.h"
@interface CCNibScriptStyleTableViewController : UITableViewController
{
    NSArray *_styleNames;
    NSDictionary *_penAngleDict;
}
@property (nonatomic,strong) NSString *currentStyle;
@property (nonatomic,strong) NSIndexPath *lastIndexPath;
-(double)nibAngleForStyle:(NSString*)style;
@end
