//
//  KomomuContentView.h
//  Komomu
//
//  Created by Guille Uchima on 7/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KomomuContentView : UIView
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UITextView *text;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (nonatomic, strong) MKNetworkOperation* imageLoadingOperation;
-(void) setViewData:(NSDictionary*) data;

@end
