//
//  RSInjector.h
//  InDependence
//
//  Created by Yan Rabovik on 26.02.13.
//  Copyright (c) 2013 Yan Rabovik. All rights reserved.
//

#import <Foundation/Foundation.h>

@class InDependenceBindingEntry,InDependenceExtension,InDependenceSession;

@interface InDependenceInjector : NSObject

+(void)registerExtension:(InDependenceExtension *)extension;
+(void)registerExtensions:(InDependenceExtension *)first, ... NS_REQUIRES_NIL_TERMINATION;

+(id)sharedInjector;

-(id)getObject:(id)klass;
-(id)getObject:(id)classOrProtocol
       session:(InDependenceSession *)session
     ancestors:(NSArray *)ancestors
          info:(NSDictionary *)info;

-(InDependenceBindingEntry *)getBinding:(id)classOrProtocol;

-(void)bindClass:(Class)aClass toClass:(Class)toClass;

@end
