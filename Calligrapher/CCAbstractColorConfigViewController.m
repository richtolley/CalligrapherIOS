//
//  CCAbstractColorConfigViewController.m
//  Calligrapher
//
//  Created by Richard Tolley on 17/11/2012.
//  Copyright (c) 2012 Richard Tolley. All rights reserved.
//

#import "CCAbstractColorConfigViewController.h"
#import "CCSavedDefaults.h"
#import "UIColor+ColorLogger.h"
#import "CCColorWellView.h"
@interface CCAbstractColorConfigViewController ()

@end

@implementation CCAbstractColorConfigViewController

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
    _defaults = [[CCSavedDefaults alloc]init];
    [self updateLabels];
	// Do any additional setup after loading the view.
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self updateLabels];
    [self updateSliders];
    self.customColorsView.hidden = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)colorChooserTypeChanged:(id)sender
{
    self.standardColorsView.hidden = !self.standardColorsView.hidden;
    self.customColorsView.hidden = !self.customColorsView.hidden;

}

-(IBAction)colorTypeChoiceChanged:(id)sender
{
    self.colorLabelType = self.colorTypeChooser.selectedSegmentIndex;
    [self updateLabels];
}


-(void)setRgbValsForColor:(UIColor*)newColor
{
    CGFloat r,g,b,a;
    [newColor getRed:&r green:&g blue:&b alpha:&a];
    self.redSlider.value =  self.red = r;
    self.greenSlider.value = self.green = g;
    self.blueSlider.value = self.blue = b;
    self.alpha = a;
}


-(NSString*)stringValueForColorVal:(double)val
{
    
    if(self.colorLabelType == kDecimalColorVals)
    {
        return [NSString stringWithFormat:@"%.2f",val];
    }
    else if(self.colorLabelType == kByteColorVals) //not strictly necessary, for readability
    {
        return [NSString stringWithFormat:@"%2d",[self valToRawInt:val]];
    }
    return @"";
}

-(NSString*)redLabelValue
{
    return [self stringValueForColorVal:self.red];
}
-(NSString*)greenLabelValue
{
    return [self stringValueForColorVal:self.green];
}
-(NSString*)blueLabelValue
{
    return [self stringValueForColorVal:self.blue];
}
-(NSString*)alphaLabelValue
{
    return [self stringValueForColorVal:self.alpha];
}

-(void)updateLabels
{
    self.redLabel.text = [self redLabelValue];
    self.blueLabel.text = [self blueLabelValue];
    self.greenLabel.text  = [self greenLabelValue];
    self.alphaLabel.text = [self alphaLabelValue];
    self.hexTextField.text = [self hexString];
}

-(void)updateSliders
{
    self.redSlider.value = self.red;
    self.greenSlider.value = self.green;
    self.blueSlider.value = self.blue;
    self.alphaSlider.value = self.alpha;
}

-(void)refreshColorWell
{
    UIColor *newColor = [UIColor colorWithRed:self.red green:self.green blue:self.blue alpha:self.alpha];

    self.currentColor = newColor;
    self.colorWell.backgroundColor = newColor;
    self.colorWell.hidden = NO;
}

//One method handles all slider movements
-(IBAction)sliderValueChanged:(id)sender
{
    self.red = self.redSlider.value;
    self.green = self.greenSlider.value;
    self.blue = self.blueSlider.value;
    self.alpha = self.alphaSlider.value;
    [self refreshColorWell];
    [self updateLabels];
}

-(void)setColorFromTableView:(UIColor*)newColor
{
    //implemented in concrete classes
}

-(int)valToRawInt:(double)val
{
    return (int)255.0*val;
}

-(NSString*)valToHex:(double)val
{
    int rawInt = [self valToRawInt:val];
    char letterOne = [self hexLetter:rawInt/16];
    char letterTwo = [self hexLetter:rawInt%16];
    
    return [NSString stringWithFormat:@"%c%c",letterOne,letterTwo];
}

-(NSString*)hexString
{
    return [NSString stringWithFormat:@"#%@%@%@",[self valToHex:self.red],[self valToHex:self.green],[self valToHex:self.blue]];
}

-(IBAction)keyboardDone:(id)sender
{
    [sender resignFirstResponder];
}


-(char)hexLetter:(int)num
{
    const int ASCIINumberOffset = 48;
    @try {
        
        if(num < 0)
            @throw [[NSException alloc]initWithName:@"Bad hex conversion value" reason:@"Hex digit value less than zero" userInfo:nil];
        if(num <= 9)
        {
            return (char)num + ASCIINumberOffset;
        }
        else switch(num)
        {
            case 10: return 'A'; break;
            case 11: return 'B'; break;
            case 12: return 'C'; break;
            case 13: return 'D'; break;
            case 14: return 'E'; break;
            case 15: return 'F'; break;
            default: @throw [[NSException alloc]initWithName:@"Bad hex conversion value" reason:[NSString stringWithFormat:@"Hex digit value greater than 15- value was %d",num] userInfo:nil];
        }
    }
    @catch (NSException *exception) {
        NSLog(@"%@",[exception reason]);
        return 'X';
    }
    
    
    
}

@end
