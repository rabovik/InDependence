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
    Ford *fordCar = [[INDInjector sharedInjector] getObject:[FordFocus class]
                                                     parent:nil];
    STAssertNotNil(fordCar.engine, @"");
}

-(void)testSingletonRoad{
    Garage *garage = [[INDInjector sharedInjector] getObject:[Garage class]
                                                      parent:nil];
    STAssertNotNil(garage.fordCar.road, @"");
    STAssertNotNil(garage.renaultCar.road, @"");
    STAssertEqualObjects(garage.fordCar.road, garage.renaultCar.road, @"");
}

-(void)testCustomInitializer{
    FordFocus *car = [[INDInjector sharedInjector] getObject:[FordFocus class]
                                                      parent:nil];
    STAssertTrue([car.year isEqualToString:@"2010"], @"Year is %@",car.year);
    STAssertEqualObjects(car.color, [UIColor blackColor], @"");
    
    FordFocus *car2013 = [[INDInjector sharedInjector]
                          getObject:[FordFocus class]
                          parent:nil
                          arguments:@"2013",[UIColor whiteColor],nil];
    STAssertTrue([car2013.year isEqualToString:@"2013"], @"");
    STAssertEqualObjects(car2013.color, [UIColor whiteColor], @"");
}

-(void)testClassToClassBinding{
    [[INDInjector sharedInjector]
     addModule:[[INDModuleWithBlock alloc]
                initWithBlock:^(INDModule *module){
                    [module bindClass:[RenaultClio class]
                              toClass:[Renault class]];
                }]];    
    Renault *car = [[INDInjector sharedInjector] getObject:[Renault class]
                                                    parent:nil];
    STAssertTrue([NSStringFromClass([car class]) isEqualToString:@"RenaultClio"],
                 @"Class is %@",NSStringFromClass([car class]));
    Garage *garage = [[INDInjector sharedInjector] getObject:[Garage class]
                                                      parent:nil];
    STAssertTrue([NSStringFromClass([garage.renaultCar class])
                  isEqualToString:@"RenaultClio"],
                 @"");
}
-(void)testClassToProtocolBinding{
    Ford *car = [[INDInjector sharedInjector] getObject:[Ford class]
                                                 parent:nil];
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
    Car *car = [[INDInjector sharedInjector] getObject:[Car class]
                                                parent:nil];
    STAssertTrue([car class] == [FordFocus class], @"Class is %@",[car class]);
}

-(void)testRequiredAncestors{
    /*
    Garage *garage = [[INDInjector sharedInjector] getObject:[Garage class]
                                                      parent:nil];
    FordFocus *focus = garage.fordCar;
    STAssertEqualObjects(focus.logo.parentCar, focus, @"");
    SportSteeringWheel *wheel = (SportSteeringWheel *)focus.steeringWheel;
    STAssertEqualObjects(wheel.garage, garage, @"");
     */
}

@end
