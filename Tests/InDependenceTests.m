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
    
    Ford *fordCar = [[InDependenceInjector sharedInjector] getObject:[FordFocus class]];
    STAssertNotNil(fordCar.engine, @"");
}

-(void)testSingletonRoad{
    NSDate *d0 = [NSDate date];
    Garage *garage = [[InDependenceInjector sharedInjector] getObject:[Garage class]];
    NSTimeInterval t = [[NSDate date] timeIntervalSinceDate:d0];
    NSLog(@"Garage took %f for build.",t);
    
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

@end
