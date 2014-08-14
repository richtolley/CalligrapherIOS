//
//  CCSavedWorkViewController.h
//  Calligrapher
//
//  Created by Richard Tolley on 23/11/2012.
//  Copyright (c) 2012 Richard Tolley. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CCViewController;
@interface CCSavedWorkViewController : UIViewController
@property(nonatomic, weak) IBOutlet UICollectionView *collectionView;
@property(nonatomic, weak) CCViewController *mainViewController;
@end
