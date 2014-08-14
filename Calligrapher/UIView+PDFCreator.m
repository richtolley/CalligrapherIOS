//
//  UIView+PDFCreator.m
//  Calligrapher
//
//  Created by Richard Tolley on 14/11/2012.
//  Copyright (c) 2012 Richard Tolley. All rights reserved.
//

#import "UIView+PDFCreator.h"
#import <QuartzCore/QuartzCore.h>
@implementation UIView (PDFCreator)

-(void)createPDFfromUIView:(UIView*)view saveToDocumentsWithFileName:(NSString*)fileName
{
    NSMutableData *pdfData = [NSMutableData data];
    
    UIGraphicsBeginPDFContextToData(pdfData, view.bounds, nil);
    UIGraphicsBeginPDFPage();
    
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIGraphicsEndPDFContext();
    
    NSArray *documentDirectories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = documentDirectories[0];
        
    NSString *documentDirectoryFilename = [documentDirectory stringByAppendingPathComponent:fileName];
    [pdfData writeToFile:documentDirectoryFilename atomically:YES];
    
    
}

-(UIImage *)imageFromView
{
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, self.opaque, 0.0);
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage * img = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return img;
}

@end
