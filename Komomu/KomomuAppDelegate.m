//
//  KomomuAppDelegate.m
//  Komomu
//
//  Created by Guille Uchima on 6/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "KomomuAppDelegate.h"

#import "KomomuViewController.h"

#define FACEBOOK_APP_ID @"268356133266355"

@implementation KomomuAppDelegate

@synthesize window = _window;
@synthesize navController = _navController;
@synthesize komomuEngine = _komomuEngine;
@synthesize facebook;
@synthesize userPermissions;
@synthesize komomuUser = _komomuUser;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];

    /*
     * headerFields?
     */
    NSMutableDictionary *headerFields = [NSMutableDictionary dictionary]; 
    [headerFields setValue:@"iOS" forKey:@"x-client-identifier"];
    
   // self.komomuEngine = [[KomomuEngine alloc] initWithHostName:@"api.flickr.com"customHeaderFields:nil];
//    self.komomuEngine = [[KomomuEngine alloc] initWithHostName:@"192.168.0.180"customHeaderFields:nil];
    self.komomuEngine = [[KomomuEngine alloc] initWithHostName:@"192.168.0.65"customHeaderFields:nil];
    [self.komomuEngine useCache];
    
    // Override point for customization after application launch.
 
    UIViewController *controller = [[KomomuViewController alloc] initWithNibName:@"KomomuViewController" bundle:nil];

    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:controller];
    
    navigationController.navigationBar.tintColor = [UIColor darkTextColor];
    navigationController.navigationBar.topItem.title = NSLocalizedString(@"Komomu",@"Komomu");
    
    self.navController = navigationController;
    
    /*
     * Facebook
     */
    facebook = [[Facebook alloc] initWithAppId:FACEBOOK_APP_ID andDelegate:controller];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults objectForKey:@"FBAccessTokenKey"] 
        && [defaults objectForKey:@"FBExpirationDateKey"]) {
        facebook.accessToken = [defaults objectForKey:@"FBAccessTokenKey"];
        facebook.expirationDate = [defaults objectForKey:@"FBExpirationDateKey"];
    }

    userPermissions = [[NSMutableDictionary alloc] initWithCapacity:1];
    _komomuUser = [[KomomuUser alloc] init];
    
   self.window.rootViewController = self.navController;   

    [self.window makeKeyAndVisible];
    
//    
//    // Check App ID:
//    // This is really a warning for the developer, this should not
//    // happen in a completed app
//    if (!FACEBOOK_APP_ID) {
//        UIAlertView *alertView = [[UIAlertView alloc]
//                                  initWithTitle:@"Setup Error"
//                                  message:@"Missing app ID. You cannot run the app until you provide this in the code."
//                                  delegate:self
//                                  cancelButtonTitle:@"OK"
//                                  otherButtonTitles:nil,
//                                  nil];
//        [alertView show];
//    } else {
//        // Now check that the URL scheme fb[app_id]://authorize is in the .plist and can
//        // be opened, doing a simple check without local app id factored in here
//        NSString *url = [NSString stringWithFormat:@"fb%@://authorize",FACEBOOK_APP_ID];
//        BOOL bSchemeInPlist = NO; // find out if the sceme is in the plist file.
//        NSArray* aBundleURLTypes = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleURLTypes"];
//        if ([aBundleURLTypes isKindOfClass:[NSArray class]] &&
//            ([aBundleURLTypes count] > 0)) {
//            NSDictionary* aBundleURLTypes0 = [aBundleURLTypes objectAtIndex:0];
//            if ([aBundleURLTypes0 isKindOfClass:[NSDictionary class]]) {
//                NSArray* aBundleURLSchemes = [aBundleURLTypes0 objectForKey:@"CFBundleURLSchemes"];
//                if ([aBundleURLSchemes isKindOfClass:[NSArray class]] &&
//                    ([aBundleURLSchemes count] > 0)) {
//                    NSString *scheme = [aBundleURLSchemes objectAtIndex:0];
//                    if ([scheme isKindOfClass:[NSString class]] &&
//                        [url hasPrefix:scheme]) {
//                        bSchemeInPlist = YES;
//                    }
//                }
//            }
//        }
//        // Check if the authorization callback will work
//        BOOL bCanOpenUrl = [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString: url]];
//        if (!bSchemeInPlist || !bCanOpenUrl) {
//            UIAlertView *alertView = [[UIAlertView alloc]
//                                      initWithTitle:@"Setup Error"
//                                      message:@"Invalid or missing URL scheme. You cannot run the app until you set up a valid URL scheme in your .plist."
//                                      delegate:self
//                                      cancelButtonTitle:@"OK"
//                                      otherButtonTitles:nil,
//                                      nil];
//            [alertView show];
//        }
//    }

    return YES;
}

//TODO DELETEME
- (void) logoutButtonClicked:(id)sender {
    [facebook logout];
}

// Pre iOS 4.2 support
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    return [[self facebook] handleOpenURL:url];
}

// For iOS 4.2+ support
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    return [[self facebook] handleOpenURL:url];
}



- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [[self facebook] extendAccessTokenIfNeeded];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

/*
// Optional UITabBarControllerDelegate method.
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
}
*/

/*
// Optional UITabBarControllerDelegate method.
- (void)tabBarController:(UITabBarController *)tabBarController didEndCustomizingViewControllers:(NSArray *)viewControllers changed:(BOOL)changed
{
}
*/

@end
