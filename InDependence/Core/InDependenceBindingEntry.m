//
//  RSInjectorRegistrationEntry.m
//  InDependence
//
//  Created by Yan Rabovik on 27.02.13.
//  Copyright (c) 2013 Yan Rabovik. All rights reserved.
//

#import "InDependenceBindingEntry.h"

@implementation InDependenceBindingEntry{
    NSMutableDictionary *_storage;
}

-(id)init{
	self = [super init];
	if (nil == self) return nil;
    
	_storage = [NSMutableDictionary new];
    
	return self;
}

-(void)setObject:(id)object forKey:(NSString *)aKey{
    [_storage setObject:object forKey:aKey];
}

-(id)objectForKey:(NSString *)key{
    return [_storage objectForKey:key];
}


@end
