//
//  INDInjectWithFactoryBlockTests.h
//  InDependence
//
//  Created by Yan Rabovik on 27.03.13.
//  Copyright (c) 2013 Yan Rabovik. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>

#pragma mark - Helpers -
@interface B : NSObject
@end

@interface A : NSObject{
    @public
    B *_b;
}
-(id)initWithB:(B *)b;
@end

@interface Root : NSObject
@property (nonatomic,strong) A *a1;
@property (nonatomic,strong) A *a2;
@property (nonatomic,strong) B *b1;
@property (nonatomic,strong) B *b2;
@end

#pragma mark - Tests -
@interface INDInjectWithBlockTests : SenTestCase
@end

