//
//  CCNibScriptStyleTableViewController.m
//  Calligrapher
//
//  Created by Richard Tolley on 23/11/2012.
//  Copyright (c) 2012 Richard Tolley. All rights reserved.
//

#import "CCNibScriptStyleTableViewController.h"
#import "UIColor+AppColors.h"
@interface CCNibScriptStyleTableViewController ()

@end

@implementation CCNibScriptStyleTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _styleNames = [CCCalligraphyStyle availableStyles];
    _penAngleDict = @{@"gothic" : @40,@"foundational":@30,@"italic":@45,@"uncial":@25};
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
    self.tableView.backgroundColor = [UIColor paperBackgroundColor];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSNumber *rowNumber = nil;
    if([defaults valueForKey:@"nibScriptStyleTableViewLastIndexPath"])
        rowNumber = [defaults valueForKey:@"nibScriptStyleTableViewLastIndexPath"];
    if(rowNumber != nil)
    {
        NSUInteger indices[] = {0,rowNumber.intValue};
        self.lastIndexPath = [[NSIndexPath alloc]initWithIndexes:indices length:2];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    return _styleNames.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    cell.textLabel.text = [_styleNames[indexPath.row]capitalizedString];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    // Configure the cell...
    if (self.lastIndexPath != nil && indexPath.row == self.lastIndexPath.row) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    return (UITableViewCell*)cell;
    return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    self.currentStyle = _styleNames[indexPath.row];
    
    [[NSNotificationCenter defaultCenter]postNotificationName:@"alphabetChanged" object:self];
    
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
        [defaults setObject:rowNumber forKey:@"nibScriptStyleTableViewLastIndexPath"];
        [defaults synchronize];
    }
}

-(double)nibAngleForStyle:(NSString*)style
{
   NSNumber *angle = _penAngleDict[style];
   return angle.doubleValue;
}


@end
