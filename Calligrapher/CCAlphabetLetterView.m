//
//  CCAlphabetLetterView.m
//  Calligrapher
//
//  Created by Richard Tolley on 22/11/2012.
//  Copyright (c) 2012 Richard Tolley. All rights reserved.
//

#import "CCAlphabetLetterView.h"

@implementation CCAlphabetLetterView

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

-(UIImageView*)letterView
{
    return _letterView;
}

-(void)setLetterView:(UIImageView *)letterView
{;
    
    letterView.frame = CGRectMake(letterView.frame.origin.x+10,letterView.frame.origin.y+30,letterView.frame.size.width,letterView.frame.size.height);
        _letterView = letterView;
    [self addSubview:_letterView];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSLog(@"touches began in letterView");
    
}

@end
