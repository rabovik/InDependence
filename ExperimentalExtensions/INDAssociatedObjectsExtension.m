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

#pragma mark - Module -
@implementation INDModule (AssociatedObjects)

-(void)attachObjectOfClass:(Class)attachedClass toClass:(Class)toClass{
    [[self ao_bindingsForClass:toClass] addObject:attachedClass];
}

-(NSMutableDictionary *)ao_bindings{
    static char key;
    NSMutableDictionary *dict = objc_getAssociatedObject(self, &key);
    if (nil == dict) {
        dict = [NSMutableDictionary dictionary];
        objc_setAssociatedObject(self, &key, dict, OBJC_ASSOCIATION_RETAIN);
    }
    return dict;
}

-(NSMutableArray *)ao_bindingsForClass:(Class)klass{
    NSMutableArray *array = [[self ao_bindings] objectForKey:klass];
    if (nil == array) {
        array = [NSMutableArray array];
        [[self ao_bindings] setObject:array forKey:(id)klass];
    }
    return array;
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
    NSArray *bindedClasses = [self bindedClassesForClassAndSuperClasses:[object class]];
    for (Class klass in bindedClasses) {
        id attachedObject = [self.injector getObject:klass
                                             session:session
                                              parent:object
                                                info:nil];
        [self addAssociatedObject:attachedObject toObject:object];
    }
}

-(NSArray *)bindedClassesForClassAndSuperClasses:(Class)klass{
    NSMutableArray *bindedClasses = [NSMutableArray array];
    Class currentClass = klass;
    while (currentClass) {
        [bindedClasses addObjectsFromArray:[self bindedClassesForClass:currentClass]];
        currentClass = class_getSuperclass(currentClass);
    }
    return bindedClasses;
}

-(NSArray *)bindedClassesForClass:(Class)klass{
    NSMutableArray *bindedClasses = [NSMutableArray array];
    for (INDModule *module in self.injector.modules) {
        [bindedClasses addObjectsFromArray:[module ao_bindingsForClass:klass]];
    }
    return bindedClasses;
}

-(void)addAssociatedObject:(id)attachedObject toObject:(id)parent{
    static char key;
    NSMutableArray *array = objc_getAssociatedObject(parent, &key);
    if (nil == array){
        array = [NSMutableArray array];
        objc_setAssociatedObject(parent, &key, array, OBJC_ASSOCIATION_RETAIN);
    }
    [array addObject:attachedObject];
}

@end
