//
//  RSInjectorSingletonExtension.m
//  InDependence
//
//  Created by Yan Rabovik on 27.02.13.
//  Copyright (c) 2013 Yan Rabovik. All rights reserved.
//

#import "RSInjectorSingletonExtension.h"
#import "RSInjectorBindingEntry.h"

static NSString *const RSInjectorBindingSingletonStorageKey = @"RSInjectorBindingSingletonStorageKey";

@implementation RSInjectorSingletonExtension

-(id)createObjectOfClass:(Class)resolvedClass injector:(RSInjector *)injector session:(RSInjectorSession *)session ancestors:(NSArray *)ancestors{
    
    if ([RSInjectorUtils requiredInstructionForClass:resolvedClass selector:@selector(rs_register_singleton)]) {
        
        RSInjectorBindingEntry *binding = [injector getBinding:resolvedClass];
        
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
