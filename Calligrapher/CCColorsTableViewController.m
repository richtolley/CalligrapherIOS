//
//  CCColorsTableViewController.m
//  Calligrapher
//
//  Created by Richard Tolley on 04/12/2012.
//  Copyright (c) 2012 Richard Tolley. All rights reserved.
//

#import "CCColorsTableViewController.h"
#import "CCColorTableViewCell.h"
@interface CCColorsTableViewController ()

@end

@implementation CCColorsTableViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    

    @try
    {   
        if(_userDefaultsKeyString == nil || _customSelectionNotificationString == nil)
            @throw [NSException exceptionWithName:@"Abstract Class" reason:@"Attempt to use CCColorTableViewController base class. Use a concrete subclass instead" userInfo:nil];
        [self refreshLastIndexPath];
        
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refreshLastIndexPath) name:_customSelectionNotificationString object:nil];
    
    }
    @catch(NSException *e)
    {
        NSLog(@"Exception %@ reason %@",e.name,e.reason);

    }
}


-(void)viewWillAppear:(BOOL)animated
{
   [super viewWillAppear:animated];
   [self refreshLastIndexPath];
}

-(void)refreshLastIndexPath
{   
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSNumber *rowNumber = nil;
    if([defaults valueForKey:_userDefaultsKeyString])
        rowNumber = [defaults valueForKey:_userDefaultsKeyString];
    if(rowNumber != nil)
    {
        NSUInteger indices[] = {0,rowNumber.intValue};
        self.lastIndexPath = [[NSIndexPath alloc]initWithIndexes:indices length:2];
    }
    else self.lastIndexPath = nil;
    [self.tableView reloadData];
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    // Return the number of rows in the section.
    return _colorDict.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{   
    static NSString *CellIdentifier = @"Cell";
    CCColorTableViewCell *cell = (CCColorTableViewCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    cell.textLabel.text = _colorDict.allKeys[indexPath.row];
    cell.colorView.backgroundColor = [_colorDict objectForKey:cell.textLabel.text];
    
    cell.backgroundColor = [UIColor paperBackgroundColor];
    if (self.lastIndexPath != nil && indexPath.row == self.lastIndexPath.row) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    else cell.accessoryType = UITableViewCellAccessoryNone;
    return (UITableViewCell*)cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    CCColorTableViewCell *cell = (CCColorTableViewCell*)[self tableView:self.tableView cellForRowAtIndexPath:indexPath];
    
    self.currentColor = cell.colorView.backgroundColor;
    [[NSNotificationCenter defaultCenter]postNotificationName:_notificationPostedNameString object:self];
    int newRow = [indexPath row];
    int oldRow = (self.lastIndexPath != nil) ? [self.lastIndexPath row]:  -1;
     
    if(newRow != oldRow)
    {
        UITableViewCell *newCell = [self.tableView cellForRowAtIndexPath:indexPath];
        newCell.accessoryType = UITableViewCellAccessoryCheckmark;
        UITableViewCell *oldCell = [self.tableView cellForRowAtIndexPath:self.lastIndexPath];
        oldCell.accessoryType = UITableViewCellAccessoryNone;
        self.lastIndexPath = indexPath;
        [self.tableView reloadData];
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSNumber *rowNumber = [NSNumber numberWithInt:self.lastIndexPath.row];
        [defaults setObject:rowNumber forKey:_userDefaultsKeyString];
        [defaults synchronize];
    }    
}


@end
