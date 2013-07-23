//
//  Car.m
//  InDependence
//
//  Created by Yan Rabovik on 27.02.13.
//  Copyright (c) 2013 Yan Rabovik. All rights reserved.
//

#import "Car.h"
#import "InDependence.h"

@implementation Car
ind_requirements(road,steeringWheel,engine);
-(void)awakeFromInjector{
    //NSLog(@"AWAKE %@",self);
}
@end

@implementation SportSteeringWheel
ind_references(garage);
@end
