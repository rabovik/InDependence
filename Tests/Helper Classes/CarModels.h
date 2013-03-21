//
//  Ford.h
//  InDependence
//
//  Created by Yan Rabovik on 27.02.13.
//  Copyright (c) 2013 Yan Rabovik. All rights reserved.
//

#import "Car.h"

@interface Ford : Car
@end

@interface FordFocusLogo : NSObject
@property (nonatomic,weak) Car *parentCar;
@end

@interface FordFocus : Ford
-(id)initWithYear:(NSString *)year color:(UIColor *)color;
@property (nonatomic,readonly) NSString *year;
@property (nonatomic,readonly) UIColor *color;
@property (nonatomic,strong) FordFocusLogo *logo;
@property (nonatomic,weak) Car *neighboringCar;
@property (nonatomic,weak) Engine *neighboringCarEngine;
@property (nonatomic,weak) id<SteeringWheel> neighboringCarSteeringWheel;
@end

@interface Renault : Car
@property (nonatomic,weak) Car *neighboringCar;
@end

@interface RenaultClio : Renault
@end