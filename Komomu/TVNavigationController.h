//
//  TVNavigationController.h
//  Komomu
//
//  Created by Guille Uchima on 8/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TVNavigationController :  UINavigationController {
    UIViewController *fakeRootViewController;
}

@property(nonatomic, retain) UIViewController *fakeRootViewController;

-(void)setRootViewController:(UIViewController *)rootViewController;

@end

