//
//  RSInjectorExtension.m
//  InDependence
//
//  Created by Yan Rabovik on 27.02.13.
//  Copyright (c) 2013 Yan Rabovik. All rights reserved.
//

#import "RSInjectorExtension.h"

@implementation RSInjectorExtension

-(Class)resolveClass:(id)classOrProtocol{
    return [self.delegate resolveClass:classOrProtocol];
}

-(id)createObjectOfClass:(Class)resolvedClass
                injector:(RSInjector*)injector
                 session:(RSInjectorSession*)session
               ancestors:(NSArray *)ancestors{
    return [self.delegate createObjectOfClass:resolvedClass
                                     injector:injector
                                      session:session
                                    ancestors:ancestors];
}

-(void)informObjectsCreatedInSessionThatTheyAreReady{
    [self.delegate informObjectsCreatedInSessionThatTheyAreReady];
}


@end
