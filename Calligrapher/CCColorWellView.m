//
//  CCColorWellView.m
//  Calligrapher
//
//  Created by Richard Tolley on 04/01/2013.
//  Copyright (c) 2013 Richard Tolley. All rights reserved.
//

#import "CCColorWellView.h"

@implementation CCColorWellView
{
    UIBezierPath *_borderPath;
}

-(void)setColorWellColor:(UIColor *)colorWellColor
{
    _colorWellColor = colorWellColor;
    [self setNeedsDisplay];
}

-(void)awakeFromNib
{

    _borderPath = [[UIBezierPath alloc]init];
    [_borderPath setLineWidth:self.bounds.size.height * 0.02];
    //start at top left
    [_borderPath moveToPoint:self.bounds.origin];
    //top right
    [_borderPath addLineToPoint:CGPointMake(self.bounds.origin.x+self.bounds.size.width, self.bounds.origin.y)];
    //bottom right
    [_borderPath addLineToPoint:CGPointMake(self.bounds.origin.x+self.bounds.size.width, self.bounds.origin.y + self.bounds.size.height)];
    //bottom left
    [_borderPath addLineToPoint:CGPointMake(self.bounds.origin.x, self.bounds.origin.y+self.bounds.size.height)];
    [_borderPath closePath];
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    
   [_borderPath stroke];
    
}


@end
