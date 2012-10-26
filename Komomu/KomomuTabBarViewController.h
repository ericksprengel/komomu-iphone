//
//  KomomuTabBarViewController.h
//  Komomu
//
//  Created by Guille Uchima on 7/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BaseViewController.h"
#import "KomomuViewController.h"

@interface KomomuTabBarViewController : BaseViewController

@property (nonatomic, retain) KomomuViewController *firstTab;
@property (nonatomic, retain) NSString *userID;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil tab: (KomomuViewController *)firstTab userID:(NSString *)userID;

- (void)hideTabBar:(BOOL)hidden;
@end
