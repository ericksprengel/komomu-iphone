//
//  KomomuSearchViewController.m
//  Komomu
//
//  Created by Guille Uchima on 6/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "KomomuSearchViewController.h"
#import "KomomuComunityViewController.h"
#import "KomomuSearchCell.h"

#import "NSDictionary+MutableDeepCopy.h"
#import "KomomuAppDelegate.h"

#import "KomomuTabBarViewController.h"
@interface KomomuSearchViewController ()

@end

@implementation KomomuSearchViewController

@synthesize strData;
@synthesize keys;
@synthesize table;
@synthesize search;
@synthesize allCommunities;
@synthesize communities;


#pragma mark -
#pragma mark Custom Methods 
- (void)resetSearch {
    self.communities = [self.allCommunities mutableDeepCopy];
    
    NSArray *abcArray = [[self.allCommunities allKeys] sortedArrayUsingSelector: @selector(caseInsensitiveCompare:)];
    
    self.keys = [abcArray mutableCopy];
}

- (void)handleSearchForTerm:(NSString *)searchTerm {
    NSMutableArray *sectionsToRemove = [[NSMutableArray alloc] init]; 
    [self resetSearch];
    for (NSString *key in self.keys) {
        NSMutableArray *array = [self.communities valueForKey:key]; 
        NSMutableArray *toRemove = [[NSMutableArray alloc] init];
        for (NSMutableArray *name in array) {
            if ([[name valueForKey:@"name"] rangeOfString:searchTerm
                            options:NSCaseInsensitiveSearch].location == NSNotFound) 
                [toRemove addObject:name];
        }
        if ([array count] == [toRemove count])
            [sectionsToRemove addObject:key];
        [array removeObjectsInArray:toRemove]; 
    }
    [self.keys removeObjectsInArray:sectionsToRemove];
    [table reloadData];
    
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization        
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

// Method that gets called when the logout button is pressed
- (void) logoutButtonClicked:(id)sender {
    [ApplicationDelegate.facebook logout];
}

#pragma mark - View lifecycle
- (void)viewDidLoad
{
    [super viewDidLoad];    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = backButton;
    
    search.text = self.strData;
    [ApplicationDelegate.komomuEngine searchCommunities:@"Brazil" onCompletion:^(NSDictionary* commu) {
        self.allCommunities = [commu mutableDeepCopy];
        [self resetSearch];
        [self handleSearchForTerm: search.text];
        
        [table reloadData];
        [table setContentOffset:CGPointMake(0.0, 44.0) animated:NO];
        
        searching = NO;
        letUserSelectRow = YES;
    }
                                           onError:^(NSError* error) {
                                           }];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    self.communities = nil;
    self.keys = nil;
    self.table = nil;
    self.search = nil;
    self.allCommunities = nil;
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark -
#pragma mark Table View Data Source Methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return ([keys count] > 0) ? [keys count] : 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([keys count] == 0) 
        return 0;
    NSString *key = [keys objectAtIndex:section]; 
    NSArray *nameSection = [self.communities objectForKey:key];
    return [nameSection count];
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSUInteger section = [indexPath section]; 
    
    NSString *key = [keys objectAtIndex:section]; 
    NSArray *nameSection = [self.communities objectForKey:key];
    
    static NSString *SectionsTableIdentifier = @"SectionsTableIdentifier";
    KomomuSearchCell *cell = (KomomuSearchCell *)[tableView dequeueReusableCellWithIdentifier:SectionsTableIdentifier];

    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"SearchTableCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    [cell setTableData:[nameSection objectAtIndex:indexPath.row]];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 75;
}

- (float)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    // This will create a "invisible" footer
    return 0.01f;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    // To "clear" the footer view
    return [UIView new];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section { 
    if ([keys count] == 0)
        return nil;
    NSString *key = [keys objectAtIndex:section];
    return key;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSUInteger row = [indexPath row];
    KomomuSearchCell *cell = [tableView cellForRowAtIndexPath:indexPath];

    
    KomomuComunityViewController *comunityController = [[KomomuComunityViewController alloc] initWithNibName:@"KomomuComunityViewController" bundle:[NSBundle mainBundle]];
    comunityController.title = cell.nameLabel.text;
    
    [comunityController.params setObject:cell.communityID forKey:@"communityID"];
    [comunityController.params setObject:@"hot" forKey:@"type"];
    	
    
    [self.navigationController pushViewController:comunityController animated:YES];
    self.search.text = @"";	

}


#pragma mark -
#pragma mark Table View Delegate Methods
- (NSIndexPath *)tableView:(UITableView *)tableView
  willSelectRowAtIndexPath:(NSIndexPath *)indexPath { 
    [search resignFirstResponder];
    if(letUserSelectRow)
        return indexPath;
    else
        return nil;
}

#pragma mark -
#pragma mark Search Bar Delegate Methods
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    NSString *searchTerm = [searchBar text];
    [self handleSearchForTerm:searchTerm]; 
    
    [search resignFirstResponder];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchTerm { 
    if ([searchTerm length] != 0) {
        [ovController.view removeFromSuperview];
        searching = YES;
        letUserSelectRow = YES;
        self.table.scrollEnabled = YES;
    } else {
        [self.table insertSubview:ovController.view aboveSubview:self.parentViewController.view];

        searching = NO;
        letUserSelectRow = NO;
        self.table.scrollEnabled = NO;
    }
    [self handleSearchForTerm:searchTerm];
    [table reloadData]; 
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar { 
    search.text = @"";
    letUserSelectRow = YES;
    searching = NO;
    self.table.scrollEnabled = YES;
    
    [ovController.view removeFromSuperview];

    
    [self resetSearch];
    [self handleSearchForTerm: search.text];
    [table reloadData];
    [searchBar resignFirstResponder];
}


- (void) searchBarTextDidBeginEditing:(UISearchBar *)theSearchBar {
    //Add the overlay view.
    if(ovController == nil)
        ovController = [[OverlayViewController alloc] initWithNibName:@"OverlayView" bundle:[NSBundle mainBundle]];
    
    CGFloat yaxis = self.navigationController.navigationBar.frame.size.height;
    CGFloat width = self.view.frame.size.width;
    CGFloat height = self.view.frame.size.height;
    
    //Parameters x = origion on x-axis, y = origon on y-axis.
    CGRect frame = CGRectMake(0, yaxis, width, height);
    ovController.view.frame = frame;
    ovController.view.backgroundColor = [UIColor grayColor];
    ovController.view.alpha = 0.5;
    
    ovController.rvController = self;
    
    [self.table insertSubview:ovController.view aboveSubview:self.parentViewController.view];
    
    searching = YES;
    letUserSelectRow = NO;
    self.table.scrollEnabled = NO;
}
@end
