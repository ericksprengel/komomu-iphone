//
//  KomomuSearch1ViewController.h
//  Komomu
//
//  Created by Guille Uchima on 8/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KomomuSearch1ViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIButton *buttonSearch;
@property (weak, nonatomic) IBOutlet UITextField *textSearchField;

- (IBAction)dismissKeyboard:(id)sender;
- (IBAction)backgroundTap:(id)sender;
- (IBAction)onSearch:(id)sender;

@end
