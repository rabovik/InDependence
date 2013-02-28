//
//  InDependence.h
//  InDependence
//
//  Created by Yan Rabovik on 26.02.13.
//  Copyright (c) 2013 Yan Rabovik. All rights reserved.
//

#import "InDependenceInjector.h"
#import "InDependenceUtils.h"

#import "InDependenceCustomInitializerExtension.h"
#import "InDependenceSingletonExtension.h"

#define independence_requires(args...) \
+(NSSet *)independence_requires{ \
    NSSet *requirements = [NSSet setWithObjects: args, nil]; \
    return [InDependenceUtils collectRequirementsForClass:self \
                                           requirements:requirements \
                                               selector:@selector(independence_requires)]; \
}