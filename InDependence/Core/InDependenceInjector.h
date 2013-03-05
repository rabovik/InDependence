//
//  RSInjector.h
//  InDependence
//
//  Created by Yan Rabovik on 26.02.13.
//  Copyright (c) 2013 Yan Rabovik. All rights reserved.
//

#import <Foundation/Foundation.h>

@class
    InDependenceBindingEntry,
    InDependenceExtension,
    InDependenceSession;

@interface InDependenceInjector : NSObject

#pragma mark - Extensions
+(void)registerExtensionClass:(Class)extensionClass;

#pragma mark - Initializing
+(InDependenceInjector *)sharedInjector;
+(InDependenceInjector *)createInjector;
+(void)setSharedInjector:(InDependenceInjector *)injector;

#pragma mark - Object Factory
-(id)getObject:(id)classOrProtocol;
-(id)getObject:(id)classOrProtocol
       session:(InDependenceSession *)session
     ancestors:(NSArray *)ancestors
          info:(NSDictionary *)info;

#pragma mark - Storage
-(void)setObject:(id)object forKey:(NSString *)key classOrProtocol:(id)classOrProtocol;
-(id)objectForKey:(NSString *)key classOrProtocol:(id)classOrProtocol;

#pragma mark - Bindings
-(InDependenceBindingEntry *)getBinding:(id)classOrProtocol;
-(void)bindClass:(Class)aClass toClass:(Class)toClass;
-(void)bindClass:(Class)aClass toProtocol:(Protocol *)toProtocol;

@end
