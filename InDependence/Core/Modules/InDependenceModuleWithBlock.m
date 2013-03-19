//
//  InDependenceModuleWithBlock.m
//  InDependence
//
//  Created by Yan Rabovik on 19.03.13.
//  Copyright (c) 2013 Yan Rabovik. All rights reserved.
//

#import "InDependenceModuleWithBlock.h"

@implementation InDependenceModuleWithBlock{
    InDependenceModuleBlock _block;
}

#pragma mark - Initialization
-(id)initWithBlock:(InDependenceModuleBlock)block{
	self = [super init];
	if (nil == self) return nil;
    
	_block = [block copy];
    
	return self;
}

#pragma mark - Configure
-(void)configure{
    _block(self);
}


@end
