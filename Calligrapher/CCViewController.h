//
//  CCViewController.h
//  Calligrapher
//
//  Created by Richard Tolley on 06/11/2012.
//  Copyright (c) 2012 Richard Tolley. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GLKit/GLKit.h>
@class CCView;
@class CCAlphabetScrollViewController;
@class Manuscript;
@class CCDataStore;
@class CCViewPage;
@class CCCalligraphyView;

@interface CCViewController : UIViewController <NSFetchedResultsControllerDelegate,UIAlertViewDelegate,UIScrollViewDelegate>
{
    IBOutlet CCAlphabetScrollViewController *_alphabetScrollViewController;
    
}
@property (nonatomic,strong) IBOutlet CCCalligraphyView *calligraphyView;
@property (nonatomic,strong) IBOutlet UIScrollView *scrollView;
@property (nonatomic,strong,readonly) NSString *currentMSName;
@property (nonatomic,strong) IBOutlet UIView *alphabetScrollOuterView;
@property (nonatomic,strong) IBOutlet UIView *textContainerView;
@property (nonatomic,strong) IBOutlet UITextView *textView;
@property (nonatomic,strong) UIPopoverController *nibConfigController;
@property (nonatomic,strong) UIPopoverController *inkConfigController;
@property (nonatomic,strong) UIPopoverController *paperConfigController;
@property (nonatomic,strong) UIPopoverController *loadSaveController;
@property (nonatomic,strong) IBOutlet UIBarButtonItem *inkColorButton;
@property (nonatomic,strong) IBOutlet UIBarButtonItem *paperColorButton;
@property (nonatomic,strong) IBOutlet UIBarButtonItem *nibConfigButton;
@property (nonatomic,strong) IBOutlet UIBarButtonItem *loadViewButton;
@property (nonatomic,strong) IBOutlet UIBarButtonItem *alphabetScrollViewButton;
@property (nonatomic,strong) IBOutlet UIBarButtonItem *guideLinesButton;
@property (nonatomic,strong) IBOutlet UIBarButtonItem *deleteModeButton;
-(IBAction)clear:(id)sender;
-(IBAction)toggleAlphabetScrollView:(id)sender;
-(IBAction)toggleGuidelines:(id)sender;
-(IBAction)toggleDeleteMode:(id)sender;
-(IBAction)majuscleMinisculeSegmentValueChanged:(id)sender;
-(void)pushSavedWordController;
-(void)saveManuscriptWithFileName:(NSString*)fileName;
-(void)deleteCurrentManuscript;
-(void)newManuscript;
-(void)loadManuscriptWithName:(NSString*)msName;
-(void)saveToPhotoAlbum;
@end
