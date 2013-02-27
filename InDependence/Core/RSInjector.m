//
//  RSInjector.m
//  InDependence
//
//  Created by Yan Rabovik on 26.02.13.
//  Copyright (c) 2013 Yan Rabovik. All rights reserved.
//

#import "RSInjector.h"
#import <objc/runtime.h>
#import "RSInjectorRegistrationEntry.h"

typedef id(^InstantiatorBlock)(void);

static NSMutableDictionary *gRegistrationContext;

@implementation RSInjector{
    NSMutableDictionary *_bindings;
}

#pragma mark - Init

+ (void)initialize  {
    if (self == [RSInjector class]) {
        gRegistrationContext = [NSMutableDictionary new];
    }
}

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

#pragma mark - Registrations
+(void)registerClass:(id)klass{
    if (!klass) return;
    NSString *key = NSStringFromClass(klass);
    if ([gRegistrationContext objectForKey:key]) return;
    
    RSInjectorRegistrationEntry *entry = [RSInjectorRegistrationEntry new];
    //entry.klass = klass;
    [gRegistrationContext setObject:entry forKey:key];
    
    NSLog(@"Registered class %@",klass);
    
    Class superClass = class_getSuperclass([klass class]);
    [self registerClass:superClass];
}

#pragma mark - Object factory

-(id)getObject:(id)klass{
    [[self class] registerClass:klass];
    return nil;
}

#pragma mark - Bindings

-(void)bindClass:(Class)aClass toClass:(Class)toClass{
    NSString *key = NSStringFromClass(toClass);
    NSString *val = NSStringFromClass(aClass);
    [_bindings setObject:val forKey:key];
}


@end
