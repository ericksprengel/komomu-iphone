//
//  KomomuSearchViewController.h
//  Komomu
//
//  Created by Guille Uchima on 6/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OverlayViewController.h"

@interface KomomuSearchViewController : UIViewController <UITableViewDelegate, UITableViewDataSource> {
    NSString *strData;
    
    BOOL searching;
    BOOL letUserSelectRow;
    
    OverlayViewController *ovController;
}

@property (nonatomic, retain) IBOutlet UITableView* table;


@property (strong, nonatomic) IBOutlet UISearchBar *search;
@property (strong, nonatomic) NSMutableArray *keys;
- (void)resetSearch;
- (void)handleSearchForTerm:(NSString *)searchTerm;
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar;

@property (nonatomic, retain) NSString *strData;

@property (strong, nonatomic) NSDictionary *allCommunities;
@property (strong, nonatomic) NSMutableDictionary *communities;

@end
