//
//  CCMainScrollView.m
//  Calligrapher
//
//  Created by Richard Tolley on 29/01/2013.
//  Copyright (c) 2013 Richard Tolley. All rights reserved.
//

#import "CCMainScrollView.h"

@implementation CCMainScrollView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
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

-(void)awakeFromNib
{
    for(UIPanGestureRecognizer *gest in self.gestureRecognizers) {
        
        if([gest isKindOfClass:[UIPanGestureRecognizer class]]) {
            gest.minimumNumberOfTouches = 2;
        }
        
    }
    
    
}



@end
