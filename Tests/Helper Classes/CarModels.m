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
ind_references(parentCar);
@end

@implementation FordFocus
ind_requirements(logo);
ind_initializer(initWithYear:color:,@"2010",[UIColor blackColor]);
ind_references(neighboringCar,
               neighboringCarEngine,
               neighboringCarSteeringWheel);

-(id)initWithYear:(NSString *)year color:(UIColor *)color{
	self = [super init];
	if (nil == self) return nil;
	_year = year;
    _color = color;
	return self;
}

@end

@implementation Renault
ind_references(neighboringCar);
@end

@implementation RenaultClio
@end
