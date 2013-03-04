//
//  KomomuPostCell.m
//  Komomu
//
//  Created by Guille Uchima on 7/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "KomomuPostCell.h"
#import "KomomuAppDelegate.h"

@implementation KomomuPostCell

@synthesize nameLabel = _nameLabel;
@synthesize thumbnailImageView = _thumbnailImageView;
@synthesize likesLabel = _likesLabel;

@synthesize imageLoadingOperation = imageLoadingOperation_;


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void) setTableData:(NSDictionary*) data {

    
    self.nameLabel.text = [data objectForKey:@"title"];
    _likesLabel.text = [[data objectForKey:@"likes"] stringValue];
        
    if ([data objectForKey:@"image"] != NULL && !([[data objectForKey:@"image"] isKindOfClass:[NSNull class]])) {
        NSString *loadingImageURLString = [data objectForKey:@"image"];
    self.imageLoadingOperation = [ApplicationDelegate.komomuEngine imageAtURL:[NSURL URLWithString:loadingImageURLString] 
                                                                 onCompletion:^(UIImage *fetchedImage, NSURL *url, BOOL isInCache) {
                                                                     
                                                                     if([loadingImageURLString isEqualToString:[url absoluteString]]) {
                                                                         
                                                                         if (isInCache) {
                                                                             self.thumbnailImageView.image = fetchedImage;
                                                                         } else {
                                                                             UIImageView *loadedImageView = [[UIImageView alloc] initWithImage:fetchedImage];
                                                                             loadedImageView.frame = self.thumbnailImageView.frame;
                                                                             loadedImageView.alpha = 0;
                                                                             [self.contentView addSubview:loadedImageView];
                                                                             
                                                                             [UIView animateWithDuration:0.4
                                                                                              animations:^
                                                                              {
                                                                                  loadedImageView.alpha = 1;
                                                                                  self.thumbnailImageView.alpha = 0;
                                                                              }
                                                                                              completion:^(BOOL finished)
                                                                              {
                                                                                  self.thumbnailImageView.image = fetchedImage;
                                                                                  self.thumbnailImageView.alpha = 1;
                                                                                  [loadedImageView removeFromSuperview];
                                                                              }];
                                                                         }
                                                                     }
                                                                 }];
     }
}

-(UITableView*)getTableView:(UIView*)theView
{
    if (!theView.superview)
        return nil;
    
    if ([theView.superview isKindOfClass:[UITableView class]])
        return (UITableView*)theView.superview;
    
    return [self getTableView:theView.superview];
}


- (void)setEditing:(BOOL)editing animated:(BOOL)animated
{
    // We suppress the Delete button by explicitly not calling
    // super's implementation
    if (supressDeleteButton)
    {
        // Reset the editing state of the table back to NO
        UITableView* tableView = [self getTableView:self];
        tableView.editing = NO;
    }
    else
        [super setEditing:editing animated:animated];
}

@end
