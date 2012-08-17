//
//  KomomuSearch1ViewController.m
//  Komomu
//
//  Created by Guille Uchima on 8/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "KomomuSearch1ViewController.h"
#import "KomomuSearchViewController.h"


@interface KomomuSearch1ViewController ()


@end

@implementation KomomuSearch1ViewController

@synthesize buttonSearch;
@synthesize textSearchField;

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
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = backButton;
    self.view.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"background.png"]];
    
    UIImage *buttonImageNormal = [UIImage imageNamed:@"blackbutton.png"];
    UIImage *stretchableButtonImageNormal = [buttonImageNormal stretchableImageWithLeftCapWidth:12 topCapHeight:0];
    [buttonSearch setBackgroundImage:stretchableButtonImageNormal forState:UIControlStateNormal];
    [self.buttonSearch setTitle:@"Pesquisar" forState:UIControlStateNormal];
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


- (IBAction)backgroundTap:(id)sender {
    [textSearchField resignFirstResponder];
}


- (IBAction)dismissKeyboard:(id)sender {
    [sender resignFirstResponder];
}

- (IBAction)onSearch:(id)sender {
    
    NSLog(@"search for %@", textSearchField.text);
    KomomuSearchViewController* vc = [[KomomuSearchViewController alloc] init];
    vc.title = NSLocalizedString(@"Komomu",@"Komomu");
    [vc setStrData:textSearchField.text];
    textSearchField.text = @"";
    [textSearchField resignFirstResponder];
    [self.navigationController pushViewController:vc animated:YES];
    
}

@end
