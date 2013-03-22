//
//  RSInjectorCustomInitializerExtension.h
//  InDependence
//
//  Created by Yan Rabovik on 28.02.13.
//  Copyright (c) 2013 Yan Rabovik. All rights reserved.
//

#import "INDExtension.h"
#import "INDInjector.h"
#import "INDModule.h"

#define independence_initializer(selectorSymbols, args...) \
+(NSString *)independence_initializer { \
    return NSStringFromSelector(@selector(selectorSymbols)); \
} \
+(NSArray *)independence_initializer_arguments { \
    id objs[]= {args}; \
    return [NSArray arrayWithObjects: objs count:sizeof(objs)/sizeof(id)]; \
}

@interface INDInjector (CustomInitializer)
-(id)getObject:(id)classOrProtocol
        parent:(id)parent
     arguments:(id)firstArgument, ...NS_REQUIRES_NIL_TERMINATION;

@end

@interface INDModule (CustomInitializer)
-(void)bindArgument:(id)argument atIndex:(NSUInteger)index toClass:(Class)toClass;
@end

@interface INDCustomInitializerExtension : INDExtension
@end
