//
//  KomomuAppDelegate.h
//  Komomu
//
//  Created by Guille Uchima on 6/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KomomuEngine.h"
#import "KomomuViewController.h"
#import "KomomuUser.h"
#import "FBConnect.h"
#import "KomomuTabBarViewController.h"


#define ApplicationDelegate ((KomomuAppDelegate *)[UIApplication sharedApplication].delegate)


@interface KomomuAppDelegate : UIResponder <UIApplicationDelegate, UINavigationControllerDelegate> {
    Facebook *facebook;
    NSMutableDictionary *userPermissions;
}

@property (strong, nonatomic) KomomuEngine *komomuEngine;
@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) UINavigationController *navController;
@property (strong, nonatomic) KomomuTabBarViewController *tabBarController;


@property(nonatomic, retain) KomomuUser *komomuUser;
@property (nonatomic, retain) Facebook *facebook;
@property (nonatomic, retain) NSMutableDictionary *userPermissions;


@end
