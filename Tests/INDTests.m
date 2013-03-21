//
//  Tests.m
//  Tests
//
//  Created by Yan Rabovik on 26.02.13.
//  Copyright (c) 2013 Yan Rabovik. All rights reserved.
//

#import "INDTests.h"
#import "CarModels.h"
#import "Engine.h"
#import "Garage.h"
#import "Road.h"
#import "InDependence.h"
#import "INDModuleWithBlock.h"
#import "NSObject+INDObjectsTree.h"

@implementation INDTests{
}

#pragma mark - Setup
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

#pragma mark - Inject property
- (void)testInjectEngineToCar{
    Ford *fordCar = [[INDInjector sharedInjector] getObject:[FordFocus class]
                                                     parent:nil];
    STAssertNotNil(fordCar.engine, @"");
}

#pragma mark - Singleton
-(void)testSingletonRoad{
    Garage *garage = [[INDInjector sharedInjector] getObject:[Garage class]
                                                      parent:nil];
    STAssertNotNil(garage.fordCar.road, @"");
    STAssertNotNil(garage.renaultCar.road, @"");
    STAssertEqualObjects(garage.fordCar.road, garage.renaultCar.road, @"");
}

#pragma mark - Custom initializer
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

#pragma mark - Bindings
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

#pragma mark - References
-(void)testReferences{
    Garage *garage = [[INDInjector sharedInjector] getObject:[Garage class]
                                                      parent:nil];
    FordFocus *focus = garage.fordCar;
    Renault *renault = garage.renaultCar;
    NSLog(@"FOCUS:\nengine: %@\nsteering: %@",
          focus.engine,
          focus.steeringWheel);
    NSLog(@"RENAULT:\nengine: %@\nsteering: %@",
          renault.engine,
          renault.steeringWheel);
    
    // ancestors
    STAssertEqualObjects(focus.logo.parentCar, focus, @"");
    SportSteeringWheel *wheel = (SportSteeringWheel *)focus.steeringWheel;
    STAssertEqualObjects(wheel.garage, garage, @"");
    
    // siblings
    STAssertEqualObjects(focus.neighboringCar, renault, @"");
    STAssertEqualObjects(renault.neighboringCar, focus, @"");
    
    // relatives
    STAssertEqualObjects(focus.neighboringCarEngine, renault.engine, @"");
    STAssertEqualObjects(focus.neighboringCarSteeringWheel,
                         renault.steeringWheel, @"");
    
}

#pragma mark - Objects tree
#define ASSERT_CHILDS(PARENT,CHILDS...) \
    do{ \
        NSSet *etalonChilds = [NSSet setWithObjects:CHILDS, nil]; \
        BOOL childsMatch = [PARENT.ind_childs isEqualToSet:etalonChilds]; \
        STAssertTrue(childsMatch, @"Childs:%@",PARENT.ind_childs); \
    }while(0);

#define ASSERT_PARENT(CHILD,PARENT) \
    do{ \
        id parent = CHILD.ind_parent; \
        BOOL parentMatches = [parent isEqual:PARENT]; \
        STAssertTrue(parentMatches,@"Parent is %@ instead of %@",parent,PARENT); \
    }while(0);

-(void)testCorrectObjectTreeBuilt{
    INDInjector *injector = [INDInjector sharedInjector];
    Garage *garage = [injector getObject:[Garage class] parent:nil];
    ASSERT_CHILDS(garage, garage.fordCar, garage.renaultCar);
    ASSERT_PARENT(garage.fordCar, garage);
    ASSERT_PARENT(garage.renaultCar, garage);
    
    FordFocus *fordCar = garage.fordCar;
    ASSERT_CHILDS(fordCar,
                  fordCar.engine,
                  fordCar.steeringWheel,
                  fordCar.logo);
    ASSERT_PARENT(fordCar.engine, fordCar);
    // for singletons, parent should be injector;
    ASSERT_PARENT(fordCar.road, injector);
}

@end
