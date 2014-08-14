//
//  CCAlphabetScrollViewController.h
//  Calligrapher
//
//  Created by Richard Tolley on 17/11/2012.
//  Copyright (c) 2012 Richard Tolley. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CCAlphabetScrollView;
@interface CCAlphabetScrollViewController : UIViewController <UIScrollViewDelegate>
@property (nonatomic,strong) IBOutlet CCAlphabetScrollView *scrollView;
@property (nonatomic,strong) IBOutlet UIView *innerView;
@end
