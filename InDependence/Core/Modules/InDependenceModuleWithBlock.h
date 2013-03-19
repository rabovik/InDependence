//
//  InDependenceModuleWithBlock.h
//  InDependence
//
//  Created by Yan Rabovik on 19.03.13.
//  Copyright (c) 2013 Yan Rabovik. All rights reserved.
//

#import "InDependenceModule.h"

@class InDependenceModule;

typedef void(^InDependenceModuleBlock)(InDependenceModule *module);

@interface InDependenceModuleWithBlock : InDependenceModule

-(id)initWithBlock:(InDependenceModuleBlock)block;

@end
