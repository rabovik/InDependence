//
//  Ford.m
//  InDependence
//
//  Created by Yan Rabovik on 27.02.13.
//  Copyright (c) 2013 Yan Rabovik. All rights reserved.
//

#import "CarModels.h"
#import "InDependence.h"

@implementation Ford
@end

@implementation FordFocusLogo
independence_requires_ancestors(@"parentCar")
@end

@implementation FordFocus
independence_requires(@"logo");
independence_initializer(initWithYear:,@"2010");

-(id)initWithYear:(NSString *)year{
	self = [super init];
	if (nil == self) return nil;
	_year = year;
	return self;
}

@end

@implementation Renault
@end

@implementation RenaultClio
@end
