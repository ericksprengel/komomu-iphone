//
//  KomomuTabBarViewController.m
//  Komomu
//
//  Created by Guille Uchima on 7/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "KomomuTabBarViewController.h"
#import "KomomuProfileViewController.h"
#import "KomomuFeedViewController.h"
@interface KomomuTabBarViewController ()

@end

@implementation KomomuTabBarViewController

@synthesize firstTab = _firstTab;
@synthesize userID = _userID;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil tab: (KomomuViewController *)firstTab userID:(NSString *)userID;
{
    _firstTab = firstTab;
    _userID = userID;
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [super viewDidLoad];
    
    

    KomomuFeedViewController *hotViewController = [self viewControllerWithNibName:@"KomomuFeedViewController" image:[UIImage imageNamed:@"news.png"]];
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    
    if(_userID!=nil) {
        [params setObject:_userID forKey:@"communityID"];
        [params setObject:@"hot" forKey:@"type"];
    }
    
    hotViewController.params = params;
    hotViewController.title = @"Feed";

    
   // UIViewController *searchViewController = [self viewControllerWithNibName:@"KomomuSearch1ViewController" image:[UIImage imageNamed:@"news.png"]];
    UIViewController *searchViewController = _firstTab;
    searchViewController.title = @"Search";
    searchViewController.tabBarItem.image = [UIImage imageNamed:@"search.png"];
    
    UIViewController *profileViewController = [self viewControllerWithNibName:@"KomomuProfileViewController" image:[UIImage imageNamed:@"123-id-card.png"]];
    profileViewController.title = @"User";
    
    
    self.viewControllers = [NSArray arrayWithObjects:
                            hotViewController,
                            searchViewController,
                            profileViewController, nil];
    
    self.selectedIndex = 1;
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (void)hideTabBar: (BOOL)hidden
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0];
    CGFloat y;
    if(hidden) {
        y=480;
    } else {
        y=361;
    }
    
    for(UIView *view in self.view.subviews)
    {
        if([view isKindOfClass:[UITabBar class]])
        {
            [view setFrame:CGRectMake(view.frame.origin.x, y, view.frame.size.width, view.frame.size.height)];
        } 
        else 
        {
            [view setFrame:CGRectMake(view.frame.origin.x, view.frame.origin.y, view.frame.size.width, y)];
        }
    }
    
    [UIView commitAnimations];   
}

@end
