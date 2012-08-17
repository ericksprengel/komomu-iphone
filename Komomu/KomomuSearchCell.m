//
//  KomomuSearchCell.m
//  Komomu
//
//  Created by Guille Uchima on 7/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "KomomuSearchCell.h"
#import "KomomuAppDelegate.h"


@implementation KomomuSearchCell

@synthesize communityID;
@synthesize nameLabel = _nameLabel;
@synthesize descriptionLabel = _descriptionLabel;
@synthesize thumbnailImageView = _thumbnailImageView;
@synthesize imageLoadingOperation = imageLoadingOperation_;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
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
    self.descriptionLabel.text = [data objectForKey:@"desc"];
    
    self.communityID = [data objectForKey:@"idCommunity"];
    
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
