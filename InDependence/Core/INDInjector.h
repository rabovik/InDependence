//
//  RSInjector.h
//  InDependence
//
//  Created by Yan Rabovik on 26.02.13.
//  Copyright (c) 2013 Yan Rabovik. All rights reserved.
//

#import <Foundation/Foundation.h>

@class
    INDExtension,
    INDSession,
    INDModule;

@interface INDInjector : NSObject

#pragma mark - Extensions
+(void)registerExtensionClass:(Class)extensionClass;
+(void)unRegisterExtensionClass:(Class)extensionClass;

#pragma mark - Initializing
+(INDInjector *)sharedInjector;
+(void)setSharedInjector:(INDInjector *)injector;

#pragma mark - Object Factory
-(id)getObject:(id)classOrProtocol parent:(id)parent;
-(id)getObject:(id)classOrProtocol
       session:(INDSession *)session
        parent:(id)parent
          info:(NSDictionary *)info;

#pragma mark - Modules
-(void)addModule:(INDModule *)module;
-(void)removeModule:(INDModule *)module;
-(void)removeModuleOfClass:(Class)moduleClass;

#pragma mark - Bindings
-(id)bindingForKey:(NSString *)key classOrProtocol:(id)classOrProtocol;

@end
