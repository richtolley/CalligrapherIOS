//
//  CCStandardColorTableViewCell.m
//  Calligrapher
//
//  Created by Richard Tolley on 17/11/2012.
//  Copyright (c) 2012 Richard Tolley. All rights reserved.
//

#import "CCColorTableViewCell.h"

@implementation CCColorTableViewCell

-(void)awakeFromNib
{
    UIView *borderView = [[UIView alloc]initWithFrame:CGRectMake(180, 5, 100, 30)];
    borderView.backgroundColor = [UIColor blackColor];
    [self addSubview:borderView];
    _colorView = [[UIView alloc]initWithFrame:CGRectMake(1, 1, 98, 28)];
    [borderView addSubview:_colorView];
}

@end
