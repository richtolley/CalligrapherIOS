//
//  CCViewController.m
//  Calligrapher
//
//  Created by Richard Tolley on 06/11/2012.
//  Copyright (c) 2012 Richard Tolley. All rights reserved.
//

#import "CCViewController.h"
#import "CCOGLViewController.h"
#import "CCAlphabetScrollViewController.h"
#import "CCAlphabetScrollView.h"
#import "CCAppDelegate.h"
#import "CCColorWellView.h"
#import "UIView+ThumbnailCreator.h"
#import "CCSavedWorkViewController.h"
#import "UIColor+ColorLogger.h"
#import "CCInkConfigViewController.h"
#import "CCPaperColorsTableViewController.h"
#import "CCNibScriptStyleTableViewController.h"
#import "NSObject+ForegroundColorForBackgroundColor.h"
#import "CCDataStore.h"
#import "CCSavedDefaults.h"
#import "CCViewPage.h"
#import "CCCalligraphyView.h"

#define kIconSize CGSizeMake(100, 100)
#define SCROLL_MIN_PERCENT 0.0
#define SCROLL_MAX_PERCENT self.view.bounds.size.height * 3

enum
{
    kMiniscule = 0,
    kMajuscule,
};

@interface CCViewController ()
{
    IBOutlet UIBarButtonItem *_nibConfigButton;
    bool _alphabetScrollViewVisible;
    bool _textViewVisible;
    CGFloat _alphabetAnimationDuration;
    NSString *_fileNameToDeleteOrSave; //temp ivar used to pass file name to delete to alertview delegate method
    
    
}
@property (nonatomic,strong) CCOGLViewController *oglController;

@end

@implementation CCViewController

- (void)viewDidLoad
{   
    [super viewDidLoad];
    _oglController = [[CCOGLViewController alloc]initWithNibName:nil bundle:nil];
    _oglController.view = self.calligraphyView;
    [_oglController setupGL];
    
    self.scrollView.maximumZoomScale = 3;
    self.scrollView.minimumZoomScale = 0.5;
    self.scrollView.backgroundColor = [UIColor darkGrayColor];
   
    self.navigationItem.title = [NSString stringWithFormat:@"Calligrapher - %@",_oglController.currentMSName];
    
    self.paperColorButton.tintColor = _oglController.viewPage.backgroundColor;
    self.inkColorButton.tintColor = _oglController.viewPage.inkColor;
    
    [self setupAlphabetView];
    [self setupNotifications];
    
}

-(void)viewDidAppear:(BOOL)animated
{
    
    _oglController.paused = NO;
}


-(void)setupAlphabetView
{
    _alphabetAnimationDuration = 0.5;
    _textView.backgroundColor = [UIColor paperBackgroundColor];
    _textView.textColor = [UIColor blackColor];
    _textView.font = [UIFont fontWithName:@"Cochin" size:18];
    _textView.text = @"The Italic hand was derived from Carolingian miniscules by Renaissance humanist scholars in the 15th Century";
    
    _alphabetScrollViewVisible = NO;
}

-(void)setupNotifications
{
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(appDidBecomeActive:) name:UIApplicationDidBecomeActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(alphabetChanged:) name:@"alphabetChanged" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(inkColorChange:) name:@"inkColorChanged" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(paperColorChange:) name:@"paperColorChanged" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(tableViewPaperColorChange:) name:@"tableViewPaperColorChanged" object:nil];
    
}

-(void)awakeFromNib
{   
    self.navigationController.toolbar.tintColor = [UIColor brownColor];
}

-(NSString*)currentMSName
{
    return _oglController.currentMSName;
}

-(IBAction)toggleGuidelines:(id)sender
{
    [_oglController toggleGuidelines];
    _guideLinesButton.title =  _oglController.viewPage.guideLinesVisible ? @"Hide Guidelines" : @"Show Guidelines";

}

#pragma mark -
#pragma mark Loading and Saving

-(void)saveToPhotoAlbum
{
    UIImage *image = [self.calligraphyView snapshot];
    UIImageWriteToSavedPhotosAlbum(image,nil, nil, nil);
}

