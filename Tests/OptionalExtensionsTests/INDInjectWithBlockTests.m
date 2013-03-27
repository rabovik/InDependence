//
//  INDInjectWithFactoryBlockTests.m
//  InDependence
//
//  Created by Yan Rabovik on 27.03.13.
//  Copyright (c) 2013 Yan Rabovik. All rights reserved.
//

#import "INDInjectWithBlockTests.h"
#import "InDependence.h"
#import "INDInjectWithBlockExtension.h"

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

@implementation Root
independence_requirements(@"b1",@"b2");
independence_inject_with_blocks(
                                @"a1",
                                ^id(Root *self,INDInjector *injector){
                                    return [[A alloc] initWithB:self.b1];
                                },
                                @"a2",
                                ^id(Root *self,INDInjector *injector){
                                    return [[A alloc] initWithB:self.b2];
                                });
@end

#pragma mark - Tests -
@implementation INDInjectWithBlockTests

-(void)setUp{
    [super setUp];
    [INDInjector registerExtensionClass:[INDInjectWithBlockExtension class]];
}

-(void)tearDown{
    [INDInjector unRegisterExtensionClass:[INDInjectWithBlockExtension class]];
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









