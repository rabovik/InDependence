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
               ancestors:(NSArray *)ancestors
                    info:(NSDictionary *)info
{
    
    if ([INDUtils
         isInstructionRequiredForClass:resolvedClass
         selector:@selector(independence_register_singleton)])
    {
        NSString *key = [INDUtils key:resolvedClass];
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
