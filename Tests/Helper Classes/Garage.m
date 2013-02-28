//
//  Garage.m
//  InDependence
//
//  Created by Yan Rabovik on 27.02.13.
//  Copyright (c) 2013 Yan Rabovik. All rights reserved.
//

#import "Garage.h"

@implementation Garage
independence_requires(@"fordCar",@"renaultCar");

-(void)awakeFromInjector{
    NSLog(@"AWAKE %@",self);
}

@end
