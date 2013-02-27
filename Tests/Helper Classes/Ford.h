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
@end

@interface FordFocus : Ford
@property (nonatomic,strong) FordFocusLogo *logo;
@end
