//
//  KomomuEngineAux.m
//  Komomu
//
//  Created by Guille Uchima on 12/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "KomomuEngineAux.h"

@implementation KomomuEngineAux
//-(void) session:(NSMutableDictionary*) params onCompletion:(ImagesResponseBlock) imageURLBlock onError:(MKNKErrorBlock) errorBlock {
//    
//    NSMutableDictionary *p = [[NSMutableDictionary alloc] init];
//    [p setObject:params forKey:@"credentials"];
//    
//    
//    MKNetworkOperation *op = [self operationWithURLString:@"http://ericksprengel.no-ip.info:8080/api/session" params:p httpMethod:@"POST"];
//    op.postDataEncoding = MKNKPostDataEncodingTypeJSON;
//    
//    [op onCompletion:^(MKNetworkOperation *completedOperation) {
//        
//        NSDictionary *response = [completedOperation responseJSON];
//        if(response!=nil) {
//            NSDictionary *dict = [response objectForKey:@"user"];
//            NSLog(@"%@", response);
//            imageURLBlock(dict);
//        }
//        
//    } onError:^(NSError *error) {
//        
//        errorBlock(error);
//    }];
//    
//    [self enqueueOperation:op];
//}
@end
