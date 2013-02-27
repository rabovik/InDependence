//
//  RSInjectorUtils.m
//  InDependence
//
//  Created by Yan Rabovik on 27.02.13.
//  Copyright (c) 2013 Yan Rabovik. All rights reserved.
//

#import "RSInjectorUtils.h"
#import <objc/runtime.h>

@implementation RSInjectorUtils

+(NSSet *)collectRequirementsForClass:(id)klass requirements:(NSSet *)requirements selector:(SEL)selector{
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

@end
