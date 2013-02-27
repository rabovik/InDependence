//
//  RSInjectorUtils.m
//  InDependence
//
//  Created by Yan Rabovik on 27.02.13.
//  Copyright (c) 2013 Yan Rabovik. All rights reserved.
//

#import "RSInjectorUtils.h"

static NSString *const RSInjectorException = @"RSInjectorException";

@implementation RSInjectorUtils

+(NSSet *)requirementsForClass:(Class)klass selector:(SEL)selector{
    if ([klass respondsToSelector:selector]){
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        return [klass performSelector:selector];
#pragma clang diagnostic pop
    }
    return nil;
}

+(NSSet *)collectRequirementsForClass:(Class)klass requirements:(NSSet *)requirements selector:(SEL)selector{
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

+(RSInjectorPropertyInfo)classOrProtocolForProperty:(objc_property_t)property{
    NSString *attributes = [NSString stringWithCString: property_getAttributes(property) encoding: NSASCIIStringEncoding];
    NSString *propertyName = [NSString stringWithCString:property_getName(property) encoding:NSASCIIStringEncoding];
    
    NSRange startRange = [attributes rangeOfString:@"T@\""];
    if (startRange.location == NSNotFound) {
        @throw [NSException exceptionWithName:RSInjectorException reason:[NSString stringWithFormat:@"Unable to determine class type for property declaration: '%@'", propertyName] userInfo:nil];
    }
    
    NSString *startOfClassName = [attributes substringFromIndex:startRange.length];
    NSRange endRange = [startOfClassName rangeOfString:@"\""];
    
    if (endRange.location == NSNotFound) {
        @throw [NSException exceptionWithName:RSInjectorException reason:[NSString stringWithFormat:@"Unable to determine class type for property declaration: '%@'", propertyName] userInfo:nil];
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
        @throw [NSException exceptionWithName:RSInjectorException reason:[NSString stringWithFormat:@"Unable get class for name '%@' for property '%@'", classOrProtocolName, propertyName] userInfo:nil];
    }
    propertyInfo.value = (__bridge void *)(classOrProtocol);
    
    return propertyInfo;
}

+(objc_property_t)getProperty:(NSString *)propertyName fromClass:(Class)klass{
    objc_property_t property = class_getProperty(klass, (const char *)[propertyName UTF8String]);
    if (property == NULL) {
        @throw [NSException exceptionWithName:RSInjectorException reason:[NSString stringWithFormat:@"Unable to find property declaration: '%@'", propertyName] userInfo:nil];
    }
    return property;
}
@end
