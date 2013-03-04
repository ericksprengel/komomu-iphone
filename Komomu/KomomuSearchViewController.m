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
@interface KomomuSearchViewController() {
    UIView *footerView;
}

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
//    return 0.01f;
    if(section == [keys count]-1 || [keys count] == 0)
        return 60.0;
    else 
        return 0.01f;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    // To "clear" the footer view
//    return [UIView new];
    if(section == [keys count]-1 || [keys count] == 0) {
        //allocate the view if it doesn't exist yet
        footerView  = [[UIView alloc] init];
        
        //we would like to show a gloosy red button, so get the image first
        UIImage *image = [[UIImage imageNamed:@"greenButton.png"]
                          stretchableImageWithLeftCapWidth:8 topCapHeight:8];
        
        //create the button
        UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [button setBackgroundImage:image forState:UIControlStateNormal];
        
        //the button should be as big as a table view cell
        [button setFrame:CGRectMake(10, 3, 300, 44)];
        
        //set title, font size and font color
        [button setTitle:@"Sugerir comunidade" forState:UIControlStateNormal];
        [button.titleLabel setFont:[UIFont boldSystemFontOfSize:20]];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        //set action of the button
        [button addTarget:self action:@selector(showEmail:)
         forControlEvents:UIControlEventTouchUpInside];
        
        //add the button to the view
        [footerView addSubview:button];
        
        return footerView;
//        return [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"redButton.png"]];
    } else
        return [UIView new];
}

- (IBAction)showEmail:(id)sender {
    // Email Subject
    NSString *emailTitle = @"Sugestão de comunidade";
    // Email Content
    NSString *messageBody = @"Gostaria de sugerir a criação da seguinte comunidade:";
    // To address
    NSArray *toRecipents = [NSArray arrayWithObject:@"suporte@komomu.com"];
    
    MFMailComposeViewController *mc = [[MFMailComposeViewController alloc] init];
    mc.mailComposeDelegate = self;
    [mc setSubject:emailTitle];
    [mc setMessageBody:messageBody isHTML:NO];
    [mc setToRecipients:toRecipents];
    
    // Present mail view controller on screen
    [self presentViewController:mc animated:YES completion:NULL];
    
}

- (void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    switch (result)
    {
        case MFMailComposeResultCancelled:
            NSLog(@"Mail cancelled");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Mail saved");
            break;
        case MFMailComposeResultSent: {
            NSLog(@"Mail sent");
            UIAlertView *alertView = [[UIAlertView alloc]
                                      initWithTitle:@"E-mail enviado"
                                      message:@"O pedido será analisado. Agradecemos pela sua sugestão."
                                      delegate:nil
                                      cancelButtonTitle:@"OK"
                                      otherButtonTitles:nil,
                                      nil];
            [alertView show];
            break;
        }
        case MFMailComposeResultFailed:
            NSLog(@"Mail sent failure: %@", [error localizedDescription]);
            break;
        default:
            break;
    }
    
    
    // Close the Mail Interface
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section { 
    if ([keys count] == 0)
        return nil;
    NSString *key = [keys objectAtIndex:section];
    return key;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSUInteger row = [indexPath row];

    KomomuSearchCell *cell = (KomomuSearchCell *)[tableView cellForRowAtIndexPath:indexPath];


    NSLog(cell.communityID);
    KomomuComunityViewController *comunityController = [[KomomuComunityViewController alloc] initWithNibName:@"KomomuComunityViewController" bundle:[NSBundle mainBundle]];
    comunityController.title = cell.nameLabel.text;
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:cell.communityID forKey:@"communityID"];
    [params setObject:cell.following forKey:@"following"];
    [params setObject:@"hot" forKey:@"type"];
    comunityController.params = params;
    
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
