//
//  INDWeakCollectionTests.m
//  InDependence
//
//  Created by Yan Rabovik on 21.03.13.
//  Copyright (c) 2013 Yan Rabovik. All rights reserved.
//

#import "INDWeakCollectionTests.h"
#import "INDWeakCollection.h"

@implementation INDWeakCollectionTests{
    INDWeakCollection *_collection;
}

-(void)setUp{
    [super setUp];
    _collection = [INDWeakCollection new];
}

-(void)testObjectsAddObjectsGet{
    NSObject *a = [NSObject new];
    NSObject *b = [NSObject new];
    [_collection addObject:a];
    [_collection addObject:b];
    
    NSSet *etalonSet = [NSSet setWithObjects:a,b,nil];
    STAssertTrue([[_collection allObjects] isEqualToSet:etalonSet], @"");
}

-(void)testObjectIsRemovedFromSetAfterDealloc{
    NSObject *a = [NSObject new];
    NSObject *b;
    [_collection addObject:a];
    @autoreleasepool {
        b = [NSObject new];
        [_collection addObject:b];
    }
    NSSet *etalonSet = [NSSet setWithObjects:a,nil];
    STAssertTrue([[_collection allObjects] isEqualToSet:etalonSet], @"");
}

@end
