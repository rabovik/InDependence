//
//  RSInjectorSingletonExtension.m
//  InDependence
//
//  Created by Yan Rabovik on 27.02.13.
//  Copyright (c) 2013 Yan Rabovik. All rights reserved.
//

#import "InDependenceInjector.h"
#import "InDependenceSingletonExtension.h"
#import "InDependenceUtils.h"

static NSString *const InDependenceSingletonStorageKey =
    @"InDependenceSingletonStorageKey";

@implementation InDependenceSingletonExtension

-(id)createObjectOfClass:(Class)resolvedClass
                injector:(InDependenceInjector*)injector
                 session:(InDependenceSession*)session
               ancestors:(NSArray *)ancestors
                    info:(NSDictionary *)info
{
    
    if ([InDependenceUtils
         isInstructionRequiredForClass:resolvedClass
         selector:@selector(independence_register_singleton)])
    {
        id object = [injector objectForKey:InDependenceSingletonStorageKey
                           classOrProtocol:resolvedClass];
        if (!object) {
            object = [super createObjectOfClass:resolvedClass
                                       injector:injector
                                        session:session
                                      ancestors:ancestors
                                           info:info];
            [injector setObject:object
                         forKey:InDependenceSingletonStorageKey
                classOrProtocol:resolvedClass];
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
