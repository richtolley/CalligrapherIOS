//
//  CCPaperConfigureSegue.m
//  Calligrapher
//
//  Created by Richard Tolley on 15/11/2012.
//  Copyright (c) 2012 Richard Tolley. All rights reserved.
//

#import "CCPaperConfigureSegue.h"
#import "CCViewController.h"
#import "CCPaperConfigViewController.h"
@implementation CCPaperConfigureSegue
-(void)perform
{   
    CCViewController *src = (CCViewController*) self.sourceViewController;
    if(!src.paperConfigController.isPopoverVisible)
    {
        if(src.inkConfigController.isPopoverVisible)
            [src.inkConfigController dismissPopoverAnimated:NO];
        if(src.nibConfigController.isPopoverVisible)
            [src.nibConfigController dismissPopoverAnimated:NO];
        if(src.loadSaveController.isPopoverVisible)
            [src.loadSaveController dismissPopoverAnimated:NO];
        src.paperConfigController = [[UIPopoverController alloc]initWithContentViewController:(UIViewController*)self.destinationViewController];
        
        
        
        [src.paperConfigController presentPopoverFromBarButtonItem:src.paperColorButton permittedArrowDirections:UIPopoverArrowDirectionAny animated:NO];
    }
    else [src.paperConfigController dismissPopoverAnimated:NO];
}
@end
