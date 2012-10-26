//
//  KomomuViewController.m
//  Komomu
//
//  Created by Guille Uchima on 6/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "KomomuViewController.h"
#import "KomomuSearchViewController.h"
#import "KomomuAppDelegate.h"

#import "KomomuTabBarViewController.h"

@interface KomomuViewController ()

@end

@implementation KomomuViewController {
    KomomuAppDelegate *delegate;
}
@synthesize buttonSearch;
@synthesize textSearchField;

@synthesize permissions;
@synthesize backgroundImageView;

#pragma mark - Facebook API Calls
- (void)apiFQLIMe {
    // Using the "pic" picture since this currently has a maximum width of 100 pixels
    // and since the minimum profile picture size is 180 pixels wide we should be able
    // to get a 100 pixel wide version of the profile picture
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   @"SELECT uid, name, pic FROM user WHERE uid=me()", @"query",
                                   nil];
    KomomuAppDelegate *delegate = (KomomuAppDelegate *)[[UIApplication sharedApplication] delegate];
    [[delegate facebook] requestWithMethodName:@"fql.query"
                                     andParams:params
                                 andHttpMethod:@"POST"
                                   andDelegate:self];
}

- (void)apiGraphUserPermissions {
    KomomuAppDelegate *delegate = (KomomuAppDelegate *)[[UIApplication sharedApplication] delegate];
    [[delegate facebook] requestWithGraphPath:@"me/permissions" andDelegate:self];
    
}

#pragma - Private Helper Methods

/**
 * Show the logged in menu
 */

- (void)showLoggedIn {
	[self.navigationController setNavigationBarHidden:NO animated:NO];
    [delegate.tabBarController hideTabBar:NO];

    
    self.backgroundImageView.hidden = YES;
    loginButton.hidden = YES;
    self.buttonSearch.hidden = NO;
    self.textSearchField.hidden = NO;
    
    [self apiFQLIMe];
}

/**
 * Show the logged out menu
 */

- (void)showLoggedOut {
    [self.navigationController setNavigationBarHidden:YES animated:NO];
  [delegate.tabBarController hideTabBar:YES];
    
    self.buttonSearch.hidden = YES;
    self.textSearchField.hidden = YES;
    self.backgroundImageView.hidden = NO;
    loginButton.hidden = NO;
    
    // Clear personal info
    //  nameLabel.text = @"";
    // Get the profile image
    // [profilePhotoImageView setImage:nil];
    
    [[self navigationController] popToRootViewControllerAnimated:YES];
}

/**
 * Show the authorization dialog.
 */
- (void)login {
    KomomuAppDelegate *delegate = (KomomuAppDelegate *)[[UIApplication sharedApplication] delegate];
    if (![[delegate facebook] isSessionValid]) {
        
        [[delegate facebook] authorize:permissions];
    } else {
        [self showLoggedIn];
    }
}

/**
 * Invalidate the access token and clear the cookie.
 */
- (void)logout {
    KomomuAppDelegate *delegate = (KomomuAppDelegate *)[[UIApplication sharedApplication] delegate];
    [[delegate facebook] logout];
}


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
    // Do any additional setup after loading the view from its nib.
    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = backButton;
    
    self.view.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"background.png"]];
    
    UIImage *buttonImageNormal = [UIImage imageNamed:@"blackbutton.png"];
    UIImage *stretchableButtonImageNormal = [buttonImageNormal stretchableImageWithLeftCapWidth:12 topCapHeight:0];
    [buttonSearch setBackgroundImage:stretchableButtonImageNormal forState:UIControlStateNormal];
    [self.buttonSearch setTitle:@"Pesquisar" forState:UIControlStateNormal];
    
    // Initialize permissions
    permissions = [[NSArray alloc] initWithObjects:
                   @"share_item",
                   @"publish_actions",
                   @"photo_upload",
                   @"email",
                   nil];
    
    // Background Image
    backgroundImageView = [[UIImageView alloc]
                           initWithFrame:CGRectMake(0,0,
                                                    self.view.bounds.size.width,
                                                    self.view.bounds.size.height)];
    [backgroundImageView setImage:[UIImage imageNamed:@"Default.png"]];
    [self.view addSubview:backgroundImageView];
    
    // Login Button
    loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
    CGFloat xLoginButtonOffset = self.view.center.x - (318/2);
    CGFloat yLoginButtonOffset = self.view.bounds.size.height - (58 + 13);
    loginButton.frame = CGRectMake(xLoginButtonOffset,yLoginButtonOffset,318,58);
    [loginButton addTarget:self
                    action:@selector(login)
          forControlEvents:UIControlEventTouchUpInside];
    [loginButton setImage:
     [UIImage imageNamed:@"LoginWithFacebookNormal@2x.png"]
                 forState:UIControlStateNormal];
    [loginButton setImage:
     [UIImage imageNamed:@"LoginWithFacebookPressed@2x.png"]
                 forState:UIControlStateHighlighted];
    [loginButton sizeToFit];
    [self.view addSubview:loginButton];
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];  
    // Add navigation bar Title
    self.tabBarController.navigationItem.title = @"Komomu";
    
}

