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

@implementation InDependenceTests

- (void)setUp
{
    [super setUp];
    
    // Set-up code here.
}

- (void)tearDown
{
    // Tear-down code here.
    
    [super tearDown];
}

- (void)testInjectEngineToCar{
    
    Ford *fordCar = [[RSInjector sharedInjector] getObject:[FordFocus class]];
    STAssertNotNil(fordCar.engine, @"");
}

-(void)testSingletonRoad{
    Garage *garage = [[RSInjector sharedInjector] getObject:[Garage class]];
    STAssertNotNil(garage.fordCar.road, @"");
    STAssertNotNil(garage.renaultCar.road, @"");
    STAssertEqualObjects(garage.fordCar.road, garage.renaultCar.road, @"");
}

-(void)testCustomInitializer{
    FordFocus *car = [[RSInjector sharedInjector] getObject:[FordFocus class]];
    STAssertTrue([car.year isEqualToString:@"2010"], @"");
    
    FordFocus *car2013 = [[RSInjector sharedInjector] getObject:[FordFocus class]];
    STAssertTrue([car2013.year isEqualToString:@"2013"], @"");

}

@end
