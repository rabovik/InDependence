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
                                         injector:injector
                                          session:session
                                        ancestors:ancestors
                                             info:info];
    NSSet *properties = [InDependenceUtils
                         requirementsSetForClass:resolvedClass
                         selector:@selector(independence_references)];
    if (properties) {
        for (NSString *propertyName in properties) {
            objc_property_t property = [InDependenceUtils getProperty:propertyName
                                                            fromClass:resolvedClass];
            if (![InDependenceUtils propertyIsWeak:property]) {
                @throw [NSException
                        exceptionWithName:InDependenceException
                        reason:[NSString
                                stringWithFormat:@"Required reference '%@' of class '%@' must be weak",
                                propertyName,
                                [InDependenceUtils key:resolvedClass]]
                        userInfo:nil];
            }
            
            InDependencePropertyInfo propertyInfo =
                [InDependenceUtils classOrProtocolForProperty:property];
            
            id resolvedAncestor = nil;
                        
            for (int i = ancestors.count - 1; i>=0; --i) {
                id ancestor = [ancestors objectAtIndex:i];
                if ([self
                     object:ancestor
                     conformsToPropertyInfo:propertyInfo])
                {
                    resolvedAncestor = ancestor;
                    break;
                }
            }
            
            [createdObject setValue:resolvedAncestor forKey:propertyName];
        }
    }
    
    return createdObject;
}

-(BOOL)object:(id)object conformsToPropertyInfo:(InDependencePropertyInfo)propertyInfo{
    id desiredClassOrProtocol = (__bridge id)(propertyInfo.value);
    if (propertyInfo.type == InDependenceInterfaceTypeClass) {
        return [object isKindOfClass:desiredClassOrProtocol];
    }else{
        return [object conformsToProtocol:desiredClassOrProtocol];
    }
    return NO;
}

@end
