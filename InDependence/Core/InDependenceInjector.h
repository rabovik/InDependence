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
    InDependenceSession,
    InDependenceModule;

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

#pragma mark - Modules
-(void)addModule:(InDependenceModule *)module;
-(void)removeModule:(InDependenceModule *)module;
-(void)removeModuleOfClass:(Class)moduleClass;

#pragma mark - Bindings
-(id)bindingForKey:(NSString *)key classOrProtocol:(id)classOrProtocol;

@end
