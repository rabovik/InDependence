//
//  RSInjectorSession.m
//  InDependence
//
//  Created by Yan Rabovik on 27.02.13.
//  Copyright (c) 2013 Yan Rabovik. All rights reserved.
//

#import "InDependenceSession.h"

@implementation InDependenceSession{
    NSMutableArray *_instantiatedObjects;
}

-(id)init{
	self = [super init];
	if (nil == self) return nil;
    
	_instantiatedObjects = [NSMutableArray new];
    
	return self;
}


-(void)registerInstantiatedObject:(id)object{
    [_instantiatedObjects addObject:object];
}

-(void)notifyObjectsThatTheyAreReady{    
    for (id object in _instantiatedObjects) {
        SEL selector = @selector(awakeFromInjector);
        if([object respondsToSelector:selector]) {
            NSMethodSignature *signature = [object methodSignatureForSelector:selector];
            NSInvocation *invocation =
                [NSInvocation invocationWithMethodSignature:signature];
            [invocation setTarget:object];
            [invocation setSelector:selector];
            [invocation invoke];
        }
    }
}



@end
