//
//  KomomuTabBarViewController.h
//  Komomu
//
//  Created by Guille Uchima on 7/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BaseViewController.h"

@interface KomomuTabBarViewController : BaseViewController

@property (nonatomic, retain) NSString *communityID;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil community: (NSString *)communityID;

@end
