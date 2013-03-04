//
//  KomomuCommentViewController.h
//  Komomu
//
//  Created by Guille Uchima on 2/4/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KomomuCommentViewController : UIViewController {
    IBOutlet UIWebView *webView;
}

@property (nonatomic, retain) UIWebView *webView;
@property (nonatomic, retain) NSString *post_ID;


@end
