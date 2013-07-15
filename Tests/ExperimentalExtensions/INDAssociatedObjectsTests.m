//
//  INDAssociatedObjectsTests.m
//  InDependence
//
//  Created by Yan Rabovik on 15.07.13.
//  Copyright (c) 2013 Yan Rabovik. All rights reserved.
//

#import "INDAssociatedObjectsTests.h"
#import "INDAssociatedObjectsExtension.h"
#import "InDependence.h"
#import "NSObject+INDObjectsTree.h"

@interface TestClass : NSObject
@end
@implementation TestClass
@end


@interface TestAssociatedClass : NSObject
@end
@implementation TestAssociatedClass
@end

@implementation INDAssociatedObjectsTests

#pragma mark - Setup
- (void)setUp{
    [super setUp];
    [INDInjector registerExtensionClass:[INDAssociatedObjectsExtension class]];
    [[INDInjector sharedInjector]
     addModule:[[INDModuleWithBlock alloc]
                initWithBlock:^(INDModule *module){
                    [module attachObjectOfClass:[TestAssociatedClass class]
                                        toClass:[TestClass class]];
                }]];
}

- (void)tearDown{
    [INDInjector setSharedInjector:nil];
    [super tearDown];
}

#pragma mark - Tests
-(void)testAssociatedObject{
    TestAssociatedClass __weak *weakAssociatedObject = nil;
    @autoreleasepool {
        TestClass *testParent = INDObjectOfClass(TestClass, nil);
        TestAssociatedClass *associatedObject = [testParent.ind_childs anyObject];
        weakAssociatedObject = associatedObject;
        STAssertNotNil(associatedObject, @"");
        STAssertEqualObjects([associatedObject class], [TestAssociatedClass class], @"");
        STAssertTrue(associatedObject.ind_parent == [TestAssociatedClass class], @"");
    }
    STAssertNil(weakAssociatedObject, @"");
}


@end
