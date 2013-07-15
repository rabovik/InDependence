//
//  InDependenceModule.m
//  InDependence
//
//  Created by Yan Rabovik on 19.03.13.
//  Copyright (c) 2013 Yan Rabovik. All rights reserved.
//

#import "INDModule.h"
#import "INDInjector.h"
#import "INDUtils.h"

NSString *const INDBindedClassKey = @"INDBindedClassKey";

@implementation INDModule{
    NSMutableDictionary *_bindings;
}

#pragma mark - Init
-(id)init{
	self = [super init];
	if (nil == self) return nil;
    
	_bindings = [NSMutableDictionary new];
    
	return self;
}

#pragma mark - Bindings storage
-(id)classOrProtocolKey:(id)classOrProtocol{
    BOOL isClass = class_isMetaClass(object_getClass(classOrProtocol));
    if (isClass) {
        return classOrProtocol;
    }else{
        return NSStringFromProtocol(classOrProtocol);
    }
}

-(id)bindingForKey:(NSString *)key classOrProtocol:(id)classOrProtocol{
    return [[_bindings objectForKey:key]
            objectForKey:[self classOrProtocolKey:classOrProtocol]];
}

-(void)setBinding:(id)bindingEntry
           forKey:(NSString *)key
  classOrProtocol:(id)classOrProtocol
{
    INDAssert(nil == [self.injector bindingForKey:key classOrProtocol:classOrProtocol],
              @"Duplicate binding '%@' for %@",
              INDBindedClassKey,
              [INDUtils key:classOrProtocol]);
    
    NSMutableDictionary *keyDict = [_bindings objectForKey:key];
    if (nil == keyDict){
        keyDict = [NSMutableDictionary new];
        [_bindings setObject:keyDict forKey:key];
    }
    [keyDict setObject:bindingEntry forKey:[self classOrProtocolKey:classOrProtocol]];
}

#pragma mark - Class bindings
-(void)bindClass:(Class)aClass toClass:(Class)toClass{
    [self bindClass:aClass to:toClass];
}

-(void)bindClass:(Class)aClass toProtocol:(Protocol *)toProtocol{
    [self bindClass:aClass to:toProtocol];
}

-(void)bindClass:(Class)aClass to:(id)classOrProtocol{
    [self setBinding:aClass
              forKey:INDBindedClassKey
     classOrProtocol:classOrProtocol];
}

#pragma mark - For overriding
-(void)configure{
    
}


@end
