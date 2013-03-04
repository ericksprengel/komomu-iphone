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
@synthesize scoreLabel;
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
    [self reloadData];

}

- (void) reloadData {
    KomomuAppDelegate *delegate = (KomomuAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    [self.profileImageView setImage:[[delegate komomuUser] profilePhotoImage]];
    [self.nameLabel setText:[[delegate komomuUser] name]];
    
    [ApplicationDelegate.komomuEngine searchCommunities:@"Brazil" onCompletion:^(NSDictionary* commu) {
        self.userCommunities = [commu mutableSingleCopy];
        
        NSArray *abcArray = [[self.userCommunities allKeys] sortedArrayUsingSelector: @selector(caseInsensitiveCompare:)];
        		
        self.keys = [abcArray mutableCopy];
        
        [table reloadData];        
    }
                                                onError:^(NSError* error) {
                                                }];
    
    NSMutableDictionary *p = [[NSMutableDictionary alloc] init];
    [p setObject:[[delegate komomuUser] userID] forKey:@"userID"];
    
    [ApplicationDelegate.komomuEngine getUser:p onCompletion:^(NSDictionary* commu) {
        [self.scoreLabel setText:[[[commu valueForKey:@"points"] stringValue] stringByAppendingString: @" ponto(s)"]];   
    }
                                      onError:^(NSError* error) {
                                      }];
     

}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];  
    // Add navigation bar Title
    self.tabBarController.navigationItem.title = @"Profile";
    [self reloadData];

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

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return YES if you want the specified item to be editable.
    return YES;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        //add code here for when you hit delete
        NSUInteger section = [indexPath section]; 
        
        NSString *key = [keys objectAtIndex:section]; 
        [self.keys removeObjectAtIndex:section];
        NSArray *nameSection = [self.userCommunities objectForKey:key];
        
        //TODO unfollow
        NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
        [params setObject:[[nameSection objectAtIndex:indexPath.row] objectForKey:@"id"] forKey:@"id"];
        [params setObject:[NSNumber numberWithInt:0] forKey:@"action"];        
        [ApplicationDelegate.komomuEngine follow:params onError:^(NSError* error) {
            NSLog(@"%@", error);
        }];
        [self reloadData];        
    }    
}


- (void)viewDidUnload
{
    [self setNameLabel:nil];
    [self setScoreLabel:nil];
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
