//
//  Car.h
//  InDependence
//
//  Created by Yan Rabovik on 27.02.13.
//  Copyright (c) 2013 Yan Rabovik. All rights reserved.
//

@class Engine,Road;
@protocol Garage;

@protocol SteeringWheel <NSObject>
@end

@protocol CarProtocol <NSObject>
@end

@interface Car : NSObject <CarProtocol>

@property (nonatomic,strong) Engine *engine;
@property (nonatomic,strong) Road *road;
@property (nonatomic,strong) id<SteeringWheel> steeringWheel;

@end

@interface SportSteeringWheel : NSObject<SteeringWheel>
@property (nonatomic,weak) id<Garage> garage;
@end
