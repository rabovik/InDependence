//
//  RSInjectorUtils.m
//  InDependence
//
//  Created by Yan Rabovik on 27.02.13.
//  Copyright (c) 2013 Yan Rabovik. All rights reserved.
//

#import "InDependenceUtils.h"

NSString *const InDependenceException = @"InDependenceException";

@implementation InDependenceUtils

+(NSString *)key:(id)classOrProtocol{
    NSString *key = nil;
    BOOL isClass = class_isMetaClass(object_getClass(classOrProtocol));
    if (isClass) {
        key = NSStringFromClass(classOrProtocol);
    } else {
        key = [NSString stringWithFormat:@"<%@>", NSStringFromProtocol(classOrProtocol)];
    }
    return key;
}


+(BOOL)isInstructionRequiredForClass:(Class)klass selector:(SEL)selector{
    if ([klass respondsToSelector:selector]) {
        NSMethodSignature *signature = [klass methodSignatureForSelector:selector];
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
        [invocation setTarget:klass];
        [invocation setSelector:selector];
        [invocation invoke];
        BOOL returnValue;
        [invocation getReturnValue:&returnValue];
        if (returnValue) {
            return YES;
        }
    }
    return NO;
}

+(id)requirementObjectForClass:(Class)klass selector:(SEL)selector{
    if ([klass respondsToSelector:selector]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        return [klass performSelector:selector];
#pragma clang diagnostic pop
    }
    return nil;
}

+(NSSet *)requirementsSetForClass:(Class)klass selector:(SEL)selector{
    return [self requirementObjectForClass:klass selector:selector];
}

+(NSSet *)unionRequirementsSetForClass:(Class)klass withSet:(NSSet *)requirements selector:(SEL)selector{
    Class superClass = class_getSuperclass([klass class]);
    if([superClass respondsToSelector:selector]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        NSSet *parentsRequirements = [superClass performSelector:selector];
#pragma clang diagnostic pop
        NSMutableSet *dependencies = [NSMutableSet setWithSet:parentsRequirements];
        [dependencies unionSet:requirements];
        requirements = dependencies;
    }
    return requirements;
}

+(BOOL)propertyIsWeak:(objc_property_t)property{
    NSString *attributes = [NSString stringWithCString: property_getAttributes(property) encoding: NSASCIIStringEncoding];
    NSArray *components = [attributes componentsSeparatedByString:@","];
    for (NSString *component in components) {
        if ([component isEqualToString:@"W"]) {
            return YES;
        }
    }
    return NO;
}


+(RSInjectorPropertyInfo)classOrProtocolForProperty:(objc_property_t)property{
    NSString *attributes = [NSString stringWithCString: property_getAttributes(property) encoding: NSASCIIStringEncoding];
    NSString *propertyName = [NSString stringWithCString:property_getName(property) encoding:NSASCIIStringEncoding];
    
    NSRange startRange = [attributes rangeOfString:@"T@\""];
    if (startRange.location == NSNotFound) {
        @throw [NSException exceptionWithName:InDependenceException reason:[NSString stringWithFormat:@"Unable to determine class type for property declaration: '%@'", propertyName] userInfo:nil];
    }
    
    NSString *startOfClassName = [attributes substringFromIndex:startRange.length];
    NSRange endRange = [startOfClassName rangeOfString:@"\""];
    
    if (endRange.location == NSNotFound) {
        @throw [NSException exceptionWithName:InDependenceException reason:[NSString stringWithFormat:@"Unable to determine class type for property declaration: '%@'", propertyName] userInfo:nil];
    }
    
    NSString *classOrProtocolName = [startOfClassName substringToIndex:endRange.location];
    id classOrProtocol = nil;
    RSInjectorPropertyInfo propertyInfo;
    
    if ([classOrProtocolName hasPrefix:@"<"] && [classOrProtocolName hasSuffix:@">"]) {
        classOrProtocolName = [classOrProtocolName stringByReplacingOccurrencesOfString:@"<" withString:@""];
        classOrProtocolName = [classOrProtocolName stringByReplacingOccurrencesOfString:@">" withString:@""];
        classOrProtocol = objc_getProtocol([classOrProtocolName UTF8String]);
        propertyInfo.type = RSInjectorTypeProtocol;
    } else {
        classOrProtocol = NSClassFromString(classOrProtocolName);
        propertyInfo.type = RSInjectorTypeClass;
    }
    
    if(!classOrProtocol) {
        @throw [NSException exceptionWithName:InDependenceException reason:[NSString stringWithFormat:@"Unable get class for name '%@' for property '%@'", classOrProtocolName, propertyName] userInfo:nil];
    }
    propertyInfo.value = (__bridge void *)(classOrProtocol);
    
    return propertyInfo;
}

+(objc_property_t)getProperty:(NSString *)propertyName fromClass:(Class)klass{
    objc_property_t property = class_getProperty(klass, (const char *)[propertyName UTF8String]);
    if (property == NULL) {
        @throw [NSException exceptionWithName:InDependenceException reason:[NSString stringWithFormat:@"Unable to find property declaration: '%@'", propertyName] userInfo:nil];
    }
    return property;
}

+(id)buildObjectWithInitializer:(Class)klass initializer:(SEL)initializer arguments:(NSArray *)arguments{
    id instance = [klass alloc];
    NSMethodSignature *signature = [klass instanceMethodSignatureForSelector:initializer];
    if (signature) {
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
        [invocation setTarget:instance];
        [invocation setSelector:initializer];
        for (int i = 0; i < arguments.count; i++) {
            id argument = [arguments objectAtIndex:i];
            [invocation setArgument:&argument atIndex:i + 2];
        }
        [invocation invoke];
        [invocation getReturnValue:&instance];
        return instance;
    } else {
        instance = nil;
        @throw [NSException exceptionWithName:InDependenceException reason:[NSString stringWithFormat:@"Could not find initializer '%@' on %@", NSStringFromSelector(initializer), NSStringFromClass(klass)] userInfo:nil];
    }
    return nil;
}

+(NSArray*)transformVariadicArgsToArray:(va_list)va_arguments{
    NSMutableArray *arguments = [NSMutableArray array];
    id object;
    while ((object = va_arg( va_arguments, id ))) {
        [arguments addObject:object];
    }
    return arguments;
}

@end
