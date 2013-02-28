//
//  Car.h
//  InDependence
//
//  Created by Yan Rabovik on 27.02.13.
//  Copyright (c) 2013 Yan Rabovik. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Engine,Road;

@protocol SteeringWheel <NSObject>
@end

@interface Car : NSObject

@property (nonatomic,strong) Engine *engine;
@property (nonatomic,strong) Road *road;
@property (nonatomic,strong) id<SteeringWheel> steeringWheel;

@end

@interface SportSteeringWheel : NSObject<SteeringWheel>
@end
