//
//  NSObject+INDObjectsTree.m
//  InDependence
//
//  Created by Yan Rabovik on 21.03.13.
//  Copyright (c) 2013 Yan Rabovik. All rights reserved.
//

#import "NSObject+INDObjectsTree.h"
#import <objc/runtime.h>
#import "INDWeakCollection.h"

static char parentKey;
static char childsKey;

@implementation NSObject (INDObjectsTree)

#pragma mark - Parent
-(void)setInd_parent:(id)ind_parent{
    INDWeakObjectContainer *parentContainer = [INDWeakObjectContainer new];
    parentContainer.object = ind_parent;
    objc_setAssociatedObject(self,
                             &parentKey,
                             parentContainer,
                             OBJC_ASSOCIATION_RETAIN);
}

-(id)ind_parent{
    INDWeakObjectContainer *parentContainer = objc_getAssociatedObject(self, &parentKey);
    if (nil == parentContainer) return nil;
    id parent = parentContainer.object;
    return parent;
}

#pragma mark - Childs
-(INDWeakCollection *)ind_childsCollection{
    @synchronized(self){
        INDWeakCollection *childsCollection = objc_getAssociatedObject(self, &childsKey);
        if (nil == childsCollection) {
            childsCollection = [INDWeakCollection new];
            objc_setAssociatedObject(self,
                                     &childsKey,
                                     childsCollection,
                                     OBJC_ASSOCIATION_RETAIN);
        }
        return childsCollection;
    }
}

-(void)ind_addChild:(NSObject *)child{
    child.ind_parent = self;
    [[self ind_childsCollection] addObject:child];
}

-(NSSet *)ind_childs{
    return [[self ind_childsCollection] allObjects];
}

@end
