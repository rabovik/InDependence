//
//  Tests.m
//  Tests
//
//  Created by Yan Rabovik on 26.02.13.
//  Copyright (c) 2013 Yan Rabovik. All rights reserved.
//

#import "InDependenceTests.h"
#import "CarModels.h"
#import "Garage.h"
#import "InDependence.h"

@implementation InDependenceTests{
    InDependenceInjector *injector;
}

- (void)setUp{
    [super setUp];
    injector = [InDependenceInjector new];
    [InDependenceInjector setDefaultInjector:injector];
}

- (void)tearDown{
    injector = nil;
    [super tearDown];
}

- (void)testInjectEngineToCar{
    Ford *fordCar = [[InDependenceInjector sharedInjector] getObject:[FordFocus class]];
    STAssertNotNil(fordCar.engine, @"");
}

-(void)testSingletonRoad{
    Garage *garage = [[InDependenceInjector sharedInjector] getObject:[Garage class]];
    STAssertNotNil(garage.fordCar.road, @"");
    STAssertNotNil(garage.renaultCar.road, @"");
    STAssertEqualObjects(garage.fordCar.road, garage.renaultCar.road, @"");
}

-(void)testCustomInitializer{
    FordFocus *car = [[InDependenceInjector sharedInjector] getObject:[FordFocus class]];
    STAssertTrue([car.year isEqualToString:@"2010"], @"Year is %@",car.year);
    
    FordFocus *car2013 = [[InDependenceInjector sharedInjector] getObjectWithArgs:[FordFocus class],@"2013",nil];
    STAssertTrue([car2013.year isEqualToString:@"2013"], @"");

}

-(void)testClassToClassBinding{
    [injector bindClass:[RenaultClio class] toClass:[Renault class]];
    Renault *car = [injector getObject:[Renault class]];
    STAssertTrue([NSStringFromClass([car class]) isEqualToString:@"RenaultClio"], @"");
    Garage *garage = [injector getObject:[Garage class]];
    STAssertTrue([NSStringFromClass([garage.renaultCar class]) isEqualToString:@"RenaultClio"], @"");
}

@end
