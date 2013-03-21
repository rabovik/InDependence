//
//  RSInjectorSingletonExtension.m
//  InDependence
//
//  Created by Yan Rabovik on 27.02.13.
//  Copyright (c) 2013 Yan Rabovik. All rights reserved.
//

#import "INDInjector.h"
#import "INDSingletonExtension.h"
#import "INDUtils.h"
#import "NSObject+INDObjectsTree.h"


@implementation INDSingletonExtension{
    NSMutableDictionary *_singletonsStorage;
}

-(id)init{
	self = [super init];
	if (nil == self) return nil;
    
	_singletonsStorage = [NSMutableDictionary new];
    
	return self;
}

-(id)createObjectOfClass:(Class)resolvedClass
                 session:(INDSession*)session
                  parent:(id)parent
                    info:(NSDictionary *)info
{
    
    if ([INDUtils
         isInstructionRequiredForClass:resolvedClass
         selector:@selector(independence_register_singleton)])
    {
        NSString *key = [INDUtils key:resolvedClass];
        NSObject *object = [_singletonsStorage objectForKey:key];
        if (!object) {
            object = [super createObjectOfClass:resolvedClass
                                        session:session
                                         parent:parent
                                           info:info];
            [_singletonsStorage setObject:object forKey:key];
            object.ind_parent = self.injector;
        }
        
        return object;
    }
        
    return [super createObjectOfClass:resolvedClass
                              session:session
                               parent:parent
                                 info:info];
}

@end
