//
//  NSDictionary+MutableDeepCopy.m
//  Komomu
//
//  Created by Guille Uchima on 6/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "NSDictionary+MutableDeepCopy.h"

/*
 * Creates a new mutable dictionary and then loops through all the keys of the original 
 * dictionary, making mutable copies of each array it encounters.
 */
@implementation NSDictionary (MutableDeepCopy)
- (NSMutableDictionary *)mutableDeepCopy {
    NSMutableDictionary *returnDict = [[NSMutableDictionary alloc] initWithCapacity:[self count]]; 
    NSArray *keys = [self allKeys];
    for (id key in keys) {
        id oneValue = [self valueForKey:key]; 
        id oneCopy = nil;
        if ([oneValue respondsToSelector:@selector(mutableDeepCopy)]) 
            oneCopy = [oneValue mutableDeepCopy];
        else if ([oneValue respondsToSelector:@selector(mutableCopy)]) 
            oneCopy = [oneValue mutableCopy];
        if (oneCopy == nil)
            oneCopy = [oneValue copy];
        [returnDict setValue:oneCopy forKey:key]; 
    }
    return returnDict; 
}

@end
