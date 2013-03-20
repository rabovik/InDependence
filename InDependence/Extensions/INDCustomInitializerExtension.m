//
//  RSInjectorCustomInitializerExtension.m
//  InDependence
//
//  Created by Yan Rabovik on 28.02.13.
//  Copyright (c) 2013 Yan Rabovik. All rights reserved.
//

#import "INDCustomInitializerExtension.h"
#import "INDInjector.h"
#import "INDUtils.h"

static NSString *const INDInfoArgumentsKey = @"INDInfoArgumentsKey";

@implementation INDInjector (CustomInitializer)

-(id)getObjectWithArgs:(id)classOrProtocol, ...{
    va_list va_arguments;
    va_start(va_arguments, classOrProtocol);
    NSArray *arguments = [INDUtils transformVariadicArgsToArray:va_arguments];
    id object = [self getObject:classOrProtocol
                        session:nil
                      ancestors:nil
                           info:@{INDInfoArgumentsKey: arguments}];
    va_end(va_arguments);
    return object;
}

@end

@implementation INDCustomInitializerExtension

-(id)createObjectOfClass:(Class)resolvedClass
                 session:(INDSession *)session
               ancestors:(NSArray *)ancestors
                    info:(NSDictionary *)info
{    
    NSString *customInitializerName = [INDUtils
                                       requirementObjectForClass:resolvedClass
                                       selector:@selector(independence_initializer)];
    if (customInitializerName) {
        NSArray *resolvedArguments = [info objectForKey:INDInfoArgumentsKey];
        if (!resolvedArguments) {
            resolvedArguments = [INDUtils
                                 requirementObjectForClass:resolvedClass
                                 selector:@selector(independence_initializer_arguments)];
        }
        return [INDUtils
                buildObjectWithInitializer:resolvedClass
                initializer:NSSelectorFromString(customInitializerName)
                arguments:resolvedArguments];
    }
    
    return [super
            createObjectOfClass:resolvedClass
            session:session
            ancestors:ancestors
            info:info];
}

@end
