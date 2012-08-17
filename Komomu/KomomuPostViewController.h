//
//  KomomuPostViewController.h
//  Komomu
//
//  Created by Guille Uchima on 7/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ATPagingView.h"

@interface KomomuPostViewController : ATPagingViewController {
    NSArray *posts;
    NSInteger *selectedRow;
}

@property (nonatomic, retain) NSArray *posts;
@property (nonatomic) NSInteger *selectedRow;
@end
