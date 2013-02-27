//
//  RSInjector.h
//  InDependence
//
//  Created by Yan Rabovik on 26.02.13.
//  Copyright (c) 2013 Yan Rabovik. All rights reserved.
//

#import <Foundation/Foundation.h>

@class RSInjectorBindingEntry;

@interface RSInjector : NSObject

+(id)sharedInjector;

-(id)getObject:(id)klass;

-(RSInjectorBindingEntry *)getBinding:(id)classOrProtocol;

-(void)bindClass:(Class)aClass toClass:(Class)toClass;

@end
