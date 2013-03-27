//
//  INDCustomClassInitializerTests.h
//  InDependence
//
//  Created by Yan Rabovik on 27.03.13.
//  Copyright (c) 2013 Yan Rabovik. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>

@interface ColoredPaper : NSObject
+(id)redPaper;
@property(nonatomic,strong) UIColor *color;
@end

@interface INDCustomClassInitializerTests : SenTestCase

@end
