//
//  Tests.m
//  Tests
//
//  Created by Yan Rabovik on 26.02.13.
//  Copyright (c) 2013 Yan Rabovik. All rights reserved.
//

#import "INDTests.h"
#import "CarModels.h"
#import "Garage.h"
#import "InDependence.h"
#import "INDModuleWithBlock.h"

@implementation INDTests{
}

- (void)setUp{
    [super setUp];
    [[INDInjector sharedInjector]
     addModule:[[INDModuleWithBlock alloc]
                initWithBlock:^(INDModule *module){
                    [module bindClass:[SportSteeringWheel class]
                           toProtocol:@protocol(SteeringWheel)];
                }]];
}

- (void)tearDown{
    [INDInjector setSharedInjector:nil];
    [super tearDown];
}

- (void)testInjectEngineToCar{
    Ford *fordCar = [[INDInjector sharedInjector] getObject:[FordFocus class]];
    STAssertNotNil(fordCar.engine, @"");
}

-(void)testSingletonRoad{
    Garage *garage = [[INDInjector sharedInjector] getObject:[Garage class]];
    STAssertNotNil(garage.fordCar.road, @"");
    STAssertNotNil(garage.renaultCar.road, @"");
    STAssertEqualObjects(garage.fordCar.road, garage.renaultCar.road, @"");
}

-(void)testCustomInitializer{
    FordFocus *car = [[INDInjector sharedInjector] getObject:[FordFocus class]];
    STAssertTrue([car.year isEqualToString:@"2010"], @"Year is %@",car.year);
    
    FordFocus *car2013 = [[INDInjector sharedInjector]
                          getObjectWithArgs:[FordFocus class],
                          @"2013",
                          nil];
    STAssertTrue([car2013.year isEqualToString:@"2013"], @"");

}

-(void)testClassToClassBinding{
    [[INDInjector sharedInjector]
     addModule:[[INDModuleWithBlock alloc]
                initWithBlock:^(INDModule *module){
                    [module bindClass:[RenaultClio class]
                              toClass:[Renault class]];
                }]];    
    Renault *car = [[INDInjector sharedInjector] getObject:[Renault class]];
    STAssertTrue([NSStringFromClass([car class]) isEqualToString:@"RenaultClio"],
                 @"Class is %@",NSStringFromClass([car class]));
    Garage *garage = [[INDInjector sharedInjector] getObject:[Garage class]];
    STAssertTrue([NSStringFromClass([garage.renaultCar class])
                  isEqualToString:@"RenaultClio"],
                 @"");
}
-(void)testClassToProtocolBinding{
    Ford *car = [[INDInjector sharedInjector] getObject:[Ford class]];
    STAssertTrue([NSStringFromClass([car.steeringWheel class])
                  isEqualToString:@"SportSteeringWheel"],
                 @"Class is %@",NSStringFromClass([car.steeringWheel class]));
}
-(void)testRecursiveBindings{
    [[INDInjector sharedInjector]
     addModule:[[INDModuleWithBlock alloc]
                initWithBlock:^(INDModule *module){
                    [module bindClass:[Ford class]
                              toClass:[Car class]];
                    [module bindClass:[FordFocus class]
                              toClass:[Ford class]];
                }]];
    Car *car = [[INDInjector sharedInjector] getObject:[Car class]];
    STAssertTrue([car class] == [FordFocus class], @"Class is %@",[car class]);
}

-(void)testRequiredAncestors{
    Garage *garage = [[INDInjector sharedInjector] getObject:[Garage class]];
    FordFocus *focus = garage.fordCar;
    STAssertEqualObjects(focus.logo.parentCar, focus, @"");
    SportSteeringWheel *wheel = (SportSteeringWheel *)focus.steeringWheel;
    STAssertEqualObjects(wheel.garage, garage, @"");
}

@end
