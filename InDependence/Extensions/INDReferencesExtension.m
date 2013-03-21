//
//  InDependenceAncestorsExtension.m
//  InDependence
//
//  Created by Yan Rabovik on 28.02.13.
//  Copyright (c) 2013 Yan Rabovik. All rights reserved.
//

#import "INDReferencesExtension.h"
#import "INDUtils.h"
#import "INDSession.h"
#import "NSObject+INDObjectsTree.h"

@implementation INDReferencesExtension

-(void)notifyObjectsInSession:(INDSession *)session{
    NSArray *objects = [session allObjects];
    for (NSObject *object in objects) {
        NSSet *properties = [INDUtils
                             requirementsSetForClass:[object class]
                             selector:@selector(independence_references)];
        [self injectReferences:properties toObject:object];
    }
    
    [super notifyObjectsInSession:session];
}

-(void)injectReferences:(NSSet *)properties toObject:(NSObject *)object{
    if (nil == properties) return;
    for (NSString *propertyName in properties) {
        objc_property_t property = [INDUtils getProperty:propertyName
                                               fromClass:[object class]];
        if (![INDUtils propertyIsWeak:property]) {
            @throw [NSException
                    exceptionWithName:INDException
                    reason:[NSString
                            stringWithFormat:@"Required reference '%@' of class '%@' must be weak",
                            propertyName,
                            [INDUtils key:[object class]]]
                    userInfo:nil];
        }
        id desiredClassOrProtocol = [INDUtils
                                     classOrProtocolForProperty:property];
        id resolvedReference = [self reference:desiredClassOrProtocol
                               inTreeforObject:object];
        [object setValue:resolvedReference forKey:propertyName];
    }
}

-(id)reference:(id)classOrProtocol inTreeforObject:(NSObject *)object{
    id parent = object.ind_parent;
    if (parent) {
        return [self
                reference:classOrProtocol
                inObjectAndRelatives:parent
                excludeChild:object];
    }
    return nil;
}

-(id)reference:(id)classOrProtocol
     inObjectAndRelatives:(NSObject *)object
     excludeChild:(id)excludedChild
{
    if ([self object:object conformsClassOrProtocol:classOrProtocol]) {
        // object itself
        return object;
    }
    NSSet *childs = object.ind_childs;
    for (NSObject *child in childs) {
        if ([child isEqual:excludedChild]) {
            continue;
        }
        if ([self object:child conformsClassOrProtocol:classOrProtocol]) {
            // child
            return child;
        }
    }
    for (NSObject *child in childs) {
        id inChild = [self
                      reference:classOrProtocol
                      inObjectAndChilds:child];
        if (inChild) {
            // found in child
            return inChild;
        }
    }
    id parent = object.ind_parent;
    if (parent) {
        // in parent
        return [self
                reference:classOrProtocol
                inObjectAndRelatives:parent
                excludeChild:object];
    }
    return nil;
}

-(id)reference:(id)classOrProtocol inObjectAndChilds:(NSObject *)object{
    NSSet *childs = object.ind_childs;
    for (NSObject *child in childs) {
        if ([self object:child conformsClassOrProtocol:classOrProtocol]) {
            // child
            return child;
        }
        id inChild = [self
                      reference:classOrProtocol
                      inObjectAndChilds:child];
        if (inChild) {
            // found in child
            return inChild;
        }
    }
    return nil;
}

-(BOOL)object:(id)object conformsClassOrProtocol:(id)classOrProtocol{
    BOOL isClass = class_isMetaClass(object_getClass(classOrProtocol));
    if (isClass) {
        return [object isKindOfClass:classOrProtocol];
    }else{
        return [object conformsToProtocol:classOrProtocol];
    }
    return NO;
}

@end
