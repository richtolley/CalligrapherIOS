//
//  CCNibConfigureSegue.m
//  Calligrapher
//
//  Created by Richard Tolley on 13/11/2012.
//  Copyright (c) 2012 Richard Tolley. All rights reserved.
//

#import "CCNibConfigureSegue.h"
#import "CCViewController.h"
#import "CCNibConfigurationViewController.h"
@implementation CCNibConfigureSegue

-(void)perform
{
    CCViewController *src = (CCViewController*) self.sourceViewController;
    if(!src.nibConfigController.isPopoverVisible)
    {
        if(src.paperConfigController.isPopoverVisible)
            [src.paperConfigController dismissPopoverAnimated:NO];
        if(src.inkConfigController.isPopoverVisible)
            [src.inkConfigController dismissPopoverAnimated:NO];
        if(src.loadSaveController.isPopoverVisible)
            [src.loadSaveController dismissPopoverAnimated:NO];
        src.nibConfigController = [[UIPopoverController alloc]initWithContentViewController:(UIViewController*)self.destinationViewController];
        [src.nibConfigController presentPopoverFromBarButtonItem:src.nibConfigButton permittedArrowDirections:UIPopoverArrowDirectionAny animated:NO];
    }
    else [src.nibConfigController dismissPopoverAnimated:NO];
}

@end
