//
//  RSInjectorUtilsTests.m
//  InDependence
//
//  Created by Yan Rabovik on 27.02.13.
//  Copyright (c) 2013 Yan Rabovik. All rights reserved.
//

#import "InDependenceUtilsTests.h"
#import "CarModels.h"

@implementation InDependenceUtilsTests

-(void)testEntriesFromClassAndSuperClasses{
    NSSet *requiredSet =
        [FordFocus performSelector:@selector(independence_requirements)];
    NSSet *etalonSet =
        [NSSet setWithObjects:@"logo",@"engine",@"road",@"steeringWheel",nil];
    
    NSMutableSet *s = [NSMutableSet new];
    [s unionSet:nil];
    STAssertTrue([s isEqualToSet:[NSSet set]], @"");
    
    STAssertTrue([requiredSet isEqualToSet:etalonSet], @"");
}

@end
