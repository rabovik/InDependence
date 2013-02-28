//
//  RSInjectorCustomInitializerExtension.h
//  InDependence
//
//  Created by Yan Rabovik on 28.02.13.
//  Copyright (c) 2013 Yan Rabovik. All rights reserved.
//

#import "InDependenceExtension.h"

#define independence_initializer(selectorSymbols, args...) \
+(NSString *)independence_initializer { \
    return NSStringFromSelector(@selector(selectorSymbols)); \
} \
+(NSArray *)independence_initializer_arguments { \
    id objs[]= {args}; \
    return [NSArray arrayWithObjects: objs count:sizeof(objs)/sizeof(id)]; \
}

@interface InDependenceCustomInitializerExtension : InDependenceExtension

@end
