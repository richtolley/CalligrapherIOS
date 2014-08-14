//
//  CCForceLoadSaveDialogSegue.m
//  Calligrapher
//
//  Created by Richard Tolley on 06/12/2012.
//  Copyright (c) 2012 Richard Tolley. All rights reserved.
//

#import "CCForceLoadSaveDialogSegue.h"
#import "CCViewController.h"
#import "CCLoadSaveDialogViewController.h"
@implementation CCForceLoadSaveDialogSegue
-(void)perform
{
    CCViewController *src = (CCViewController*) self.sourceViewController;
    if(!src.loadSaveController.isPopoverVisible)
    {
        src.loadSaveController = [[UIPopoverController alloc]initWithContentViewController:(UIViewController*)self.destinationViewController];
        CCLoadSaveDialogViewController *dest = (CCLoadSaveDialogViewController*)self.destinationViewController;
        dest.mainController = src;
        [src.loadSaveController presentPopoverFromBarButtonItem:src.loadViewButton permittedArrowDirections:UIPopoverArrowDirectionDown animated:YES];
        [dest save:nil];
    }
}
@end
