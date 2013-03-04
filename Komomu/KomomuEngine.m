//
//  KomomuEngine.m
//  Komomu
//
//  Created by Guille Uchima on 6/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "KomomuEngine.h"
#import "NSDictionary+MutableDeepCopy.h"
#import "KomomuAppDelegate.h"

#define YAHOO_URL(__C1__, __C2__) [NSString stringWithFormat:@"d/quotes.csv?e=.csv&f=sl1d1t1&s=%@%@=X", __C1__, __C2__]

@implementation KomomuEngine

-(MKNetworkOperation*) postDataToServer {
//    MKNetworkOperation *op = [self operationWithPath:@"Versions/1.5/login.php" 
//                                              params:[NSDictionary dictionaryWithObjectsAndKeys:
//                                                      @"bobs@thga.me", @"email",
//                                                      @"12345678", @"password", nil]
//                                          httpMethod:@"POST"];    
    
//    MKNetworkOperation *op = [self operationWithPath:@"prototipo/komomu/communities.json" 
//                                              params:nil
//                                          httpMethod:@"GET"];    
    MKNetworkOperation *op = [self operationWithPath:@"~guilleuchima/komomu/communities.json" 
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
//    MKNetworkOperation *op = [self operationWithPath:@"~guilleuchima/komomu/communities.json"];
       MKNetworkOperation *op = [self operationWithPath:@"api/communities"];
    
    [op onCompletion:^(MKNetworkOperation *completedOperation) {
        NSDictionary *response = [completedOperation responseJSON];
        NSMutableArray *dict = [response objectForKey:@"communities"];

        NSMutableDictionary *mutableDictionary = [[NSMutableDictionary alloc] init];
        for (id objectInstance in dict)
            [mutableDictionary addEntriesFromDictionary:objectInstance];
        NSLog(@"%@", mutableDictionary);
        imageURLBlock(mutableDictionary);
        

    } onError:^(NSError *error) {
        
        errorBlock(error);
    }];
    
    [self enqueueOperation:op];
}


-(void) getCommunity:(NSMutableDictionary*) params onCompletion:(ImagesResponseBlock) imageURLBlock onError:(MKNKErrorBlock) errorBlock {

//    MKNetworkOperation *op = [self operationWithPath:@"~guilleuchima/komomu/a.json" params:params httpMethod:@"GET"];
    
    NSString *path = [NSString stringWithFormat:@"api/communities/%@", [params objectForKey: @"communityID"]];
    
    NSMutableDictionary *p = [[NSMutableDictionary alloc] init];
    [p setObject:[params valueForKey:@"type"] forKey:@"type"];

    
    MKNetworkOperation *op = [self operationWithPath:path params:p httpMethod:@"GET"];

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
    [self enqueueOperation:op forceReload:YES];
}

-(void) getUser:(NSMutableDictionary*) params onCompletion:(ImagesResponseBlock) imageURLBlock onError:(MKNKErrorBlock) errorBlock {
    
    //    MKNetworkOperation *op = [self operationWithPath:@"~guilleuchima/komomu/a.json" params:params httpMethod:@"GET"];
    
    NSString *path = [NSString stringWithFormat:@"api/users"];
    
    NSMutableDictionary *p = [[NSMutableDictionary alloc] init];    
    
    MKNetworkOperation *op = [self operationWithPath:path params:p httpMethod:@"GET"];
    
    [op onCompletion:^(MKNetworkOperation *completedOperation) {
        
        NSDictionary *response = [completedOperation responseJSON];
        if(response!=nil) {
            NSDictionary *dict = [response objectForKey:@"user"];
            NSLog(@"%@", response);
            
            imageURLBlock(dict);
        }
        
    } onError:^(NSError *error) {
        
        errorBlock(error);
    }];
    [self enqueueOperation:op forceReload:YES];
}


-(void) prepareHeaders:(MKNetworkOperation*) operation {
    KomomuAppDelegate *delegate = (KomomuAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    NSMutableDictionary *headerFields = [NSMutableDictionary dictionary]; 
    [headerFields setValue:[delegate komomuUser].userID forKey:@"user_id"];
    [headerFields setValue:[delegate komomuUser].mobile_token forKey:@"mobile_token"];
    
    [operation addHeaders:headerFields];
}

-(void) getFeed:(NSMutableDictionary*) params onCompletion:(ImagesResponseBlock) imageURLBlock onError:(MKNKErrorBlock) errorBlock {

    //TODO
    MKNetworkOperation *op = [self operationWithPath:@"api/posts" params:params httpMethod:@"GET"];
    
    
    [op onCompletion:^(MKNetworkOperation *completedOperation) {
        
        NSDictionary *response = [completedOperation responseJSON];
        if(response!=nil) {
            NSLog(@"%@", response);
            
            imageURLBlock(response);
        }
        
    } onError:^(NSError *error) {
        
        errorBlock(error);
    }];
    
    [self enqueueOperation:op forceReload:YES];
}

-(void) session:(NSMutableDictionary*) params onCompletion:(ImagesResponseBlock) imageURLBlock onError:(MKNKErrorBlock) errorBlock {
    
    NSMutableDictionary *p = [[NSMutableDictionary alloc] init];
    [p setObject:params forKey:@"credentials"];


//    MKNetworkOperation *op = [self operationWithURLString:@"http://ericksprengel.no-ip.info:8080/api/session" params:p httpMethod:@"POST"];
    MKNetworkOperation *op = [self operationWithURLString:@"http://komomu-api.herokuapp.com/api/session" params:p httpMethod:@"POST"];
    op.postDataEncoding = MKNKPostDataEncodingTypeJSON;
    
    [op onCompletion:^(MKNetworkOperation *completedOperation) {
        
        NSDictionary *response = [completedOperation responseJSON];
        if(response!=nil) {
            NSDictionary *dict = [response objectForKey:@"user"];
            NSLog(@"%@", response);
            imageURLBlock(dict);
        }
        
    } onError:^(NSError *error) {
        
        errorBlock(error);
    }];
    
    [self enqueueOperation:op forceReload:YES];
}

-(void) follow:(NSMutableDictionary*) params onError:(MKNKErrorBlock) errorBlock {
        
    
     NSString *path = [NSString stringWithFormat:@"api/communities/%@/like?value=%@", [params objectForKey: @"id"], [params objectForKey:@"action"]];
    
    MKNetworkOperation *op = [self operationWithPath:path params:nil httpMethod:@"POST"];
  //  op.postDataEncoding = MKNKPostDataEncodingTypeJSON;
    
    [op onCompletion:^(MKNetworkOperation *completedOperation) {
        
        NSDictionary *response = [completedOperation responseJSON];
        if(response!=nil) {
            NSLog(@"%@", response);
        }
        
    } onError:^(NSError *error) {
        
        errorBlock(error);
    }];
    
    [self enqueueOperation:op forceReload:YES];
}

-(void) like:(NSMutableDictionary*) params onCompletion:(ImagesResponseBlock) imageURLBlock onError:(MKNKErrorBlock) errorBlock {
    
    //TODO
    NSString *path = [NSString stringWithFormat:@"api/posts/%@/like?value=%@", [params objectForKey: @"id"], [params objectForKey:@"action"]];
    
    MKNetworkOperation *op = [self operationWithPath:path params:nil httpMethod:@"POST"];
    
    [op onCompletion:^(MKNetworkOperation *completedOperation) {
        
        NSDictionary *response = [completedOperation responseJSON];
        if(response!=nil) {
            NSLog(@"%@", response);
            imageURLBlock(response);
        }
        
    } onError:^(NSError *error) {
        
        errorBlock(error);
    }];
    
    [self enqueueOperation:op forceReload:YES];
}

@end
