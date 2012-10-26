//
//  KomomuEngine.m
//  Komomu
//
//  Created by Guille Uchima on 6/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "KomomuEngine.h"
#import "NSDictionary+MutableDeepCopy.h"

#define YAHOO_URL(__C1__, __C2__) [NSString stringWithFormat:@"d/quotes.csv?e=.csv&f=sl1d1t1&s=%@%@=X", __C1__, __C2__]

@implementation KomomuEngine

-(MKNetworkOperation*) postDataToServer {
//    MKNetworkOperation *op = [self operationWithPath:@"Versions/1.5/login.php" 
//                                              params:[NSDictionary dictionaryWithObjectsAndKeys:
//                                                      @"bobs@thga.me", @"email",
//                                                      @"12345678", @"password", nil]
//                                          httpMethod:@"POST"];    
    
    MKNetworkOperation *op = [self operationWithPath:@"prototipo/komomu/communities.json" 
                                              params:nil
                                          httpMethod:@"GET"];    
    
    //[op setUsername:@"bobs@thga.me" password:@"12345678"];
    
    [op onCompletion:^(MKNetworkOperation *operation) {
        
        DLog(@"%@", operation);
    } onError:^(NSError *error) {
        
        DLog(@"%aaa@", error);
    }];
    
    [self enqueueOperation:op];
    
    return op;
}



-(void) searchCommunities:(NSString*) tag onCompletion:(ImagesResponseBlock) imageURLBlock onError:(MKNKErrorBlock) errorBlock {
 //   MKNetworkOperation *op = [self operationWithPath:FLICKR_IMAGE_URL([tag urlEncodedString])];
    MKNetworkOperation *op = [self operationWithPath:@"prototipo/komomu/communities.json"];
//       MKNetworkOperation *op = [self operationWithPath:@"komomu_API/api/listCommunities"];

    [op onCompletion:^(MKNetworkOperation *completedOperation) {
        
        NSDictionary *response = [completedOperation responseJSON];
        NSMutableArray *dict = [response objectForKey:@"communities"];

        NSMutableDictionary *mutableDictionary = [[NSMutableDictionary alloc] init];
        for (id objectInstance in dict)
            [mutableDictionary addEntriesFromDictionary:objectInstance];
     //   NSLog(@"%@", mutableDictionary);
        imageURLBlock(mutableDictionary);
        

    } onError:^(NSError *error) {
        
        errorBlock(error);
    }];
    
    [self enqueueOperation:op];
}


-(void) getCommunity:(NSMutableDictionary*) params onCompletion:(ImagesResponseBlock) imageURLBlock onError:(MKNKErrorBlock) errorBlock {

    MKNetworkOperation *op = [self operationWithPath:@"prototipo/komomu/a.json" params:params httpMethod:@"GET"];
    

    [op onCompletion:^(MKNetworkOperation *completedOperation) {
        
        NSDictionary *response = [completedOperation responseJSON];
        if(response!=nil) {
            NSDictionary *dict = [response objectForKey:@"community"];
            NSLog(@"%@", response);
    
            imageURLBlock(dict);
        }
        
    } onError:^(NSError *error) {
        
        errorBlock(error);
    }];
    
    [self enqueueOperation:op];
}

-(void) getFeed:(NSMutableDictionary*) params onCompletion:(ImagesResponseBlock) imageURLBlock onError:(MKNKErrorBlock) errorBlock {

    //TODO
    MKNetworkOperation *op = [self operationWithPath:@"prototipo/komomu/a.json" params:params httpMethod:@"GET"];
    
    
    [op onCompletion:^(MKNetworkOperation *completedOperation) {
        
        NSDictionary *response = [completedOperation responseJSON];
        if(response!=nil) {
            NSDictionary *dict = [response objectForKey:@"community"];
            NSLog(@"%@", response);
            
            imageURLBlock(dict);
        }
        
    } onError:^(NSError *error) {
        
        errorBlock(error);
    }];
    
    [self enqueueOperation:op];
}

@end
