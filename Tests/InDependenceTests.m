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
}

- (void)setUp{
    [super setUp];
    [[InDependenceInjector sharedInjector] bindClass:[SportSteeringWheel class] toProtocol:@protocol(SteeringWheel)];
}

- (void)tearDown{
    [InDependenceInjector setSharedInjector:nil];
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
    [[InDependenceInjector sharedInjector] bindClass:[RenaultClio class] toClass:[Renault class]];
    Renault *car = [[InDependenceInjector sharedInjector] getObject:[Renault class]];
    STAssertTrue([NSStringFromClass([car class]) isEqualToString:@"RenaultClio"], @"Class is %@",NSStringFromClass([car class]));
    Garage *garage = [[InDependenceInjector sharedInjector] getObject:[Garage class]];
    STAssertTrue([NSStringFromClass([garage.renaultCar class]) isEqualToString:@"RenaultClio"], @"");
}
-(void)testClassToProtocolBinding{
    Ford *car = [[InDependenceInjector sharedInjector] getObject:[Ford class]];
    STAssertTrue([NSStringFromClass([car.steeringWheel class]) isEqualToString:@"SportSteeringWheel"], @"Class is %@",NSStringFromClass([car.steeringWheel class]));
}
-(void)testRecursiveBindings{
    [[InDependenceInjector sharedInjector] bindClass:[Ford class] toClass:[Car class]];
    [[InDependenceInjector sharedInjector] bindClass:[FordFocus class] toClass:[Ford class]];
    Car *car = [[InDependenceInjector sharedInjector] getObject:[Car class]];
    STAssertTrue([car class] == [FordFocus class], @"Class is %@",[car class]);
}

@end
