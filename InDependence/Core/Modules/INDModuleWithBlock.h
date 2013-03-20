//
//  InDependenceModuleWithBlock.h
//  InDependence
//
//  Created by Yan Rabovik on 19.03.13.
//  Copyright (c) 2013 Yan Rabovik. All rights reserved.
//

#import "INDModule.h"

@class INDModule;

typedef void(^INDModuleBlock)(INDModule *module);

@interface INDModuleWithBlock : INDModule

-(id)initWithBlock:(INDModuleBlock)block;

@end
