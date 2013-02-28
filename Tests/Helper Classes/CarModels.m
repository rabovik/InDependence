//
//  Ford.m
//  InDependence
//
//  Created by Yan Rabovik on 27.02.13.
//  Copyright (c) 2013 Yan Rabovik. All rights reserved.
//

#import "CarModels.h"

@implementation Ford
@end

@implementation FordFocusLogo
@end

@implementation FordFocus
rs_requires(@"logo");
rs_initializer(initWithYear:,@"2010");

-(id)initWithYear:(NSString *)year{
	self = [super init];
	if (nil == self) return nil;
	_year = year;
	return self;
}

@end

@implementation Renault
@end
