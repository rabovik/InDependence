//
//  INDAssociatedObjectsExtension.h
//  InDependence
//
//  Created by Yan Rabovik on 15.07.13.
//  Copyright (c) 2013 Yan Rabovik. All rights reserved.
//

#import "INDModule.h"
#import "INDExtension.h"

@interface INDModule (AssociatedObjects)
-(void)attachObjectOfClass:(Class)aClass toClass:(Class)toClass;
@end

@interface INDAssociatedObjectsExtension : INDExtension
@end
