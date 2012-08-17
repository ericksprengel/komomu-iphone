//
//  KomomuCommunityInfoCell.m
//  Komomu
//
//  Created by Guille Uchima on 8/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "KomomuCommunityInfoCell.h"
#import "KomomuAppDelegate.h"

@implementation KomomuCommunityInfoCell

@synthesize nameLabel = _nameLabel;
@synthesize thumbnailImageView = _thumbnailImageView;

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
    
    
    NSString *loadingImageURLString = [data objectForKey:@"image"];
    self.nameLabel.text = [data objectForKey:@"name"];
    
    
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


@end
