//
//  Garage.h
//  InDependence
//
//  Created by Yan Rabovik on 27.02.13.
//  Copyright (c) 2013 Yan Rabovik. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Ford,FordFocus,Renault;

@protocol Garage <NSObject>
@end

@interface Garage : NSObject<Garage>

@property (nonatomic,strong) FordFocus *fordCar;
@property (nonatomic,strong) Renault *renaultCar;

@end
