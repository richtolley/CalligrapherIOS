//
//  CCAlphabetScrollView.m
//  Calligrapher
//
//  Created by Richard Tolley on 16/11/2012.
//  Copyright (c) 2012 Richard Tolley. All rights reserved.
//

#import "CCAlphabetScrollView.h"
#import "UIColor+AppColors.h"
#import "CCAlphabetLetterView.h"
#import "CCNibScriptStyleTableViewController.h"
@implementation CCAlphabetScrollView

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

-(NSMutableArray*)imageFilesForAlphabetName:(NSString*)alphabet letterCase:(NSString*)caseType
{
    const int ASCII_LOWERCASE_START = 97;
    NSMutableArray *retVal = [[NSMutableArray alloc]init];
    for(int i=ASCII_LOWERCASE_START;i<ASCII_LOWERCASE_START + 26;i++)
    {   
        NSString *imageFileName = [NSString stringWithFormat:@"%@_%@_%c.png",alphabet,caseType,(char)i];
        
        UIImage *letterImage = [UIImage imageNamed:imageFileName];
        if(letterImage != nil)
            [retVal addObject:letterImage];
        else NSLog(@"failed to load image with file name: %@",imageFileName);
    }
    
    return retVal;
}

-(void)setup
{
    _currentAlphabet = @"italic";
    _currentCase = @"miniscule";
    [self loadAlphabetWithName:_currentAlphabet andCase:_currentCase];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(alphabetChanged:) name:@"alphabetChanged" object:nil];
}

-(void)loadAlphabetWithName:(NSString*)name andCase:(NSString*)caseType
{
    if(_innerView != nil)
        [_innerView removeFromSuperview];
    
    
    CGFloat innerViewHeight = 100;
    _innerView = [[UIView alloc]init];
    [self setContentSize:_innerView.frame.size];
    self.backgroundColor = [UIColor paperBackgroundColor];
    [self addSubview:_innerView];
    NSMutableArray *letterImages = [self imageFilesForAlphabetName:name letterCase:caseType];
    
    
	// Do any additional setup after loading the view, typically from a nib.
    double cumulativeWidth = 0;
    for(int i=0;i<26;i++)
    {
        double height = self.frame.size.height;
        const double horizontalPadding = 5;
        UIImage *letterImage = letterImages[i];
        double width = letterImage.size.width + (horizontalPadding*2);
        CCAlphabetLetterView *letterView = [[CCAlphabetLetterView alloc]initWithFrame:CGRectMake(cumulativeWidth, 0, width, height)];
        
        UIImageView *letterImageView = [[UIImageView alloc]initWithImage:letterImages[i]];
        letterImageView.backgroundColor = [UIColor clearColor];
        letterView.letterView = letterImageView;
        [_innerView addSubview:letterView];
        self.userInteractionEnabled = YES;
        cumulativeWidth += width;
    }
    
    _innerView.frame = CGRectMake(0, 0, cumulativeWidth+10, innerViewHeight);
     [self setContentSize:_innerView.frame.size];
    [self addSubview:_innerView];
}


-(void)alphabetChanged:(NSNotification*)notification
{
    
    CCNibScriptStyleTableViewController *nibTableView = (CCNibScriptStyleTableViewController*)notification.object;
    _currentAlphabet = nibTableView.currentStyle;
    [self loadAlphabetWithName:_currentAlphabet andCase:_currentCase];
}

-(void)caseChanged:(NSString*)newCase
{
    _currentCase = newCase;
    [self loadAlphabetWithName:_currentAlphabet andCase:_currentCase];
}

-(void)dealloc
{   
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}


@end
