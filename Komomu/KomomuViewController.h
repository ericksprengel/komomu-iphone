//
//  KomomuViewController.h
//  Komomu
//
//  Created by Guille Uchima on 6/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FBConnect.h"

@interface KomomuViewController : UIViewController <FBRequestDelegate,
FBDialogDelegate,
FBSessionDelegate> {
    NSArray *permissions;
    UIImageView *backgroundImageView;
    
    UIButton *loginButton;

}

@property (nonatomic, retain) NSArray *permissions;
@property (nonatomic, retain) UIImageView *backgroundImageView;

@property (weak, nonatomic) IBOutlet UIButton *buttonSearch;
@property (weak, nonatomic) IBOutlet UITextField *textSearchField;

- (IBAction)dismissKeyboard:(id)sender;
- (IBAction)backgroundTap:(id)sender;
- (IBAction)onSearch:(id)sender;

@end
