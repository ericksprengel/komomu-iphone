//
//  KomomuEngine.h
//  Komomu
//
//  Created by Guille Uchima on 6/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MKNetworkEngine.h"
#define FLICKR_KEY @"210af0ac7c5dad997a19f7667e5779d3"
#define FLICKR_IMAGE_URL(__TAG__) [NSString stringWithFormat:@"services/rest/?method=flickr.photos.search&api_key=%@&tags=%@&per_page=200&format=json&nojsoncallback=1", FLICKR_KEY, __TAG__]


@interface KomomuEngine : MKNetworkEngine

-(MKNetworkOperation*) postDataToServer;
typedef void (^ImagesResponseBlock)(NSDictionary* imageURLs);

-(void) searchCommunities:(NSString*) tag onCompletion:(ImagesResponseBlock) imageURLBlock onError:(MKNKErrorBlock) errorBlock;

-(void) getCommunity:(NSMutableDictionary*) params onCompletion:(ImagesResponseBlock) imageURLBlock onError:(MKNKErrorBlock) errorBlock;
-(void) getUser:(NSMutableDictionary*) params onCompletion:(ImagesResponseBlock) imageURLBlock onError:(MKNKErrorBlock) errorBlock;

-(void) getFeed:(NSMutableDictionary*) params onCompletion:(ImagesResponseBlock) imageURLBlock onError:(MKNKErrorBlock) errorBlock;
-(void) session:(NSMutableDictionary*) params onCompletion:(ImagesResponseBlock) imageURLBlock onError:(MKNKErrorBlock) errorBlock;

-(void) follow:(NSMutableDictionary*) params  onError:(MKNKErrorBlock) errorBlock;
-(void) like:(NSMutableDictionary*) params onCompletion:(ImagesResponseBlock) imageURLBlock onError:(MKNKErrorBlock) errorBlock;



@end
