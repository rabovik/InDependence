//
//  INDObjectsTreeTests.m
//  InDependence
//
//  Created by Yan Rabovik on 21.03.13.
//  Copyright (c) 2013 Yan Rabovik. All rights reserved.
//

#import "INDObjectsTreeTests.h"
#import "NSObject+INDObjectsTree.h"

@implementation INDObjectsTreeTests

-(void)testObjectsTree{
    NSObject *root = [NSObject new];
    NSObject *a = [NSObject new];
    NSObject *b;
    NSObject *c = [NSObject new];
    
    @autoreleasepool {
        b = [NSObject new];
        
        [root ind_addChild:a];
        [root ind_addChild:b];
        [b ind_addChild:c];
        
        NSSet *etalonRootChilds = [NSSet setWithObjects:a,b, nil];
        NSSet *etalonBChilds = [NSSet setWithObjects:c, nil];
        
        STAssertTrue([root.ind_childs isEqualToSet:etalonRootChilds], @"");
        STAssertEqualObjects(root, a.ind_parent, @"");
        STAssertEqualObjects(root, b.ind_parent, @"");
        STAssertTrue([b.ind_childs isEqualToSet:etalonBChilds], @"");
        STAssertEqualObjects(b, c.ind_parent, @"");
        
        STAssertEqualObjects(c.ind_root, root, @"");
        
        b = nil;
    }
    
    STAssertNil(b, @"");
    STAssertTrue([root.ind_childs isEqualToSet:[NSSet setWithObject:a]], @"");
    STAssertEqualObjects(root, a.ind_parent, @"");
    STAssertNotNil(c, @"");
    STAssertNil(c.ind_parent, @"");
    STAssertEqualObjects(c.ind_root, c, @"");
}

@end
