//
//  KomomuComunityViewController.m
//  Komomu
//
//  Created by Guille Uchima on 7/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "KomomuComunityViewController.h"
#import "KomomuAppDelegate.h"
#import "KomomuPostViewController.h"

#import "KomomuCommunityInfoCell.h"

#import "KomomuPostCell.h"


@interface KomomuComunityViewController ()

@end

@implementation KomomuComunityViewController
@synthesize table = _table;
@synthesize params;
@synthesize posts;

- (void)viewDidLoad {
    [super viewDidLoad];
	self.view.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"background.png"]];
    self.table.backgroundColor = [UIColor clearColor];
	if (_refreshHeaderView == nil) {
		EGORefreshTableHeaderView *view = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - self.table.bounds.size.height, self.view.frame.size.width, self.table.bounds.size.height)];
		view.delegate = self;
		[self.table addSubview:view];
		_refreshHeaderView = view;
	}
	
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self reloadTableData];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	return YES;
}


- (void) reloadTableData {
    [ApplicationDelegate.komomuEngine getCommunity:params onCompletion:^(NSDictionary* data) {
        self.posts = [data objectForKey:@"posts"];
        
        [self.table reloadData];
        //  update the last update date
        [_refreshHeaderView refreshLastUpdatedDate];
    }onError:^(NSError* error) {
        NSLog(@"%@", error);
    }];
}


#pragma mark -
#pragma mark UITableViewDataSource


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [posts count];
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell;
    NSInteger row = indexPath.row;
    static NSString *CellIdentifier = @"KomomuPostCell";

    if(row==0) {
        KomomuCommunityInfoCell *communityCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (communityCell == nil) {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"KomomuCommunityInfoCell" owner:self options:nil];
            communityCell = [nib objectAtIndex:0];
        }
        // Configure the cell.
        [communityCell setTableData:[posts objectAtIndex:indexPath.row]];
        cell = communityCell;
    } else {
        KomomuPostCell *komomuCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (komomuCell == nil) {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"KomomuPostCell" owner:self options:nil];
            komomuCell = [nib objectAtIndex:0];
        }
        // Configure the cell.
        [komomuCell setTableData:[posts objectAtIndex:indexPath.row]];
        cell = komomuCell;
    }

    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 75;
}


- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if ([self numberOfSectionsInTableView:tableView] == (section+1)){
        return [UIView new];
    }       
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSUInteger row = [indexPath row];
    //KomomuPostCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    KomomuPostViewController *comunityController = [[KomomuPostViewController alloc] initWithNibName:@"KomomuPostViewController" bundle:[NSBundle mainBundle]];
    
    comunityController.posts = self.posts;
    comunityController.selectedRow = row;
    [self.navigationController pushViewController:comunityController animated:YES];
}

#pragma mark -
#pragma mark Data Source Loading / Reloading Methods

- (void)reloadTableViewDataSource{
	
	//  should be calling your tableviews data source model to reload
	//  put here just for demo
    [self reloadTableData];
	_reloading = YES;
}

- (void)doneLoadingTableViewData{
	//  model should call this when its done loading
	_reloading = NO;
	[_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.table];
	
}


#pragma mark -
#pragma mark UIScrollViewDelegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{	
	
	[_refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
	
	[_refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
	
}


#pragma mark -
#pragma mark EGORefreshTableHeaderDelegate Methods

- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view{
	
	[self reloadTableViewDataSource];
	[self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:3.0];
	
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view{
	return _reloading; // should return if data source model is reloading
	
}

- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)view{
	
	return [NSDate date]; // should return date data source was last changed
	
}


#pragma mark -
#pragma mark Memory Management

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload {
    [self setTable:nil];
	_refreshHeaderView=nil;
}

- (void)dealloc {
	
	_refreshHeaderView = nil;
}

@end
