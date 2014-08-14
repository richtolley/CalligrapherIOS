//
//  CCNibConfigurationView.m
//  Calligrapher
//
//  Created by Richard Tolley on 08/11/2012.
//  Copyright (c) 2012 Richard Tolley. All rights reserved.
//

#import "CCNibConfigurationView.h"
#import "CCNibView.h"
#import "UIColor+AppColors.h"
#import "CCNibConfigurationType.h"
#import "CCNibScriptStyleTableViewController.h"
typedef enum
{
    kNibAngle = 0,
    kNibWidth,
} NibParameterType;

@interface CCNibConfigurationView()
{
    CGAffineTransform _currentRotation;
    IBOutlet UILabel *_nibLabel;
    NibParameterType _parameterType;
}

@end

@implementation CCNibConfigurationView



- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

-(void)awakeFromNib
{
    [self setup];
    
}

-(void)setup
{
    self.backgroundColor = [UIColor paperBackgroundColor];
    [_nibView setNeedsDisplay];
}

-(void)updateLabel
{   
    _nibLabel.text = _parameterType == kNibAngle ? [self nibAngleForLabel] : [self nibWidthForLabel];
}

-(IBAction)segmentChanged:(id)sender
{
    
    @try {
        switch (_segmentedControl.selectedSegmentIndex)
        {
            case kNibAngle:
            { _parameterType = kNibAngle;
              _nibLabel.text = [self nibAngleForLabel];
            }
            break;
            case kNibWidth:
            { _parameterType = kNibWidth;
              _nibView.nibWidth = self.nibWidth;
              [_nibView setNeedsDisplay];
              _nibLabel.text = [self nibWidthForLabel];
            }
            break;
            default: @throw [[NSException alloc]initWithName:@"Bad Nib Parameter type" reason:@"Selected segment does not correspond to a valid value of NibParameterType enum" userInfo:nil];
            break;
        }
    }
    @catch (NSException *exception) {
        NSLog(@"%@:%@",exception.name,exception.reason);
        _parameterType = kNibAngle; //reset to default
    }

    
}

-(double)nibAngleDeg
{
    return _nibView.nibAngleDeg;
}

-(double)nibWidth
{
    return _nibView.nibWidth;
}

#pragma mark Nib Rotation methods

-(CGAffineTransform)rotationAboutViewCenter:(double)rotationInRadians
{   CGAffineTransform retVal = CGAffineTransformIdentity;
    CGAffineTransform translationToOrigin = CGAffineTransformMakeTranslation(-self.center.x, -self.center.y);
    CGAffineTransform translationFromOrigin = CGAffineTransformInvert(translationToOrigin);
    CGAffineTransform rotation = CGAffineTransformMakeRotation(rotationInRadians);
    CGAffineTransformConcat(retVal, translationToOrigin);
    CGAffineTransformConcat(retVal, rotation);
    CGAffineTransformConcat(retVal, translationFromOrigin);
    return retVal;
    
}

-(void)updateNibImageRotation:(double)rotationInRadians
{
    
    double newRotation = _nibAngleRad + rotationInRadians;
    
    if(newRotation > DEGTORAD(90))
        [self rotateNibImageToAngle:DEGTORAD(90.0)];
    else if(newRotation < DEGTORAD(-90))
        [self rotateNibImageToAngle:DEGTORAD(-90.0)];
    else [self rotateNibImageToAngle:newRotation];
    [self setNeedsDisplay];
    
}

-(void)rotateNibImageToAngle:(double)angle
{   
    CGAffineTransform rotation = CGAffineTransformMakeRotation(angle);
    _nibView.transform = rotation;
    _nibAngleRad = angle;
    _nibLabel.text = [self nibAngleForLabel];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"nibAngleChanged" object:self];
}

-(void)makeNibWider
{
    _nibView.nibWidth += 2.0;
    _nibLabel.text = [self nibWidthForLabel];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"nibWidthChanged" object:self];
    [_nibView setNeedsDisplay];
}

-(void)makeNibNarrower
{   
    _nibView.nibWidth -= 2.0;
    _nibLabel.text = [self nibWidthForLabel];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"nibWidthChanged" object:self];
    [_nibView setNeedsDisplay];
}

-(NSString*)nibAngleForLabel
{
    return [NSString stringWithFormat:@"%.0f•",-RADTODEG(_nibAngleRad)];
}

-(NSString*)nibWidthForLabel
{
    return [NSString stringWithFormat:@"%.0f",_nibView.nibWidth / 5.0];
}

-(IBAction)leftAction:(id)sender
{
    if(_parameterType == kNibAngle)
        [self updateNibImageRotation:-DEGTORAD(5.0)];
    else if(_parameterType == kNibWidth)
        [self makeNibNarrower];
    
}
-(IBAction)rightAction:(id)sender
{
    if(_parameterType == kNibAngle)
        [self updateNibImageRotation:DEGTORAD(5.0)];
    else if(_parameterType == kNibWidth)
        [self makeNibWider];
    
}

@end
