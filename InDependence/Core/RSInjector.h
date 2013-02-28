//
//  RSInjector.h
//  InDependence
//
//  Created by Yan Rabovik on 26.02.13.
//  Copyright (c) 2013 Yan Rabovik. All rights reserved.
//

#import <Foundation/Foundation.h>

@class RSInjectorBindingEntry,RSInjectorExtension;

@interface RSInjector : NSObject

+(void)registerExtension:(RSInjectorExtension *)extension;
+(void)registerExtensions:(RSInjectorExtension *)first, ... NS_REQUIRES_NIL_TERMINATION;

+(id)sharedInjector;

-(id)getObject:(id)klass;

-(RSInjectorBindingEntry *)getBinding:(id)classOrProtocol;

-(void)bindClass:(Class)aClass toClass:(Class)toClass;

@end
