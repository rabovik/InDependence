//
//  RSInjectorSingletonExtension.m
//  InDependence
//
//  Created by Yan Rabovik on 27.02.13.
//  Copyright (c) 2013 Yan Rabovik. All rights reserved.
//

#import "InDependenceSingletonExtension.h"
#import "InDependenceBindingEntry.h"

static NSString *const InDependenceSingletonStorageKey = @"InDependenceSingletonStorageKey";

@implementation InDependenceSingletonExtension

-(id)createObjectOfClass:(Class)resolvedClass
                injector:(InDependenceInjector*)injector
                 session:(InDependenceSession*)session
               ancestors:(NSArray *)ancestors
                    info:(NSDictionary *)info
{
    
    if ([InDependenceUtils requiredInstructionForClass:resolvedClass selector:@selector(independence_register_singleton)]) {
        
        InDependenceBindingEntry *binding = [injector getBinding:resolvedClass];
        
        id object = [binding objectForKey:InDependenceSingletonStorageKey];
        if (!object) {
            object = [super createObjectOfClass:resolvedClass
                                       injector:injector
                                        session:session
                                      ancestors:ancestors
                                           info:info];
            [binding setObject:object forKey:InDependenceSingletonStorageKey];
        }
        
        return object;
    }
        
    return [super createObjectOfClass:resolvedClass
                             injector:injector
                              session:session
                            ancestors:ancestors
                                 info:info];
}

@end
