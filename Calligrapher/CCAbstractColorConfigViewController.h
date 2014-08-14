//
//  CCAbstractColorConfigViewController.h
//  Calligrapher
//
//  Created by Richard Tolley on 17/11/2012.
//  Copyright (c) 2012 Richard Tolley. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum
{
    kDecimalColorVals =0,
    kByteColorVals
} ColorTypeEnum;

typedef enum
{
    kStandardColors =0,
    kCustomColors
} ColorChooserEnum;

@class CCSavedDefaults;
@class CCStandardColorsViewController;
@class CCColorWellView;
@interface CCAbstractColorConfigViewController : UIViewController 


@property ColorTypeEnum colorLabelType;
@property ColorChooserEnum colorChooserType;
@property IBOutlet UIView *customColorsView;
@property IBOutlet UIView *standardColorsView;
@property (nonatomic,strong) CCSavedDefaults *defaults;
@property CGFloat red;
@property CGFloat green;
@property CGFloat blue;
@property CGFloat alpha;
@property (nonatomic,strong) UIColor *currentColor;
@property (nonatomic,strong) IBOutlet UISegmentedControl *selectionMenuChooser;
@property (nonatomic,strong) IBOutlet UILabel *redLabel;
@property (nonatomic,strong) IBOutlet UILabel *greenLabel;
@property (nonatomic,strong) IBOutlet UILabel *blueLabel;
@property (nonatomic,strong) IBOutlet UILabel *alphaLabel;

@property (nonatomic,strong) IBOutlet UISlider *redSlider;
@property (nonatomic,strong) IBOutlet UISlider *blueSlider;
@property (nonatomic,strong) IBOutlet UISlider *greenSlider;
@property (nonatomic,strong) IBOutlet UISlider *alphaSlider;

@property (nonatomic,strong) IBOutlet UITextField *hexTextField;

@property (nonatomic,strong) IBOutlet CCColorWellView *colorWell;
@property (nonatomic,strong) IBOutlet UISegmentedControl *colorTypeChooser;

-(IBAction)colorChooserTypeChanged:(id)sender;
-(IBAction)colorTypeChoiceChanged:(id)sender;
-(NSString*)hexString;
-(int)valToRawInt:(double)val;
-(void)setRgbValsForColor:(UIColor*)newColor;
-(void)refreshColorWell;
-(NSString*)redLabelValue;
-(NSString*)greenLabelValue;
-(NSString*)blueLabelValue;
-(NSString*)alphaLabelValue;

-(void)updateLabels;
-(void)updateSliders;
@end
