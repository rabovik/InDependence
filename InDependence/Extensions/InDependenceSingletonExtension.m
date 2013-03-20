//
//  RSInjectorSingletonExtension.m
//  InDependence
//
//  Created by Yan Rabovik on 27.02.13.
//  Copyright (c) 2013 Yan Rabovik. All rights reserved.
//

#import "InDependenceInjector.h"
#import "InDependenceSingletonExtension.h"
#import "InDependenceUtils.h"


@implementation InDependenceSingletonExtension{
    NSMutableDictionary *_singletonsStorage;
}

-(id)init{
	self = [super init];
	if (nil == self) return nil;
    
	_singletonsStorage = [NSMutableDictionary new];
    
	return self;
}

-(id)createObjectOfClass:(Class)resolvedClass
                 session:(InDependenceSession*)session
               ancestors:(NSArray *)ancestors
                    info:(NSDictionary *)info
{
    
    if ([InDependenceUtils
         isInstructionRequiredForClass:resolvedClass
         selector:@selector(independence_register_singleton)])
    {
        NSString *key = [InDependenceUtils key:resolvedClass];
        id object = [_singletonsStorage objectForKey:key];
        if (!object) {
            object = [super createObjectOfClass:resolvedClass
                                        session:session
                                      ancestors:ancestors
                                           info:info];
            [_singletonsStorage setObject:object forKey:key];
        }
        
        return object;
    }
        
    return [super createObjectOfClass:resolvedClass
                              session:session
                            ancestors:ancestors
                                 info:info];
}

@end