-(IBAction)clear:(id)sender
{   
    [_oglController clear];
}


-(void)newManuscript
{
    if(_oglController.dataStore.unsavedChanges)
    {
        UIAlertView *unsavedChangesAlert = [[UIAlertView alloc]initWithTitle:@"Changes have not been saved" message:@"The current manuscript contains unsaved changes" delegate:self cancelButtonTitle:@"Discard changes" otherButtonTitles:@"Save and continue", nil];
        [unsavedChangesAlert show];
        
    }
    else 
    {
        
        [_oglController newManuscript];
        self.navigationItem.title = [NSString stringWithFormat:@"Calligrapher - %@",[_oglController currentMSName]];
    }
    
    [self.loadSaveController dismissPopoverAnimated:YES];
}
-(void)saveManuscriptWithFileName:(NSString*)fileName
{   
    if(![_oglController currentMSHasBeenSaved])
    {
        if([_oglController.dataStore filenameAlreadyExists:fileName])
        {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"File already exists" message:@"Choose a different filename" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil, nil];
            _fileNameToDeleteOrSave = fileName;
            [alert show];
        }
        else
        {   [_oglController saveManuscriptWithName:fileName];
            self.navigationItem.title = [NSString stringWithFormat:@"Calligrapher - %@",self.currentMSName];
        
        }
    }
    else
    {   
        [_oglController saveManuscriptWithName:fileName];
         self.navigationItem.title = [NSString stringWithFormat:@"Calligrapher - %@",[_oglController currentMSName]]; 
    
    }
    [self.loadSaveController dismissPopoverAnimated:YES];
}

-(void)deleteCurrentManuscript
{
    [self deleteManuscriptWithFileName:self.currentMSName];
    
}

-(void)deleteManuscriptWithFileName:(NSString*)fileName
{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Deleting Manuscript" message:@"Are you sure you want to delete this manuscript?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Delete", nil];
    _fileNameToDeleteOrSave = fileName;
    [alert show];
    
    [self.loadSaveController dismissPopoverAnimated:YES];
}

-(void)loadManuscriptWithName:(NSString*)msName
{
    if(_oglController.dataStore.unsavedChanges)
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Loading Manuscript" message:@"Current manuscript has unsaved changes" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Save and Load", nil];
        _fileNameToDeleteOrSave = msName;
        [alert show];
    }
    else
    {
        [_oglController loadManuscriptWithName:msName];
        self.navigationItem.title = [NSString stringWithFormat:@"Calligrapher- %@",self.currentMSName];
        self.inkColorButton.tintColor = _oglController.viewPage.inkColor;
        self.paperColorButton.tintColor = _oglController.viewPage.backgroundColor;
    }
}


#pragma mark -
#pragma mark Saved Work Controller Methods

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"SavedWorkSegue"])
    {
        CCSavedWorkViewController *savedWorkController = (CCSavedWorkViewController*)segue.destinationViewController;
        savedWorkController.mainViewController = self;
    }
    
}

-(void)pushSavedWordController
{
    CCSavedWorkViewController *saveWorkController = [[CCSavedWorkViewController alloc]init];
    [self.navigationController pushViewController:saveWorkController animated:YES];
}

#pragma mark -
#pragma mark Alphabet scroll view methods

-(IBAction)toggleAlphabetScrollView:(id)sender
{
    if(_textViewVisible) //If the text view is currently visible, it needs to be hidden first
    {
        [self toggleTextViewWithAlphabetViewVisible];
    }
    else
    {
    
        double alphabetViewHeight = _alphabetScrollOuterView.frame.size.height;
        double yMovement = _alphabetScrollViewVisible ? -alphabetViewHeight:alphabetViewHeight;
        
        _alphabetScrollViewVisible = !_alphabetScrollViewVisible;
        [UIView animateWithDuration:_alphabetAnimationDuration animations:^(){
            
            CGRect oldRect = _alphabetScrollOuterView.frame;
            _alphabetScrollOuterView.frame = CGRectMake(oldRect.origin.x,oldRect.origin.y+yMovement,oldRect.size.width,oldRect.size.height);
            CGRect oldTextRect = _textContainerView.frame;
            _textContainerView.frame = CGRectMake(oldTextRect.origin.x,oldTextRect.origin.y+yMovement,oldTextRect.size.width,oldTextRect.size.height);
            
        }completion:^(BOOL finished){
            
            _alphabetScrollViewButton.title = _alphabetScrollViewVisible ? @"Hide Alphabet" : @"Show Alphabet";
            
        }];
    }
    
}

