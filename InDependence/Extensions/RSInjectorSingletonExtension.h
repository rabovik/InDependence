//
//  RSInjectorSingletonExtension.h
//  InDependence
//
//  Created by Yan Rabovik on 27.02.13.
//  Copyright (c) 2013 Yan Rabovik. All rights reserved.
//

#import "RSInjectorExtension.h"

#define rs_register_singleton() \
+(BOOL)rs_register_singleton { \
    return YES; \
}

@interface RSInjectorSingletonExtension : RSInjectorExtension

@end
