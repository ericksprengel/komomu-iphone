//
//  KomomuProfileViewController.m
//  Komomu
//
//  Created by Guille Uchima on 7/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "KomomuProfileViewController.h"

#import "KomomuAppDelegate.h"
#import "NSDictionary+MutableDeepCopy.h"
#import "KomomuSearchCell.h"

@interface KomomuProfileViewController ()

@end

@implementation KomomuProfileViewController

@synthesize userCommunities;
@synthesize keys;

@synthesize nameLabel;
@synthesize profileImageView;
@synthesize table;


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
    // Do any additional setup after loading the view from its nib.
    
    KomomuAppDelegate *delegate = (KomomuAppDelegate *)[[UIApplication sharedApplication] delegate];

    [self.profileImageView setImage:[[delegate komomuUser] profilePhotoImage]];
    [self.nameLabel setText:[[delegate komomuUser] name]];
    
    [ApplicationDelegate.komomuEngine searchCommunities:@"Brazil" onCompletion:^(NSDictionary* commu) {
        self.userCommunities = [commu mutableDeepCopy];
        
        NSArray *abcArray = [[self.userCommunities allKeys] sortedArrayUsingSelector: @selector(caseInsensitiveCompare:)];
        
        self.keys = [abcArray mutableCopy];
        
        [table reloadData];        
    }
                                                onError:^(NSError* error) {
                                                }];


}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];  
    // Add navigation bar Title
    self.tabBarController.navigationItem.title = @"Profile";

}

#pragma mark -
#pragma mark Table View Data Source Methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return ([keys count] > 0) ? [keys count] : 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([keys count] == 0) 
        return 0;
    NSString *key = [keys objectAtIndex:section]; 
    NSArray *nameSection = [self.userCommunities objectForKey:key];
    return [nameSection count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger section = [indexPath section]; 
    
    NSString *key = [keys objectAtIndex:section]; 
    NSArray *nameSection = [self.userCommunities objectForKey:key];

    
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

- (void)viewDidUnload
{
    [self setNameLabel:nil];
    [self setProfileImageView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)onFBLogout:(id)sender {
    KomomuAppDelegate *delegate = (KomomuAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    [[delegate facebook] logout];
        
    // Notify the root view about the logout.
    KomomuViewController *rootViewController = (KomomuViewController *)[[self.navigationController viewControllers] objectAtIndex:0];
    [rootViewController fbDidLogout];
    
    [delegate.navController popToRootViewControllerAnimated:YES];

}
@end
