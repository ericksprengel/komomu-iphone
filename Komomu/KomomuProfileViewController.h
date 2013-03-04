//
//  KomomuProfileViewController.h
//  Komomu
//
//  Created by Guille Uchima on 7/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KomomuProfileViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;

@property (nonatomic, retain) NSMutableDictionary *params;
@property (weak, nonatomic) IBOutlet UITableView *table;
@property (strong, nonatomic) NSDictionary *userCommunities;
@property (strong, nonatomic) NSMutableArray *keys;
- (IBAction)onFBLogout:(id)sender;


@end
