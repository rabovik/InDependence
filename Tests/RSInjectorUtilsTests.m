//
//  RSInjectorUtilsTests.m
//  InDependence
//
//  Created by Yan Rabovik on 27.02.13.
//  Copyright (c) 2013 Yan Rabovik. All rights reserved.
//

#import "RSInjectorUtilsTests.h"
#import "Ford.h"

@implementation RSInjectorUtilsTests

-(void)testEntriesFromClassAndSuperClasses{
    NSSet *requiredSet = [FordFocus performSelector:@selector(rs_requires)];
    NSSet *etalonSet = [NSSet setWithObjects:@"logo",@"engine",nil];
    
    NSMutableSet *s = [NSMutableSet new];
    [s unionSet:nil];
    STAssertTrue([s isEqualToSet:[NSSet set]], @"");
    
    STAssertTrue([requiredSet isEqualToSet:etalonSet], @"");
}

@end
