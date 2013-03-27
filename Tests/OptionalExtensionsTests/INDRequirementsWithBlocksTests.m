//
//  INDInjectWithFactoryBlockTests.m
//  InDependence
//
//  Created by Yan Rabovik on 27.03.13.
//  Copyright (c) 2013 Yan Rabovik. All rights reserved.
//

#import "INDRequirementsWithBlocksTests.h"
#import "InDependence.h"
#import "INDRequirementsWithBlocksExtension.h"

#pragma mark - Helpers -
@implementation B
@end

@implementation A
-(id)initWithB:(B *)b{
    self = [super init];
    if (nil == self) return nil;
    
    _b = b;
    
	return self;
}
@end

@implementation Parent
independence_requirements_with_blocks
    (@"d",
     ^id(Parent *self,INDInjector *injector){
         return @"123";
     })
@end

@implementation Root
independence_requirements(@"b1",@"b2");
independence_requirements_with_blocks
    (@"a1",
     ^id(Root *self,INDInjector *injector){
         NSAssert(nil != self.d,@"");
         return [[A alloc] initWithB:self.b1];
     },
     @"a2",
     ^id(Root *self,INDInjector *injector){
         NSAssert(nil != self.a1,@"");
         return [[A alloc] initWithB:self.b2];
     });

@end

#pragma mark - Tests -
@implementation INDRequirementsWithBlocksTests

-(void)setUp{
    [super setUp];
    [INDInjector registerExtensionClass:[INDRequirementsWithBlocksExtension class]];
}

-(void)tearDown{
    [INDInjector unRegisterExtensionClass:[INDRequirementsWithBlocksExtension class]];
    [INDInjector setSharedInjector:nil];
    [super tearDown];
}

-(void)testInjectedWithBlock{
    Root *root = [[INDInjector sharedInjector] getObject:[Root class]
                                                  parent:nil];
    STAssertNotNil(root.a1, @"");
    STAssertNotNil(root.a2, @"");
    STAssertNotNil(root.b1, @"");
    STAssertNotNil(root.b2, @"");
    if (root.a1 && root.a2) {
        STAssertEqualObjects(root.b1, root.a1->_b, @"");
        STAssertEqualObjects(root.b2, root.a2->_b, @"");
    }
}

@end









