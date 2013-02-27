//
//  RSInjector.m
//  InDependence
//
//  Created by Yan Rabovik on 26.02.13.
//  Copyright (c) 2013 Yan Rabovik. All rights reserved.
//

#import "RSInjector.h"
#import <objc/runtime.h>

typedef id(^InstantiatorBlock)(void);

@implementation RSInjector{
    NSMutableDictionary *_bindings;
}

#pragma mark - Init

- (id)init{
    self = [super init];
    if (!self) return nil;
    
    _bindings = [NSMutableDictionary new];
    
    return self;
}

+(id)sharedInjector{
    static dispatch_once_t once;
    static id sharedInstance;
    dispatch_once(&once, ^{
        sharedInstance = [[self class] new];
    });
    return sharedInstance;
}

#pragma mark - Object factory

-(id)getObject:(id)klass{
    return nil;
}

#pragma mark - Bindings

-(void)bindClass:(Class)aClass toClass:(Class)toClass{
    NSString *key = NSStringFromClass(toClass);
    NSString *val = NSStringFromClass(aClass);
    [_bindings setObject:val forKey:key];
}


@end