-(IBAction)toggleTextView:(id)sender
{
    double textViewHeight = _textContainerView.frame.size.height;
    double yMovement = _textViewVisible ? -textViewHeight:textViewHeight;
    
    _textViewVisible = !_textViewVisible;
    [UIView animateWithDuration:_alphabetAnimationDuration animations:^(){
        
        CGRect oldTextRect = _textContainerView.frame;
        _textContainerView.frame = CGRectMake(oldTextRect.origin.x,oldTextRect.origin.y+yMovement,oldTextRect.size.width,oldTextRect.size.height);
        
    }completion:^(BOOL finished){
        
        CGRect frame = _textView.frame;
        frame.size.height += 1;
        _textView.frame = frame;
    }];
}

-(void)toggleTextViewWithAlphabetViewVisible
{
    double textViewHeight = _textContainerView.frame.size.height;
    double yMovement = _textViewVisible ? -textViewHeight:textViewHeight;
    
    _textViewVisible = !_textViewVisible;
    [UIView animateWithDuration:_alphabetAnimationDuration animations:^(){
        
        CGRect oldTextRect = _textContainerView.frame;
        _textContainerView.frame = CGRectMake(oldTextRect.origin.x,oldTextRect.origin.y+yMovement,oldTextRect.size.width,oldTextRect.size.height);
        
    }completion:^(BOOL finished){
        [self toggleAlphabetScrollView:nil];
    }];
}

-(IBAction)toggleDeleteMode:(id)sender
{
    if(_oglController.viewPage.deleteModeActive)
    {
        self.deleteModeButton.tintColor = [UIColor brownColor];
        self.deleteModeButton.title = @"Delete Mode Off";
        _oglController.viewPage.deleteModeActive = NO;
    }
    else
    {
        self.deleteModeButton.tintColor = [UIColor redColor];
        self.deleteModeButton.title = @"Delete Mode On ";
        _oglController.viewPage.deleteModeActive = YES;
    }
}


-(IBAction)majuscleMinisculeSegmentValueChanged:(id)sender
{
    UISegmentedControl *control = (UISegmentedControl*)sender;
    CCAlphabetScrollView *view = (CCAlphabetScrollView*)_alphabetScrollViewController.innerView;
    if(control.selectedSegmentIndex == kMiniscule)
    {
        
        [view caseChanged:@"miniscule"];
    }
    else
    {
        [view caseChanged:@"majuscule"];
    }
}

-(void)alphabetChanged:(NSNotification*)notification
{
    
    CCNibScriptStyleTableViewController *nibStyleController = (CCNibScriptStyleTableViewController*)notification.object;
    
    NSString *italicString = @"The Italic hand was derived from Carolingian miniscules by Renaissance humanist scholars in the 15th Century. It fell out of popularity in the mid 16th century.";
    
    NSString *uncialString = @"One of the oldest calligraphic scripts, Uncials were used during the early medieval period, from the 3rd to the 8th centuries CE, mostly in Latin and Greek manuscripts. The script was used by a very wide variety of cultures, ranging from Byzantium to Anglo-Saxon England. The Cyrillic alphabet was derived from a version of it.";
    
    NSString *foundationalString = @"Foundational was invented by Edward Johnston in the early 1900s as a teaching hand for beginner calligraphers, based on scripts from 9th and 10th century manuscripts, including the Ramsey Psalter. Johnston was a gifted craftsman and designer who also created many influential modern typefaces, including that used by the London Underground to this day.";
    
    NSString *gothicString = @"Gothic, also known as Blackletter or Textura, was derived from Carolingian miniscules around 1150, and was widely used in high-status medieval manuscripts and early printed books. Somewhat hard to read for the unitiated, it gradually fell out of use from the end of the 17th century onwards.";
    
    NSDictionary *aboutTextDict = @{
    @"gothic":gothicString,
    @"italic":italicString,
    @"foundational":foundationalString,
    @"uncial":uncialString};
    
    _textView.text = aboutTextDict[nibStyleController.currentStyle];
    
    if(!_alphabetScrollViewVisible)
        [self toggleAlphabetScrollView:nil];
    
    [_oglController setupGuidelines];
    
}


