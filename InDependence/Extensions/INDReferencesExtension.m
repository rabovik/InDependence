//
//  InDependenceAncestorsExtension.m
//  InDependence
//
//  Created by Yan Rabovik on 28.02.13.
//  Copyright (c) 2013 Yan Rabovik. All rights reserved.
//

#import "INDReferencesExtension.h"
#import "INDUtils.h"

@implementation INDReferencesExtension

-(id)createObjectOfClass:(Class)resolvedClass
                 session:(INDSession *)session
                  parent:(id)parent
                    info:(NSDictionary *)info
{
    id createdObject = [super createObjectOfClass:resolvedClass
                                          session:session
                                           parent:parent
                                             info:info];
    /*
    NSSet *properties = [INDUtils
                         requirementsSetForClass:resolvedClass
                         selector:@selector(independence_references)];
    if (properties) {
        for (NSString *propertyName in properties) {
            objc_property_t property = [INDUtils getProperty:propertyName
                                                            fromClass:resolvedClass];
            if (![INDUtils propertyIsWeak:property]) {
                @throw [NSException
                        exceptionWithName:INDException
                        reason:[NSString
                                stringWithFormat:@"Required reference '%@' of class '%@' must be weak",
                                propertyName,
                                [INDUtils key:resolvedClass]]
                        userInfo:nil];
            }
            
            INDPropertyInfo propertyInfo =
                [INDUtils classOrProtocolForProperty:property];
            
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
     */
    
    return createdObject;
}

-(BOOL)object:(id)object conformsToPropertyInfo:(INDPropertyInfo)propertyInfo{
    id desiredClassOrProtocol = (__bridge id)(propertyInfo.value);
    if (propertyInfo.type == INDInterfaceTypeClass) {
        return [object isKindOfClass:desiredClassOrProtocol];
    }else{
        return [object conformsToProtocol:desiredClassOrProtocol];
    }
    return NO;
}

@end
