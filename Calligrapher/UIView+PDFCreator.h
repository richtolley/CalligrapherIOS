//
//  UIView+PDFCreator.h
//  Calligrapher
//
//  Created by Richard Tolley on 14/11/2012.
//  Copyright (c) 2012 Richard Tolley. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (PDFCreator)

-(void)createPDFfromUIView:(UIView*)view saveToDocumentsWithFileName:(NSString*)fileName;
-(UIImage *)imageFromView;
@end
