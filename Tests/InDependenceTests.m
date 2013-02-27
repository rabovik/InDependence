//
//  Tests.m
//  Tests
//
//  Created by Yan Rabovik on 26.02.13.
//  Copyright (c) 2013 Yan Rabovik. All rights reserved.
//

#import "InDependenceTests.h"
#import "Ford.h"

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

- (void)testInjectEngineToCar
{
    Ford *fordCar = [[RSInjector sharedInjector] getObject:[FordFocus class]];
    STAssertNotNil(fordCar.engine, @"");
}

@end
