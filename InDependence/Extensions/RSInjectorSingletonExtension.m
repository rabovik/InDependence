//
//  RSInjectorSingletonExtension.m
//  InDependence
//
//  Created by Yan Rabovik on 27.02.13.
//  Copyright (c) 2013 Yan Rabovik. All rights reserved.
//

#import "RSInjectorSingletonExtension.h"

@implementation RSInjectorSingletonExtension

-(id)createObjectOfClass:(Class)resolvedClass injector:(RSInjector *)injector session:(RSInjectorSession *)session ancestors:(NSArray *)ancestors{
    
    SEL selector = @selector(rs_register_singleton);
    if ([resolvedClass respondsToSelector:selector]) {
        NSMethodSignature *signature = [resolvedClass methodSignatureForSelector:selector];
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
        [invocation setTarget:resolvedClass];
        [invocation setSelector:selector];
        [invocation invoke];
        BOOL returnValue;
        [invocation getReturnValue:&returnValue];
        if (returnValue) {
            NSLog(@"Class %@ wants to be a singleton!",resolvedClass);
        }else{
            NSLog(@"Class %@ DOES NOT want to be a singleton!",resolvedClass);
        }
    }
    
    return [super createObjectOfClass:resolvedClass injector:injector session:session ancestors:ancestors];
}

@end
