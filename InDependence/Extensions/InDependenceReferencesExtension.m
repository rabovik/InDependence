//
//  InDependenceAncestorsExtension.m
//  InDependence
//
//  Created by Yan Rabovik on 28.02.13.
//  Copyright (c) 2013 Yan Rabovik. All rights reserved.
//

#import "InDependenceReferencesExtension.h"
#import "InDependenceUtils.h"

@implementation InDependenceReferencesExtension

-(id)createObjectOfClass:(Class)resolvedClass
                injector:(InDependenceInjector *)injector
                 session:(InDependenceSession *)session
               ancestors:(NSArray *)ancestors
                    info:(NSDictionary *)info
{
    id createdObject = [super createObjectOfClass:resolvedClass
                                         injector:injector session:session
                                        ancestors:ancestors
                                             info:info];
    NSSet *properties = [InDependenceUtils
                         requirementsSetForClass:resolvedClass
                         selector:@selector(independence_references)];
    if (properties) {
        NSMutableDictionary *propertiesDictionary =
            [NSMutableDictionary dictionaryWithCapacity:properties.count];
        for (NSString *propertyName in properties) {
            objc_property_t property = [InDependenceUtils getProperty:propertyName
                                                            fromClass:resolvedClass];
            if (![InDependenceUtils propertyIsWeak:property]) {
                @throw [NSException
                        exceptionWithName:InDependenceException
                        reason:[NSString
                                stringWithFormat:@"Required ancestor property '%@' of class '%@' must be weak",
                                propertyName,
                                [InDependenceUtils key:resolvedClass]]
                        userInfo:nil];
            }
            
            InDependencePropertyInfo propertyInfo =
                [InDependenceUtils classOrProtocolForProperty:property];
            id desiredClassOrProtocol = (__bridge id)(propertyInfo.value);
            
            id resolvedAncestor = nil;
                        
            for (int i = ancestors.count - 1; i>=0; --i) {
                id ancestor = [ancestors objectAtIndex:i];
                if (propertyInfo.type == InDependenceInterfaceTypeClass) {
                    if ([ancestor isKindOfClass:desiredClassOrProtocol]) {
                        resolvedAncestor = ancestor;
                        break;
                    }
                }else{
                    if ([ancestor conformsToProtocol:desiredClassOrProtocol]) {
                        resolvedAncestor = ancestor;
                        break;
                    }
                }

            }
                        
            if (nil == resolvedAncestor) {
                resolvedAncestor = [NSNull null];
            }
            
            [propertiesDictionary setObject:resolvedAncestor forKey:propertyName];
        }
        [createdObject setValuesForKeysWithDictionary:propertiesDictionary];
    }
    
    return createdObject;
}

@end
