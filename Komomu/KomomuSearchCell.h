//
//  KomomuSearchCell.h
//  Komomu
//
//  Created by Guille Uchima on 7/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KomomuSearchCell : UITableViewCell {
    NSString *communityID;
}

@property (nonatomic, retain) NSString *communityID;
@property (nonatomic, retain) NSString *following;
@property (nonatomic, weak) IBOutlet UILabel *nameLabel;
@property (nonatomic, weak) IBOutlet UILabel *descriptionLabel;
@property (nonatomic, weak) IBOutlet UIImageView *thumbnailImageView;

@property (nonatomic, strong) MKNetworkOperation* imageLoadingOperation;
-(void) setTableData:(NSDictionary*) data;
-(void) setTableData2;
@end
