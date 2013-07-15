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

@interface TestSuperClass : TestClass
@end
@implementation TestSuperClass
@end


@interface TestAssociatedClass : NSObject
@property (nonatomic,weak) TestClass *parent;
@end
@implementation TestAssociatedClass
independence_references(@"parent");
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
        TestSuperClass *testParent = INDObjectOfClass(TestSuperClass, nil);
        TestAssociatedClass *associatedObject = [testParent.ind_childs anyObject];
        weakAssociatedObject = associatedObject;
        STAssertNotNil(associatedObject, @"");
        STAssertEqualObjects([associatedObject class], [TestAssociatedClass class], @"");
        STAssertEqualObjects(associatedObject.ind_parent, testParent, @"");
        STAssertEqualObjects(associatedObject.parent, testParent, @"");
    }
    STAssertNil(weakAssociatedObject, @"");
}


@end
