//
//  RSInjectorSingletonExtension.m
//  InDependence
//
//  Created by Yan Rabovik on 27.02.13.
//  Copyright (c) 2013 Yan Rabovik. All rights reserved.
//

#import "InDependenceSingletonExtension.h"
#import "InDependenceBindingEntry.h"

static NSString *const RSInjectorBindingSingletonStorageKey = @"RSInjectorBindingSingletonStorageKey";

@implementation InDependenceSingletonExtension

-(id)createObjectOfClass:(Class)resolvedClass injector:(InDependenceInjector *)injector session:(InDependenceSession *)session ancestors:(NSArray *)ancestors{
    
    if ([InDependenceUtils requiredInstructionForClass:resolvedClass selector:@selector(rs_register_singleton)]) {
        
        InDependenceBindingEntry *binding = [injector getBinding:resolvedClass];
        
        id object = [binding objectForKey:RSInjectorBindingSingletonStorageKey];
        if (!object) {
            object = [super createObjectOfClass:resolvedClass injector:injector session:session ancestors:ancestors];
            [binding setObject:object forKey:RSInjectorBindingSingletonStorageKey];
        }
        
        return object;
    }
        
    return [super createObjectOfClass:resolvedClass injector:injector session:session ancestors:ancestors];
}

@end
