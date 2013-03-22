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
#import "INDModule.h"

static NSString *const INDInfoArgumentsKey = @"INDInfoArgumentsKey";


#pragma mark - Injector
#pragma mark -
@implementation INDInjector (CustomInitializer)

-(id)getObject:(id)classOrProtocol
        parent:(id)parent
     arguments:(id)firstArgument, ...NS_REQUIRES_NIL_TERMINATION
{
    va_list va_arguments;
    va_start(va_arguments, firstArgument);
    NSMutableArray *arguments = [NSMutableArray arrayWithObject:firstArgument];
    id argument;
    while ((argument = va_arg( va_arguments, id ))) {
        [arguments addObject:argument];
    }
    va_end(va_arguments);
    
    id object = [self getObject:classOrProtocol
                        session:nil
                         parent:parent
                           info:@{INDInfoArgumentsKey: arguments}];
    return object;
}

@end

#pragma mark - Module
#pragma mark -
@implementation INDModule (CustomInitializer)

-(void)bindArgument:(id)argument atIndex:(NSUInteger)index toClass:(Class)toClass{
    
}

@end

#pragma mark - Extension
#pragma mark -
@implementation INDCustomInitializerExtension

-(id)createObjectOfClass:(Class)resolvedClass
                 session:(INDSession *)session
                  parent:(id)parent
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
            parent:parent
            info:info];
}

@end
