//
//  KomomuPostCell.h
//  Komomu
//
//  Created by Guille Uchima on 7/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KomomuPostCell : UITableViewCell {
    BOOL supressDeleteButton;
}

@property (nonatomic, weak) IBOutlet UILabel *nameLabel;
@property (nonatomic, weak) IBOutlet UIImageView *thumbnailImageView;


@property (nonatomic, strong) MKNetworkOperation* imageLoadingOperation;
-(void) setTableData:(NSDictionary*) data;

@end
