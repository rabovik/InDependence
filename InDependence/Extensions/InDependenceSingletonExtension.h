//
//  RSInjectorSingletonExtension.h
//  InDependence
//
//  Created by Yan Rabovik on 27.02.13.
//  Copyright (c) 2013 Yan Rabovik. All rights reserved.
//

#import "InDependenceExtension.h"

#define independence_register_singleton() \
+(BOOL)independence_register_singleton { \
    return YES; \
}

@interface InDependenceSingletonExtension : InDependenceExtension

@end