#pragma mark -
#pragma mark Notification Methods

-(void)inkColorChange:(NSNotification*)notification
{
   CCInkConfigViewController *inkConfigController = (CCInkConfigViewController*)notification.object;
   
   self.inkColorButton.tintColor = inkConfigController.colorWell.backgroundColor;
   _oglController.viewPage.inkColor = inkConfigController.colorWell.backgroundColor;
}

-(void)paperColorChange:(NSNotification*)notification
{
    
    CCInkConfigViewController *inkConfigController = (CCInkConfigViewController*)notification.object;
    UIColor *newColor = inkConfigController.colorWell.backgroundColor;
    CGFloat r,g,b,a;
    [newColor getRed:&r green:&g blue:&b alpha:&a];
    
    
    [_oglController setGLPaperColor:newColor];
    [_oglController setupGuidelines];
    self.paperColorButton.tintColor = newColor;
    _oglController.viewPage.backgroundColor = newColor;

    
}

-(void)tableViewPaperColorChange:(NSNotification*)notification
{
    CCPaperColorsTableViewController *paperTableViewController = (CCPaperColorsTableViewController*)notification.object;
    self.paperColorButton.tintColor = paperTableViewController.currentColor;
    _oglController.viewPage.backgroundColor = paperTableViewController.currentColor;
    
}

-(void)appDidBecomeActive:(NSNotification*)notification
{
    _oglController.paused = NO;
}

#pragma mark - UIAlertView Delegate

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *buttonTitle = [alertView buttonTitleAtIndex:buttonIndex];
    if([buttonTitle isEqualToString:@"Delete"])
    {   
        [_oglController.dataStore deleteManuscriptWithName:_fileNameToDeleteOrSave];
        
        _oglController.dataStore.unsavedChanges = NO;
        [_oglController newManuscript];
        self.navigationItem.title = [NSString stringWithFormat:@"Calligrapher - %@",[_oglController currentMSName]];
    }
    
    if([buttonTitle isEqualToString:@"Discard changes"])
    {
        
        [_oglController newManuscript];
        
        self.navigationItem.title = [NSString stringWithFormat:@"Calligrapher - %@",self.currentMSName];
    }
    
    if([buttonTitle isEqualToString:@"Save and continue"])
    {
        
        [self performSegueWithIdentifier:@"ForceLoadSaveSegue" sender:self];
       
    }
    
    
    if([buttonTitle isEqualToString:@"Save and Load"])
    {
        [_oglController saveManuscriptWithName:self.currentMSName];
        [_oglController loadManuscriptWithName:_fileNameToDeleteOrSave];
        self.navigationItem.title = [NSString stringWithFormat:@"Calligrapher- %@",self.currentMSName];
        self.inkColorButton.tintColor = _oglController.viewPage.inkColor;
        self.paperColorButton.tintColor = _oglController.viewPage.backgroundColor;
    }
}

#pragma mark - UIScrollView Delegate

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.calligraphyView;
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(float)scale
{
   //Blank implementation for protocol
}

-(void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    CGFloat offsetX = (scrollView.bounds.size.width > scrollView.contentSize.width) ?
    (scrollView.bounds.size.width - scrollView.contentSize.width) *0.5 : 0.0;
    CGFloat offsetY = (scrollView.bounds.size.height > scrollView.contentSize.height) ?
    (scrollView.bounds.size.height - scrollView.contentSize.height) * 0.5 : 0.0;
    
    self.calligraphyView.center = CGPointMake(scrollView.contentSize.width * 0.5 + offsetX,
                                              scrollView.contentSize.height * 0.5 + offsetY);
}




@end
