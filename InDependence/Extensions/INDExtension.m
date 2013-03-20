//
//  RSInjectorExtension.m
//  InDependence
//
//  Created by Yan Rabovik on 27.02.13.
//  Copyright (c) 2013 Yan Rabovik. All rights reserved.
//

#import "INDExtension.h"

@implementation INDExtension

-(Class)resolveClass:(id)classOrProtocol
             session:(INDSession*)session
           ancestors:(NSArray *)ancestors
                info:(NSDictionary *)info
{
    return [self.delegate
            resolveClass:classOrProtocol
            session:session
            ancestors:ancestors
            info:info];
}

-(id)createObjectOfClass:(Class)resolvedClass
                 session:(INDSession*)session
               ancestors:(NSArray *)ancestors
                    info:(NSDictionary *)info
{
    return [self.delegate
            createObjectOfClass:resolvedClass
            session:session
            ancestors:ancestors
            info:info];
}

@end
