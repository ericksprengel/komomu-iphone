//
//  KomomuContentView.m
//  Komomu
//
//  Created by Guille Uchima on 7/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "KomomuContentView.h"
#import "KomomuAppDelegate.h"

@implementation KomomuContentView
@synthesize title;
@synthesize text;
@synthesize scrollView;

@synthesize image;
@synthesize imageLoadingOperation;

@synthesize web;


- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}

-(void) setViewData:(NSDictionary*) data {
//    NSString *loadingImageURLString = [data objectForKey:@"image"];
//    self.title.text = [data objectForKey:@"name"];
//    NSString *texto = [data objectForKey:@"text"];
//    
//    CGSize maximumLabelSize = CGSizeMake(280,9999);
//    
//    UIFont *myFont = [UIFont systemFontOfSize:14];
//    CGSize myStringSize = [texto sizeWithFont:myFont constrainedToSize:maximumLabelSize lineBreakMode:UILineBreakModeWordWrap];
//    
//    CGRect newFrame = self.text.frame;
//    newFrame.size.height = myStringSize.height + 100;
//    self.text.frame = newFrame;
//    self.text.text = texto;
//    
//    self.scrollView.frame = CGRectMake(0, 20, 320, 480);
//    [self.scrollView setContentSize:CGSizeMake(myStringSize.width, myStringSize.height + 400)];
//    
//    self.imageLoadingOperation = [ApplicationDelegate.komomuEngine imageAtURL:[NSURL URLWithString:loadingImageURLString] 
//                                                                 onCompletion:^(UIImage *fetchedImage, NSURL *url, BOOL isInCache) {
//                                                                     
//                                                                     if([loadingImageURLString isEqualToString:[url absoluteString]]) {
//                                                                         
//                                                                         if (isInCache) {
//                                                                             self.image.image = fetchedImage;
//                                                                         } else {
//                                                                             UIImageView *loadedImageView = [[UIImageView alloc] initWithImage:fetchedImage];
//                                                                             loadedImageView.frame = self.image.frame;
//                                                                             loadedImageView.alpha = 0;
//                                                                             [self addSubview:loadedImageView];
//                                                                             
//                                                                             [UIView animateWithDuration:0.4
//                                                                                              animations:^
//                                                                              {
//                                                                                  loadedImageView.alpha = 1;
//                                                                                  self.image.alpha = 0;
//                                                                              }
//                                                                                              completion:^(BOOL finished)
//                                                                              {
//                                                                                  self.image.image = fetchedImage;
//                                                                                  self.image.alpha = 1;
//                                                                                  [loadedImageView removeFromSuperview];
//                                                                              }];
//                                                                         }
//                                                                     }
//                                                                 }];
    NSString *urlAddress = [data objectForKey:@"url"];
    
    //Create a URL object.
    NSURL *url = [NSURL URLWithString:urlAddress];
    
    //URL Requst Object
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
    
    //Load the request in the UIWebView.
    [web loadRequest:requestObj];
}


@end
