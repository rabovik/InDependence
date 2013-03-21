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
              parent:(id)parent
                info:(NSDictionary *)info
{
    return [self.delegate
            resolveClass:classOrProtocol
            session:session
            parent:parent
            info:info];
}

-(id)createObjectOfClass:(Class)resolvedClass
                 session:(INDSession*)session
                  parent:(id)parent
                    info:(NSDictionary *)info
{
    return [self.delegate
            createObjectOfClass:resolvedClass
            session:session
            parent:parent
            info:info];
}

-(void)injectRequirements:(NSSet *)properties
                 toObject:(id)object
                  session:(INDSession*)session
                     info:(NSDictionary *)info
{
    return [self.delegate injectRequirements:properties
                                    toObject:object
                                     session:session
                                        info:info];
}

@end
