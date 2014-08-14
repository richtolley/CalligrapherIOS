//
//  CCColorsTableViewController.h
//  Calligrapher
//
//  Created by Richard Tolley on 04/12/2012.
//  Copyright (c) 2012 Richard Tolley. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CCColorsTableViewController : UITableViewController
{
    NSString *_userDefaultsKeyString;
    NSString *_notificationPostedNameString;
    NSString *_customSelectionNotificationString;
    NSDictionary *_colorDict;
}
@property (nonatomic,strong) UIColor *currentColor;
@property (nonatomic,strong) NSIndexPath *lastIndexPath;
-(void)refreshLastIndexPath;
@end
