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
#import "NSObject+InDependence.h"

#import "INDCustomInitializerExtension.h"
#import "INDSingletonExtension.h"
#import "INDReferencesExtension.h"

#define independence_requirements(args...) \
_ind_deprecated2(independence_requirements,ind_requirements) \
+(NSSet *)ind_requirements{ \
    NSSet *requirements = [NSSet setWithObjects: args, nil]; \
    return [INDUtils \
            unionRequirementsSetForClass:self \
            withSet:requirements \
            selector:@selector(ind_requirements)]; \
}

#define ind_requirements(args...) \
_ind_static_check_properties(requirements,args) \
+(NSSet *)ind_requirements{ \
    NSSet *requirements = _ind_set_of_strings_from_properties(args); \
    return [INDUtils \
            unionRequirementsSetForClass:self \
            withSet:requirements \
            selector:@selector(ind_requirements)]; \
}
