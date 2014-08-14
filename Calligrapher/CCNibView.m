//
//  CCNibView.m
//  Calligrapher
//
//  Created by Richard Tolley on 15/11/2012.
//  Copyright (c) 2012 Richard Tolley. All rights reserved.
//

#import "CCNibView.h"



@interface CCNibView()
{
    double _nibWidthPixels;
    double _nibBodyWidth;
    double _nibBodyHeight;
    double _nibTipHeight;
    double _nibEdgeYVal;
    UIBezierPath *_nibPath;
    UIBezierPath *_nibSplit;
    UIBezierPath *_nibHole;
    
    
    //Buttons
    IBOutlet UIButton *_leftSideButton;
    IBOutlet UIButton *_rightSideButton;
    UIImage *_upImage;
    UIImage *_downImage;
    UIImage *_leftImage;
    UIImage *_rightImage;
    UILabel *_nibNumberLabel;
    
    CGSize _offset;
}
@end


@implementation CCNibView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

-(CCNibConfigurationType)type
{
    return _type;
}

-(void)setType:(CCNibConfigurationType)type
{
    _type = type;
    [self updateButtonImages];
}

-(double)nibWidth
{
    return _nibWidth;
}

-(void)setNibWidth:(double)nibWidth
{
    if(nibWidth > _maxNibWidth)
        _nibWidth = _maxNibWidth;
    else if(nibWidth < _minNibWidth)
        _nibWidth = _minNibWidth;
    else _nibWidth = nibWidth;
}


-(double)nibAngleDeg
{
    return -RADTODEG(_nibAngleRad);
}

-(void)awakeFromNib
{   
    [self setup];
}

-(void)setup
{   
    _type = nibAngleConfiguration;
    _nibWidthPixels = 30;
    
    _minNibWidth = 5;
    _maxNibWidth = 45;
    _nibBodyWidth = 60;
    _nibBodyHeight = 105;
    _offset = CGSizeMake(-85, -50);
    _nibTipHeight = _nibBodyHeight/3.0;
    _nibEdgeYVal =  self.center.y - _nibBodyHeight/2.0 - _nibTipHeight;
    _nibColor = [UIColor colorWithRed:0.81 green:0.53 blue:0.44 alpha:1.0];
    _leftShadow = [UIColor colorWithPatternImage:[UIImage imageNamed:@"leftShadow.png"]];
    _rightShadow = [UIColor colorWithPatternImage:[UIImage imageNamed:@"rightShadow.png"]];
    self.backgroundColor = [UIColor clearColor];
    [self setupButtonImages];
    
}


#pragma mark Button setup

-(void)setupButtonImages
{
    _leftImage = [UIImage imageNamed:@"leftHand.png"];
    _rightImage = [UIImage imageNamed:@"rightHand.png"];
    _upImage = [UIImage imageNamed:@"upHand.png"];
    _downImage = [UIImage imageNamed:@"downHand.png"];
}

-(void)updateButtonImages
{
    if(_type == nibAngleConfiguration)
    {
        _leftSideButton.imageView.image = _downImage;
        _rightSideButton.imageView.image = _upImage;
    }
    else if(_type == nibWidthConfiguration)
    {
        _leftSideButton.imageView.image = _leftImage;
        _rightSideButton.imageView.image = _rightImage;
    }
}



// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    [self drawNibOutline];
    [self drawNibSplitAndHole];

}

-(void)drawNibSplitAndHole
{
    double nibSlitWidth = 1.0;
    double nibSlitHeight = _nibTipHeight*1.5;
    CGPoint nibSplitStart = CGPointMake(self.center.x-nibSlitWidth/2.0,self.center.y-_nibTipHeight-(_nibBodyHeight/2.0));
    CGRect nibSlitRect = CGRectMake(nibSplitStart.x+_offset.width, nibSplitStart.y+_offset.height, nibSlitWidth, nibSlitHeight);
    _nibSplit = [UIBezierPath bezierPathWithRect:nibSlitRect];
    [[UIColor blackColor]setFill];
    double nibHoleDiameter = nibSlitWidth * 12.0;
    CGRect nibHoleRect = CGRectMake(self.center.x-nibHoleDiameter/2.0+_offset.width,self.center.y-40+_offset.height,nibHoleDiameter,nibHoleDiameter);
    _nibHole = [UIBezierPath bezierPathWithOvalInRect:nibHoleRect];
    [[UIColor blackColor]setFill];
    [_nibSplit fill];
    [_nibHole fill];
}

