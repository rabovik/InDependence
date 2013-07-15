//
//  INDAssociatedObjectsExtension.m
//  InDependence
//
//  Created by Yan Rabovik on 15.07.13.
//  Copyright (c) 2013 Yan Rabovik. All rights reserved.
//

#import "INDAssociatedObjectsExtension.h"
#import "INDInjector.h"
#import <objc/runtime.h>

static NSString *const INDAttachedAssociatedObjectKey = @"INDAttachedAssociatedObjectKey";

#pragma mark - Module -
@implementation INDModule (AssociatedObjects)

-(void)attachObjectOfClass:(Class)aClass toClass:(Class)toClass{
    [self attachObjectOfClass:aClass to:toClass];
}

-(void)attachObjectOfClass:(Class)aClass toProtocol:(Protocol *)toProtocol{
    [self attachObjectOfClass:aClass to:toProtocol];
}

-(void)attachObjectOfClass:(Class)aClass to:(id)classOrProtocol{
    [self setBinding:aClass
              forKey:INDAttachedAssociatedObjectKey
     classOrProtocol:classOrProtocol];
}

@end

#pragma mark - Extension -
@implementation INDAssociatedObjectsExtension
-(void)injectRequirements:(NSSet *)properties
                 toObject:(id)object
                  session:(INDSession*)session
                     info:(NSDictionary *)info
{
    [super injectRequirements:properties
                     toObject:object
                      session:session
                         info:info];
    Class bindedClass = [self.injector bindingForKey:INDAttachedAssociatedObjectKey
                                     classOrProtocol:[object class]];
    if (bindedClass) {
        id attachedObject = [self.injector getObject:bindedClass
                                             session:session
                                              parent:object
                                                info:nil];
        [self addAssociatedObject:attachedObject toObject:object];
    }
}

-(void)addAssociatedObject:(id)attachedObject toObject:(id)parent{
    static char key;
    @synchronized(parent){
        NSMutableArray *array = objc_getAssociatedObject(parent, &key);
        if (nil == array){
            array = [NSMutableArray array];
            objc_setAssociatedObject(parent, &key, array, OBJC_ASSOCIATION_RETAIN);
        }
        [array addObject:attachedObject];
    }
}

@end
