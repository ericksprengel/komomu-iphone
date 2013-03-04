//
//  KomomuPostViewController.m
//  Komomu
//
//  Created by Guille Uchima on 7/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "KomomuPostViewController.h"
#import "KomomuContentView.h"
#import "KomomuWebView.h"


#import "KomomuAppDelegate.h"

@interface KomomuPostViewController ()

@end

@implementation KomomuPostViewController
@synthesize posts;
@synthesize selectedRow;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.pagingView.horizontal = YES;
    self.pagingView.currentPageIndex = selectedRow;
    [self currentPageDidChangeInPagingView:self.pagingView];
}

#pragma mark -
#pragma mark ATPagingViewDelegate methods

- (NSInteger)numberOfPagesInPagingView:(ATPagingView *)pagingView {
    return [self.posts count];
}

- (UIView *)viewForPageInPagingView:(ATPagingView *)pagingView atIndex:(NSInteger)index {
    KomomuContentView *view = [pagingView dequeueReusablePage];
     NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"KomomuContentView" owner:self options:nil];

    view = [nib objectAtIndex:0];
    
  [view setViewData:[self.posts objectAtIndex:index]];
    
    return view;

}

- (void)currentPageDidChangeInPagingView:(ATPagingView *)pagingView {
    self.navigationItem.title = [NSString stringWithFormat:@"%d of %d", pagingView.currentPageIndex+1, pagingView.pageCount];
}


@end
