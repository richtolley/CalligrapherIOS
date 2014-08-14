//
//  CCAlphabetScrollView.h
//  Calligrapher
//
//  Created by Richard Tolley on 16/11/2012.
//  Copyright (c) 2012 Richard Tolley. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CCAlphabetScrollView : UIScrollView
{
    NSString *_currentAlphabet;
    NSString *_currentCase; //miniscule or majuscule
}
@property (nonatomic,strong) UIView *innerView;
-(void)caseChanged:(NSString*)newCase;
@end
