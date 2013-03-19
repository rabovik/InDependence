//
//  InDependenceModule.m
//  InDependence
//
//  Created by Yan Rabovik on 19.03.13.
//  Copyright (c) 2013 Yan Rabovik. All rights reserved.
//

#import "InDependenceModule.h"
#import "InDependenceUtils.h"

NSString *const InDependenceBindedClassKey = @"InDependenceBindedClassKey";

@interface InDependenceBindedClassEntry : NSObject
@property (nonatomic,unsafe_unretained) Class bindedClass;
@end

@implementation InDependenceBindedClassEntry
@end

@implementation InDependenceModule{
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
-(id)bindingForKey:(NSString *)key classOrProtocol:(id)classOrProtocol{
    key = [NSString stringWithFormat:@"%@_%@",
           key,
           [InDependenceUtils key:classOrProtocol]];
    return [_bindings objectForKey:key];
}

-(void)setBinding:(id)bindingEntry
           forKey:(NSString *)key
  classOrProtocol:(id)classOrProtocol
{
    // assert binding is unique
    key = [NSString stringWithFormat:@"%@_%@",
           key,
           [InDependenceUtils key:classOrProtocol]];
    [_bindings setObject:bindingEntry forKey:key];
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
              forKey:InDependenceBindedClassKey
     classOrProtocol:classOrProtocol];
}

#pragma mark - For overriding
-(void)configure{
    
}


@end
