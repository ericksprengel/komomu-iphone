//
//  KomomuWebView.h
//  Komomu
//
//  Created by Guille Uchima on 12/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KomomuWebView : UIView

@property (weak, nonatomic) IBOutlet UILabel *title;

-(void) setViewData:(NSDictionary*) data;
@end
