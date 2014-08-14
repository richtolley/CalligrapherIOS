//
//  CCSavedWorkViewController.m
//  Calligrapher
//
//  Created by Richard Tolley on 23/11/2012.
//  Copyright (c) 2012 Richard Tolley. All rights reserved.
//

#import "CCSavedWorkViewController.h"
#import "CCSavedWorkCell.h"
#import "CCAppDelegate.h"
#import "Manuscript.h"
#import "CCViewController.h"
@interface CCSavedWorkViewController ()
{
    NSMutableArray *_visibleWorkItems;
}

@end

@implementation CCSavedWorkViewController

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
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"ViewCell"];	
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setup];
}

-(void)setup
{
    
    
    CCAppDelegate *appDelegate = [[UIApplication sharedApplication]delegate];
    NSManagedObjectContext *moc = appDelegate.managedObjectContext;
    NSEntityDescription *entityDesc = [NSEntityDescription entityForName:@"Manuscript" inManagedObjectContext:moc];
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc]init];
    [fetchRequest setEntity:entityDesc];
    [fetchRequest setSortDescriptors:@[sortDescriptor]];
    NSError *fetchError;
    NSArray *fetchedItems = [moc executeFetchRequest:fetchRequest error:&fetchError];
    if(fetchError)
    {
        NSLog(@"Fetch error %@,%@",fetchError.localizedDescription,fetchError.localizedFailureReason);
    }
    
    
    _visibleWorkItems = [[NSMutableArray alloc]init];
    for(Manuscript *m in fetchedItems)
    {   
        if(m.name.length > 0 && m.hasBeenSaved)
         [_visibleWorkItems addObject:m];
    }
    
    if(fetchError)
    {
        NSLog(@"Fetch error: %@",fetchError.localizedDescription);
    }
    
    if([_visibleWorkItems count] == 0)
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"No Manuscripts" message:@"No manuscripts have been saved" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UICollectionView Datasource

-(NSInteger)collectionView:(UICollectionView*)view numberOfItemsInSection:(NSInteger)section
{
    return _visibleWorkItems.count;
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView*)collectionView {
    return 1;
}

-(UICollectionViewCell*)collectionView:(UICollectionView*)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath
{   
    CCSavedWorkCell *cell = [cv dequeueReusableCellWithReuseIdentifier:@"ViewCell" forIndexPath:indexPath];

    Manuscript *m = [_visibleWorkItems objectAtIndex:indexPath.row];
    
    cell.thumbnailView.image = m.thumbnailImage;
    cell.nameLabel.text = m.name;
   
    return (UICollectionViewCell*)cell;
}

#pragma mark - UICollectionViewDelegate
-(void)collectionView:(UICollectionView*)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self.navigationController popToRootViewControllerAnimated:YES];
    Manuscript *m = _visibleWorkItems[indexPath.row];
    [self.mainViewController loadManuscriptWithName:m.name];
}

@end