- (void)viewWillAppear:(BOOL)animated {
    delegate = (KomomuAppDelegate *)[[UIApplication sharedApplication] delegate];

    [self.navigationController setNavigationBarHidden:YES animated:animated];
    [delegate.tabBarController hideTabBar:YES];
    [super viewWillAppear:animated];
    
    if (![[delegate facebook] isSessionValid]) {
        [self showLoggedOut];
    } else {
        [self showLoggedIn];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    [delegate.tabBarController hideTabBar:NO];

    [super viewWillDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)backgroundTap:(id)sender {
    [textSearchField resignFirstResponder];
}


- (IBAction)dismissKeyboard:(id)sender {
    [sender resignFirstResponder];
}

- (IBAction)onSearch:(id)sender {
    
    NSLog(@"search for %@", textSearchField.text);
    KomomuSearchViewController* vc = [[KomomuSearchViewController alloc] init];
    vc.title = NSLocalizedString(@"Komomu",@"Komomu");
    [vc setStrData:textSearchField.text];
    textSearchField.text = @"";
    [textSearchField resignFirstResponder];
    [self.navigationController pushViewController:vc animated:YES];
    
}


- (void)storeAuthData:(NSString *)accessToken expiresAt:(NSDate *)expiresAt {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:accessToken forKey:@"FBAccessTokenKey"];
    [defaults setObject:expiresAt forKey:@"FBExpirationDateKey"];
    [defaults synchronize];
}

#pragma mark - FBSessionDelegate Methods
- (void)fbDidLogin {
    [self showLoggedIn];
    NSLog(@"did login");
    KomomuAppDelegate *delegate = (KomomuAppDelegate *)[[UIApplication sharedApplication] delegate];
    [self storeAuthData:[[delegate facebook] accessToken] expiresAt:[[delegate facebook] expirationDate]];
}



-(void)fbDidExtendToken:(NSString *)accessToken expiresAt:(NSDate *)expiresAt {
    NSLog(@"token extended");
    [self storeAuthData:accessToken expiresAt:expiresAt];
}

/**
 * Called when the user canceled the authorization dialog.
 */
-(void)fbDidNotLogin:(BOOL)cancelled {
}

/**
 * Called when the request logout has succeeded.
 */
- (void)fbDidLogout {
    
    
    // Remove saved authorization information if it exists and it is
    // ok to clear it (logout, session invalid, app unauthorized)
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:@"FBAccessTokenKey"];
    [defaults removeObjectForKey:@"FBExpirationDateKey"];
    [defaults synchronize];
    
    [self showLoggedOut];
}

/**
 * Called when the session has expired.
 */
- (void)fbSessionInvalidated {
    UIAlertView *alertView = [[UIAlertView alloc]
                              initWithTitle:@"Auth Exception"
                              message:@"Your session has expired."
                              delegate:nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil,
                              nil];
    [alertView show];
    [self fbDidLogout];
}

#pragma mark - FBRequestDelegate Methods
/**
 * Called when the Facebook API request has returned a response.
 *
 * This callback gives you access to the raw response. It's called before
 * (void)request:(FBRequest *)request didLoad:(id)result,
 * which is passed the parsed response object.
 */
- (void)request:(FBRequest *)request didReceiveResponse:(NSURLResponse *)response {
    //NSLog(@"received response");
}

/**
 * Called when a request returns and its response has been parsed into
 * an object.
 *
 * The resulting object may be a dictionary, an array or a string, depending
 * on the format of the API response. If you need access to the raw response,
 * use:
 *
 * (void)request:(FBRequest *)request
 *      didReceiveResponse:(NSURLResponse *)response
 */
- (void)request:(FBRequest *)request didLoad:(id)result {
    
    if ([result isKindOfClass:[NSArray class]]) {
        result = [result objectAtIndex:0];
    }
    // This callback can be a result of getting the user's basic
    // information or getting the user's permissions.
    KomomuAppDelegate *delegate = (KomomuAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    NSString *userName = [result objectForKey:@"name"];
    if (userName) {
        // If basic information callback, set the UI objects to
        // display this.
        //nameLabel.text = [result objectForKey:@"name"];
        NSLog(@"UID: %@", [result objectForKey:@"uid"]);
        // Get the profile image
        UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[result objectForKey:@"pic"]]]];
        
        // Resize, crop the image to make sure it is square and renders
        // well on Retina display
        float ratio;
        float delta;
        float px = 100; // Double the pixels of the UIImageView (to render on Retina)
        CGPoint offset;
        CGSize size = image.size;
        if (size.width > size.height) {
            ratio = px / size.width;
            delta = (ratio*size.width - ratio*size.height);
            offset = CGPointMake(delta/2, 0);
        } else {
            ratio = px / size.height;
            delta = (ratio*size.height - ratio*size.width);
            offset = CGPointMake(0, delta/2);
        }
        CGRect clipRect = CGRectMake(-offset.x, -offset.y,
                                     (ratio * size.width) + delta,
                                     (ratio * size.height) + delta);
        UIGraphicsBeginImageContext(CGSizeMake(px, px));
        UIRectClip(clipRect);
        [image drawInRect:clipRect];
        UIImage *imgThumb = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        [[delegate komomuUser] setProfilePhotoImage:imgThumb];
        [[delegate komomuUser] setName:userName];
        [[delegate komomuUser] setUserID:[result objectForKey:@"uid"]];
        
        [self apiGraphUserPermissions];
    } else {
        // Processing permissions information
        [delegate setUserPermissions:[[result objectForKey:@"data"] objectAtIndex:0]];
    }
}

/**
 * Called when an error prevents the Facebook API request from completing
 * successfully.
 */
- (void)request:(FBRequest *)request didFailWithError:(NSError *)error {
    NSLog(@"Err message: %@", [[error userInfo] objectForKey:@"error_msg"]);
    NSLog(@"Err code: %d", [error code]);
    
    
}


@end
