//
//  RSInjectorUtils.m
//  InDependence
//
//  Created by Yan Rabovik on 27.02.13.
//  Copyright (c) 2013 Yan Rabovik. All rights reserved.
//

#import "INDUtils.h"

NSString *const INDException = @"INDException";

@implementation INDUtils{
}

#pragma mark - Class & protocol encoding
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

#pragma mark - Collect annotations
+(BOOL)isInstructionRequiredForClass:(Class)klass selector:(SEL)selector{
    if ([klass respondsToSelector:selector]) {
        NSMethodSignature *signature = [klass methodSignatureForSelector:selector];
        NSInvocation *invocation =
            [NSInvocation invocationWithMethodSignature:signature];
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

#pragma mark └ array
+(NSArray *)annotationsArrayForClass:(Class)klass selector:(SEL)selector{
    return [self requirementObjectForClass:klass selector:selector];
}
+(NSArray *)appendAnnotationsArrayForClass:(Class)klass
                                   toArray:(NSArray *)annotations
                                  selector:(SEL)selector
{
    Class superClass = class_getSuperclass([klass class]);
    if([superClass respondsToSelector:selector]){
        #pragma clang diagnostic push
        #pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        NSArray *parentsAnnotations = [superClass performSelector:selector];
        #pragma clang diagnostic pop
        NSMutableArray *mParentAnnotations = [NSMutableArray
                                              arrayWithArray:parentsAnnotations];
        [mParentAnnotations addObjectsFromArray:annotations];
        annotations = mParentAnnotations;
    }
    return annotations;
}

#pragma mark └ set
+(NSSet *)requirementsSetForClass:(Class)klass selector:(SEL)selector{
    return [self requirementObjectForClass:klass selector:selector];
}

+(NSSet *)unionRequirementsSetForClass:(Class)klass
                               withSet:(NSSet *)requirements
                              selector:(SEL)selector
{
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

#pragma mark - Other

+(BOOL)propertyIsWeak:(objc_property_t)property{
    NSString *attributes = [NSString stringWithCString: property_getAttributes(property)
                                              encoding: NSASCIIStringEncoding];
    NSArray *components = [attributes componentsSeparatedByString:@","];
    for (NSString *component in components) {
        if ([component isEqualToString:@"W"]) {
            return YES;
        }
    }
    return NO;
}


+(id)classOrProtocolForProperty:(objc_property_t)property{
    NSString *attributes = [NSString stringWithCString: property_getAttributes(property)
                                              encoding: NSASCIIStringEncoding];
    NSString *propertyName = [NSString stringWithCString:property_getName(property)
                                                encoding:NSASCIIStringEncoding];
    NSRange startRange = [attributes rangeOfString:@"T@\""];
    if (startRange.location == NSNotFound) {
        @throw [NSException
                exceptionWithName:INDException
                reason:[NSString
                        stringWithFormat:@"Unable to determine class type for property declaration: '%@'",
                        propertyName]
                userInfo:nil];
    }
    
    NSString *startOfClassName = [attributes substringFromIndex:startRange.length];
    NSRange endRange = [startOfClassName rangeOfString:@"\""];
    
    if (endRange.location == NSNotFound) {
        @throw [NSException
                exceptionWithName:INDException
                reason:[NSString
                        stringWithFormat:@"Unable to determine class type for property declaration: '%@'",
                        propertyName]
                userInfo:nil];
    }
    
    NSString *classOrProtocolName = [startOfClassName substringToIndex:endRange.location];
    id classOrProtocol = nil;
    
    if ([classOrProtocolName hasPrefix:@"<"] && [classOrProtocolName hasSuffix:@">"]) {
        classOrProtocolName = [classOrProtocolName
                               stringByReplacingOccurrencesOfString:@"<"
                               withString:@""];
        classOrProtocolName = [classOrProtocolName
                               stringByReplacingOccurrencesOfString:@">"
                               withString:@""];
        classOrProtocol = objc_getProtocol([classOrProtocolName UTF8String]);
    } else {
        classOrProtocol = NSClassFromString(classOrProtocolName);
    }
    
    if(!classOrProtocol) {
        @throw [NSException
                exceptionWithName:INDException
                reason:[NSString
                        stringWithFormat:@"Unable get class for name '%@' for property '%@'",
                        classOrProtocolName,
                        propertyName]
                userInfo:nil];
    }
    
    return classOrProtocol;
}

+(objc_property_t)getProperty:(NSString *)propertyName fromClass:(Class)klass{
    objc_property_t property =
        class_getProperty(klass, (const char *)[propertyName UTF8String]);
    if (property == NULL) {
        @throw [NSException
                exceptionWithName:INDException
                reason:[NSString
                        stringWithFormat:@"Unable to find property declaration: '%@'",
                        propertyName]
                userInfo:nil];
    }
    return property;
}

+(id)buildObjectWithInitializer:(Class)klass
                    initializer:(SEL)initializer
                      arguments:(NSArray *)arguments
{
    id instance = [klass alloc];
    NSMethodSignature *signature = [klass instanceMethodSignatureForSelector:initializer];
    if (signature) {
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
        [invocation setTarget:instance];
        [invocation setSelector:initializer];
        for (int i = 0; i < arguments.count; i++) {
            id argument = [arguments objectAtIndex:i];
            if (argument != [NSNull null]) {
                [invocation setArgument:&argument atIndex:i + 2];
            }
        }
        [invocation invoke];
        [invocation getReturnValue:&instance];
        return instance;
    } else {
        instance = nil;
        @throw [NSException
                exceptionWithName:INDException
                reason:[NSString
                        stringWithFormat:@"Could not find initializer '%@' on %@",
                        NSStringFromSelector(initializer),
                        NSStringFromClass(klass)]
                userInfo:nil];
    }
    return nil;
}

@end
