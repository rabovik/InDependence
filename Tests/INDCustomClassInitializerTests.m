//
//  INDCustomClassInitializerTests.m
//  InDependence
//
//  Created by Yan Rabovik on 27.03.13.
//  Copyright (c) 2013 Yan Rabovik. All rights reserved.
//

#import "INDCustomClassInitializerTests.h"
#import "InDependence.h"

@implementation ColoredPaper
ind_class_initializer(redPaper);
+(id)redPaper{
    ColoredPaper *paper = [[self class] new];
    paper.color = [UIColor redColor];
    return paper;
}

@end

@implementation INDCustomClassInitializerTests

-(void)setUp{
    [super setUp];
}

-(void)tearDown{
    [INDInjector setSharedInjector:nil];
    [super tearDown];
}

-(void)testCustomClassInitializer{
    ColoredPaper *paper = [[INDInjector sharedInjector] getObject:[ColoredPaper class]
                                                           parent:nil];
    STAssertNotNil(paper, @"");
    STAssertEqualObjects(paper.color, [UIColor redColor], @"");
}

@end