-(void)drawNibOutline
{   [_nibColor setFill];
    double nibTipHeight = _nibBodyHeight/3.0;
    CGPoint tl,tr,bl,br; //corners of nib square
    CGPoint nibLeftEdge,nibRightEdge;
   
    tl = CGPointMake(self.center.x-_nibBodyWidth/2.0+_offset.width, self.center.y-_nibBodyHeight/2.0 + _offset.height);
    tr = CGPointMake(self.center.x+_nibBodyWidth/2.0+_offset.width, self.center.y-_nibBodyHeight/2.0 + _offset.height);
    bl = CGPointMake(self.center.x-_nibBodyWidth/2.0+_offset.width, self.center.y+_nibBodyHeight/2.0 + _offset.height);
    br = CGPointMake(self.center.x+_nibBodyWidth/2.0+_offset.width, self.center.y+_nibBodyHeight/2.0 + _offset.height);
    
    double nibEdgeYVal =  self.center.y - _nibBodyHeight/2.0 - nibTipHeight + _offset.height;
    nibLeftEdge = CGPointMake(self.center.x-_nibWidth/2.0 + _offset.width,nibEdgeYVal);
    nibRightEdge = CGPointMake(self.center.x+_nibWidth/2.0 + _offset.width,nibEdgeYVal);
    
    CGPoint leftEdgeControl = CGPointMake(self.center.x-_nibWidth/2.0 + _offset.width,nibLeftEdge.y+nibTipHeight);
    CGPoint rightEdgeControl = CGPointMake(self.center.x+_nibWidth/2.0 + _offset.width,nibRightEdge.y+nibTipHeight);
    _nibPath = [[UIBezierPath alloc]init];
    //Move around nib perimeter starting at top right corner of nib. Close path draws a straight line which
    //is the nib blade itself
    [_nibPath moveToPoint:nibRightEdge];
    [_nibPath addQuadCurveToPoint:tr controlPoint:rightEdgeControl];
    [_nibPath addLineToPoint:br];
    [_nibPath addLineToPoint:bl];
    [_nibPath addLineToPoint:tl];
    [_nibPath addQuadCurveToPoint:nibLeftEdge controlPoint:leftEdgeControl];
    [_nibPath closePath];
    
    [_nibPath fill];
    [_leftShadow setFill];
    [_nibPath fill];
    [_rightShadow setFill];
    [_nibPath fill];
}

-(void)drawNibLabel
{
    UIImage *halfImage = [UIImage imageNamed:@"half.png"];
    
    double numberWidth = _nibBodyWidth/4.0;
    double numberHeight = _nibBodyHeight/4.0;
    _nibNumberLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.center.x-numberWidth/2.0, self.center.y-20, numberWidth,numberHeight)];
    [halfImage drawInRect:CGRectMake(_nibNumberLabel.frame.origin.x+_nibNumberLabel.frame.size.width, _nibNumberLabel.frame.origin.y, _nibNumberLabel.frame.size.width, _nibNumberLabel.frame.size.height)];
    _nibNumberLabel.text = [self nibLabelWidth];
    _nibNumberLabel.font = [UIFont fontWithName:@"Cochin" size:40];
    _nibNumberLabel.textAlignment = NSTextAlignmentCenter;
    _nibNumberLabel.backgroundColor = [UIColor clearColor];
    [self addSubview:_nibNumberLabel];
}

#pragma mark Nib Label methods

-(NSString*)nibLabelWidth
{
    return [NSString stringWithFormat:@"%.0f",_nibWidth/5.0];
}






@end
