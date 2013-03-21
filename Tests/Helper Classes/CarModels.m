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
independence_references(@"parentCar")
@end

@implementation FordFocus
independence_requirements(@"logo");
independence_initializer(initWithYear:color:,@"2010",[UIColor blackColor]);
independence_references(@"neighboringCar",
                        @"neighboringCarEngine",
                        @"neighboringCarSteeringWheel");


-(id)initWithYear:(NSString *)year color:(UIColor *)color{
	self = [super init];
	if (nil == self) return nil;
	_year = year;
    _color = color;
	return self;
}

@end

@implementation Renault
independence_references(@"neighboringCar");
@end

@implementation RenaultClio
@end
