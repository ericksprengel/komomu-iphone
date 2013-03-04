//
//  KomomuComunityViewController.h
//  Komomu
//
//  Created by Guille Uchima on 7/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGORefreshTableHeaderView.h"
#import "MAConfirmButton.h"



@interface KomomuComunityViewController : UIViewController <EGORefreshTableHeaderDelegate, UITableViewDelegate, UITableViewDataSource> {
	    
    
	EGORefreshTableHeaderView *_refreshHeaderView;
	
	//  Reloading var should really be your tableviews datasource
	//  Putting it here for demo purposes 
	BOOL _reloading;
    BOOL animatingSideSwipe;
    UITableViewCell* sideSwipeCell;
    IBOutlet UIView* sideSwipeView;
    UISwipeGestureRecognizerDirection sideSwipeDirection;
    NSArray* buttonData;
    NSMutableArray* buttons;
    BOOL following;



}
@property (nonatomic, retain) NSMutableDictionary *params;

@property (weak, nonatomic) IBOutlet UITableView *table2;
@property (weak, nonatomic) IBOutlet MAConfirmButton *defaultButton;

@property (weak, nonatomic) IBOutlet UITableView *table;
@property (nonatomic, retain) UITableViewCell* sideSwipeCell;
@property (nonatomic, retain) IBOutlet UIView* sideSwipeView;
@property (nonatomic) UISwipeGestureRecognizerDirection sideSwipeDirection;
@property (nonatomic) BOOL animatingSideSwipe;


@property (strong, nonatomic) NSArray *posts;
@property (strong, nonatomic) NSDictionary *communityData;

- (void)reloadTableViewDataSource;
- (void)doneLoadingTableViewData;
- (void) reloadTableData;
- (void) segmentAction: (UISegmentedControl *) segmentedControl;
@end
