//
//  INDAssociatedObjectsExtension.m
//  InDependence
//
//  Created by Yan Rabovik on 15.07.13.
//  Copyright (c) 2013 Yan Rabovik. All rights reserved.
//

#import "INDAssociatedObjectsExtension.h"


#pragma mark - Module -
@implementation INDModule (AssociatedObjects)

-(void)attachObjectOfClass:(Class)aClass toClass:(Class)toClass{
    [self attachObjectOfClass:aClass to:toClass];
}

-(void)attachObjectOfClass:(Class)aClass toProtocol:(Protocol *)toProtocol{
    [self attachObjectOfClass:aClass to:toProtocol];
}

-(void)attachObjectOfClass:(Class)aClass to:(id)classOrProtocol{
    
}

@end

#pragma mark - Extension -
@implementation INDAssociatedObjectsExtension

@end
