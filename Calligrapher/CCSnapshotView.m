//
//  CCSnapshotView.m
//  Calligrapher
//
//  Created by Richard Tolley on 26/01/2013.
//  Copyright (c) 2013 Richard Tolley. All rights reserved.
//

#import "CCSnapshotView.h"
#import "UIView+PDFCreator.h"

@implementation CCSnapshotView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initWithImages:(NSArray*)images
{
    self = [super init];
    if (self) {
        
        for(UIImage *image in images) {
            UIImageView *imageView = [[UIImageView alloc]initWithImage:image];
            [self addSubview:imageView];
        }
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
