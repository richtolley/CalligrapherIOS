//
//  CCSaveViewSegue.m
//  Calligrapher
//
//  Created by Richard Tolley on 27/11/2012.
//  Copyright (c) 2012 Richard Tolley. All rights reserved.
//

#import "CCLoadSaveDialogSegue.h"
#import "CCViewController.h"
#import "CCLoadSaveDialogViewController.h"
@implementation CCLoadSaveDialogSegue
-(void)perform
{
    CCViewController *src = (CCViewController*) self.sourceViewController;
    if(!src.loadSaveController.isPopoverVisible)
    {
        if(src.inkConfigController.isPopoverVisible)
            [src.inkConfigController dismissPopoverAnimated:NO];
        if(src.nibConfigController.isPopoverVisible)
            [src.nibConfigController dismissPopoverAnimated:NO];
        if(src.paperConfigController.isPopoverVisible)
            [src.paperConfigController dismissPopoverAnimated:NO];
        src.loadSaveController = [[UIPopoverController alloc]initWithContentViewController:(UIViewController*)self.destinationViewController];
        CCLoadSaveDialogViewController *dest = (CCLoadSaveDialogViewController*)self.destinationViewController;
        dest.mainController = src;
                [src.loadSaveController presentPopoverFromBarButtonItem:src.loadViewButton permittedArrowDirections:UIPopoverArrowDirectionDown animated:YES];
    }
    else [src.loadSaveController dismissPopoverAnimated:NO];
}
@end
