//
//  RSInjectorSession.m
//  InDependence
//
//  Created by Yan Rabovik on 27.02.13.
//  Copyright (c) 2013 Yan Rabovik. All rights reserved.
//

#import "RSInjectorSession.h"

@implementation RSInjectorSession{
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


@end
