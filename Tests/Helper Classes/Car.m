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

independence_requires(@"engine",@"road");

-(void)awakeFromInjector{
    //NSLog(@"AWAKE %@",self);
}

@end
