//
//  CCSavedWorkDialogViewController.m
//  Calligrapher
//
//  Created by Richard Tolley on 28/11/2012.
//  Copyright (c) 2012 Richard Tolley. All rights reserved.
//

#import "CCLoadSaveDialogViewController.h"
#import "UIColor+AppColors.h"
#import "CCViewController.h"
@implementation CCLoadSaveDialogViewController
-(void)viewDidLoad
{
    self.view.backgroundColor = [UIColor paperBackgroundColor];
    _textField.hidden = YES;
    _textFieldLabel.hidden = YES;
}

-(IBAction)closeDialog:(id)sender
{
    [self.mainController.loadSaveController dismissPopoverAnimated:YES];
}

-(IBAction)dismissKeyboard:(id)sender
{
    [_textField resignFirstResponder];
    [self toggleTextfieldVisibility];
    
    @try {
        [self.mainController saveManuscriptWithFileName:_textField.text];
    }
    @catch (NSException *exception) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Unable to save" message:exception.reason delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }

}

-(IBAction)editingCancelled:(id)sender
{
    [self toggleTextfieldVisibility];
}

-(IBAction)saveToPhotoAlbum:(id)sender
{
    [self.mainController saveToPhotoAlbum];
}

-(IBAction)deleteCurrentManuscript:(id)sender
{
    [self.mainController deleteCurrentManuscript];
}

-(IBAction)load:(id)sender
{
    [self closeDialog:nil];
    [self.mainController performSegueWithIdentifier:@"SavedWorkSegue" sender:nil];
}

-(IBAction)newManuscript:(id)sender
{
    [self.mainController newManuscript];
}

-(IBAction)save:(id)sender
{   
    _textField.text = self.mainController.currentMSName;
    [self toggleTextfieldVisibility];
    [_textField becomeFirstResponder];
}



-(void)toggleTextfieldVisibility
{
    _textFieldLabel.hidden = !_textFieldLabel.hidden;
    _textField.hidden = !_textField.hidden;
}
@end
