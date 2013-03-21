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
@end

@interface Renault : Car
@end

@interface RenaultClio : Renault
@end