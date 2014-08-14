//
//  CCInkConfigureSegue.m
//  Calligrapher
//
//  Created by Richard Tolley on 13/11/2012.
//  Copyright (c) 2012 Richard Tolley. All rights reserved.
//

#import "CCInkConfigureSegue.h"
#import "CCViewController.h"
#import "CCInkConfigViewController.h"
@implementation CCInkConfigureSegue
-(void)perform
{
    CCViewController *src = (CCViewController*) self.sourceViewController;
    if(!src.inkConfigController.isPopoverVisible)
    {
        if(src.nibConfigController.isPopoverVisible)
            [src.nibConfigController dismissPopoverAnimated:NO];
        if(src.paperConfigController.isPopoverVisible)
            [src.paperConfigController dismissPopoverAnimated:NO];
        if(src.loadSaveController.isPopoverVisible)
            [src.loadSaveController dismissPopoverAnimated:NO];
        src.inkConfigController = [[UIPopoverController alloc]initWithContentViewController:(UIViewController*)self.destinationViewController];
        
        [src.inkConfigController presentPopoverFromBarButtonItem:src.inkColorButton permittedArrowDirections:UIPopoverArrowDirectionAny animated:NO];
    }
    else [src.inkConfigController dismissPopoverAnimated:NO];
}
@end
