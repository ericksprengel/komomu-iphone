//
//  KomomuTabBarViewController.m
//  Komomu
//
//  Created by Guille Uchima on 7/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "KomomuTabBarViewController.h"
#import "KomomuProfileViewController.h"
#import "KomomuComunityViewController.h"
@interface KomomuTabBarViewController ()

@end

@implementation KomomuTabBarViewController

@synthesize communityID;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil community: (NSString *)communityID
{
    self.communityID = communityID;
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
    
    

    KomomuComunityViewController *hotViewController = [self viewControllerWithNibName:@"KomomuComunityViewController" image:[UIImage imageNamed:@"112-group.png"]];
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    if(self.communityID!=nil) {
        [params setObject:self.communityID forKey:@"communityID"];
        [params setObject:@"hot" forKey:@"type"];
    }
    hotViewController.params = params;
    hotViewController.title = @"Hot";
    
    
    KomomuComunityViewController *newViewController = [self viewControllerWithNibName:@"KomomuComunityViewController" image:[UIImage imageNamed:@"29-heart.png"]];
    [params setObject:@"news" forKey:@"type"];
    newViewController.params = params;
    newViewController.title = @"News";
    
    UIViewController *searchViewController = [self viewControllerWithNibName:@"KomomuSearch1ViewController" image:[UIImage imageNamed:@"news.png"]];
    searchViewController.title = @"Search";
    
    UIViewController *profileViewController = [self viewControllerWithNibName:@"KomomuProfileViewController" image:[UIImage imageNamed:@"123-id-card.png"]];
    profileViewController.title = @"User";
    
    
    self.viewControllers = [NSArray arrayWithObjects:
                            hotViewController,
                            newViewController,
                            [self viewControllerWithTabTitle:@"Share" image:nil],
                            searchViewController,
                            profileViewController, nil];
    [self addCenterButtonWithImage:[UIImage imageNamed:@"cameraTabBarItem.png"] highlightImage:nil];
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

@end
