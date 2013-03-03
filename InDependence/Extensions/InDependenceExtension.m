//
//  RSInjectorExtension.m
//  InDependence
//
//  Created by Yan Rabovik on 27.02.13.
//  Copyright (c) 2013 Yan Rabovik. All rights reserved.
//

#import "InDependenceExtension.h"

@implementation InDependenceExtension

-(Class)resolveClass:(id)classOrProtocol
            injector:(InDependenceInjector*)injector
             session:(InDependenceSession*)session
           ancestors:(NSArray *)ancestors
                info:(NSDictionary *)info
{
    return [self.delegate
            resolveClass:classOrProtocol
            injector:injector
            session:session
            ancestors:ancestors
            info:info];
}

-(id)createObjectOfClass:(Class)resolvedClass
                injector:(InDependenceInjector*)injector
                 session:(InDependenceSession*)session
               ancestors:(NSArray *)ancestors
                    info:(NSDictionary *)info
{
    return [self.delegate
            createObjectOfClass:resolvedClass
            injector:injector
            session:session
            ancestors:ancestors
            info:info];
}

@end
