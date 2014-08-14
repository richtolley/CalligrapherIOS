//
//  CCAlphabetLetterView.h
//  Calligrapher
//
//  Created by Richard Tolley on 22/11/2012.
//  Copyright (c) 2012 Richard Tolley. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CCAlphabetLetterView : UIButton
{
    UIImageView *_letterView;
}
@property (nonatomic,strong) UIImageView *letterView;
@end
