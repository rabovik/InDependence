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
static NSString *const INDBindedArgumentsKey = @"INDBindedArgumentsKey";

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
    NSString *key = [NSString stringWithFormat:@"%@%u",INDBindedArgumentsKey,index];
    if (nil == argument) {
        argument = [NSNull null];
    }
    [self setBinding:argument
              forKey:key
     classOrProtocol:toClass];
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
        SEL initializer = NSSelectorFromString(customInitializerName);
        // arguments in getObject:parent:arguments:
        NSArray *resolvedArguments = [info objectForKey:INDInfoArgumentsKey];
        if (!resolvedArguments) {
            // arguments in initializer
            NSArray *initializerArguments =
                [INDUtils
                 requirementObjectForClass:resolvedClass
                 selector:@selector(independence_initializer_arguments)];
            // binded arguments
            NSMutableArray *filteredArguments =
                [NSMutableArray arrayWithArray:initializerArguments];
            NSMethodSignature *signature =
                [resolvedClass instanceMethodSignatureForSelector:initializer];
            while (filteredArguments.count < signature.numberOfArguments) {
                [filteredArguments addObject:[NSNull null]];
            }
            for (NSUInteger i = 0; i < signature.numberOfArguments; ++i) {
                NSString *key = [NSString stringWithFormat:@"%@%u",
                                 INDBindedArgumentsKey,
                                 i];
                id argument = [self.injector bindingForKey:key
                                           classOrProtocol:resolvedClass];
                if (nil != argument) {
                    [filteredArguments replaceObjectAtIndex:i withObject:argument];
                }
            }
            resolvedArguments = filteredArguments;
        }
        return [INDUtils
                buildObjectWithInitializer:resolvedClass
                initializer:initializer
                arguments:resolvedArguments];
    }
    
    return [super
            createObjectOfClass:resolvedClass
            session:session
            parent:parent
            info:info];
}

@end
