//
//  RSInjectorCustomInitializerExtension.m
//  InDependence
//
//  Created by Yan Rabovik on 28.02.13.
//  Copyright (c) 2013 Yan Rabovik. All rights reserved.
//

#import "InDependenceCustomInitializerExtension.h"
#import "InDependenceInjector.h"
#import "InDependenceUtils.h"

static NSString *const InDependenceInfoArgumentsKey = @"InDependenceInfoArgumentsKey";

@implementation InDependenceInjector (CustomInitializer)

-(id)getObjectWithArgs:(id)classOrProtocol, ...{
    va_list va_arguments;
    va_start(va_arguments, classOrProtocol);
    NSArray *arguments = [InDependenceUtils transformVariadicArgsToArray:va_arguments];
    id object = [self getObject:classOrProtocol
                        session:nil
                      ancestors:nil
                           info:@{InDependenceInfoArgumentsKey: arguments}];
    va_end(va_arguments);
    return object;
}

@end

@implementation InDependenceCustomInitializerExtension

-(id)createObjectOfClass:(Class)resolvedClass
                injector:(InDependenceInjector *)injector
                 session:(InDependenceSession *)session
               ancestors:(NSArray *)ancestors
                    info:(NSDictionary *)info{
    
    NSString *customInitializerName =
        [InDependenceUtils requirementObjectForClass:resolvedClass
                                            selector:@selector(independence_initializer)];
    if (customInitializerName) {
        NSArray *resolvedArguments = [info objectForKey:InDependenceInfoArgumentsKey];
        if (!resolvedArguments) {
            resolvedArguments = [InDependenceUtils
                                    requirementObjectForClass:resolvedClass
                                 selector:@selector(independence_initializer_arguments)];
        }
        return [InDependenceUtils
                buildObjectWithInitializer:resolvedClass
                initializer:NSSelectorFromString(customInitializerName)
                arguments:resolvedArguments];
    }
    
    return [super
            createObjectOfClass:resolvedClass
            injector:injector
            session:session
            ancestors:ancestors
            info:info];
}

@end
