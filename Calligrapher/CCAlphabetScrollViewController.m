//
//  CCAlphabetScrollViewController.m
//  Calligrapher
//
//  Created by Richard Tolley on 17/11/2012.
//  Copyright (c) 2012 Richard Tolley. All rights reserved.
//

#import "CCAlphabetScrollViewController.h"
#import "CCAlphabetScrollView.h"
@interface CCAlphabetScrollViewController ()

@end

@implementation CCAlphabetScrollViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
	// Do any additional setup after loading the view.
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(UIView*)viewForZoomingInScrollView:(UIScrollView *)scrollView
{   
    return self.scrollView.innerView;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    
}

-(void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    [self centerScrollViewContents];
}

-(void)centerScrollViewContents
{   
    CGSize boundsSize = self.scrollView.bounds.size;
    CGRect contentsFrame = self.scrollView.frame;
    
    if(contentsFrame.size.width < boundsSize.width)
    {
        contentsFrame.origin.x = (boundsSize.width - contentsFrame.size.width) /2.0f;
        
    }
    else contentsFrame.origin.x = 0.0f;
    
    if(contentsFrame.size.height < boundsSize.height)
        contentsFrame.origin.y = (boundsSize.height - contentsFrame.size.height) / 2.0f;
    else contentsFrame.origin.y = 0.0f;
    
    self.scrollView.frame = contentsFrame;
}



@end
