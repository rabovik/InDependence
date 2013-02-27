//
//  Tests.m
//  Tests
//
//  Created by Yan Rabovik on 26.02.13.
//  Copyright (c) 2013 Yan Rabovik. All rights reserved.
//

#import "Tests.h"
#import "Ford.h"
#import "InDependence.h"

@implementation Tests

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

- (void)testExample
{
    [[RSInjector sharedInjector] getObject:[Ford class]];
}

@end
