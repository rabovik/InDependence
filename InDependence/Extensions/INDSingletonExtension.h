//
//  RSInjectorSingletonExtension.h
//  InDependence
//
//  Created by Yan Rabovik on 27.02.13.
//  Copyright (c) 2013 Yan Rabovik. All rights reserved.
//

#import "INDExtension.h"

#define independence_singleton() \
+(BOOL)independence_singleton { \
    return YES; \
}

@interface INDSingletonExtension : INDExtension

@end
