//
//  InDependence.h
//  InDependence
//
//  Created by Yan Rabovik on 26.02.13.
//  Copyright (c) 2013 Yan Rabovik. All rights reserved.
//

#import "INDInjector.h"
#import "INDUtils.h"
#import "INDModule.h"
#import "INDModuleWithBlock.h"

#import "INDCustomInitializerExtension.h"
#import "INDSingletonExtension.h"
#import "INDReferencesExtension.h"

#define independence_requirements(args...) \
+(NSSet *)independence_requirements{ \
    NSSet *requirements = [NSSet setWithObjects: args, nil]; \
    return [INDUtils \
            unionRequirementsSetForClass:self \
            withSet:requirements \
            selector:@selector(independence_requirements)]; \
}