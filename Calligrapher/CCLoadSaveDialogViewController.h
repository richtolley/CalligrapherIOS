//
//  CLoadSaveDialogViewController.h
//  Calligrapher
//
//  Created by Richard Tolley on 28/11/2012.
//  Copyright (c) 2012 Richard Tolley. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CCViewController;
@interface CCLoadSaveDialogViewController : UIViewController
{
    IBOutlet UITextField *_textField;
    IBOutlet UILabel *_textFieldLabel;
}
@property (nonatomic,weak) CCViewController *mainController;
@property (nonatomic,strong) IBOutlet UIButton *saveButton;
@property (nonatomic,strong) IBOutlet UIButton *loadButton;
@property (nonatomic,strong) IBOutlet UIButton *createNewMSButton;
-(IBAction)closeDialog:(id)sender;
-(IBAction)save:(id)sender;
@end
