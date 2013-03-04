//
//  KomomuWebView.m
//  Komomu
//
//  Created by Guille Uchima on 12/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "KomomuWebView.h"

@implementation KomomuWebView
@synthesize title;


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void) setViewData:(NSDictionary*) data {
    //self.title.text = [data objectForKey:@"name"];
}

@end
