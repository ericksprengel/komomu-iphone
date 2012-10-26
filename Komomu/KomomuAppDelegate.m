//
//  KomomuAppDelegate.m
//  Komomu
//
//  Created by Guille Uchima on 6/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "KomomuAppDelegate.h"
#import "KomomuTabBarViewController.h"

#define FACEBOOK_APP_ID @"268356133266355"

@implementation KomomuAppDelegate

@synthesize window = _window;
@synthesize navController = _navController;
@synthesize tabBarController = _tabBarController;

@synthesize komomuEngine = _komomuEngine;
@synthesize facebook;
@synthesize userPermissions;
@synthesize komomuUser = _komomuUser;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    _window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    /*
     * headerFields?
     */
    NSMutableDictionary *headerFields = [NSMutableDictionary dictionary]; 
    [headerFields setValue:@"iOS" forKey:@"x-client-identifier"];
    
    // Init komomuEngine
    //  self.komomuEngine = [[KomomuEngine alloc] initWithHostName:@"192.168.0.180"customHeaderFields:nil];
    _komomuEngine = [[KomomuEngine alloc] initWithHostName:@"komomu.com"customHeaderFields:headerFields];
    [_komomuEngine useCache];
    
    KomomuViewController *controller = [[KomomuViewController alloc] initWithNibName:@"KomomuViewController" bundle:nil];
    
    KomomuTabBarViewController* tabBarViewController = [[KomomuTabBarViewController alloc] initWithNibName:nil bundle:nil tab:controller userID:@"10"];
    _tabBarController = tabBarViewController;


    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:tabBarViewController];
    navigationController.navigationBar.tintColor = [UIColor darkTextColor];
    navigationController.navigationBar.topItem.title = NSLocalizedString(@"Komomu",@"Komomu");
    _navController = navigationController;
    
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
    
    _window.rootViewController = _navController;   
    
    [_window makeKeyAndVisible];
    
    return YES;
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

@end
