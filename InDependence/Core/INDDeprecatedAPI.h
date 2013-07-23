//
//  INDDeprecatedAPI.h
//  InDependence
//
//  Created by Yan Rabovik on 23.07.13.
//  Copyright (c) 2013 Yan Rabovik. All rights reserved.
//

#import "INDUtils.h"

#define independence_requirements(args...) \
_ind_deprecated2(independence_requirements,ind_requirements) \
+(NSSet *)ind_requirements{ \
    NSSet *requirements = [NSSet setWithObjects: args, nil]; \
    return [INDUtils \
            unionRequirementsSetForClass:self \
            withSet:requirements \
            selector:@selector(ind_requirements)]; \
}

#define independence_references(args...) \
_ind_deprecated2(independence_references,ind_references) \
+(NSSet *)ind_references{ \
    NSSet *requirements = [NSSet setWithObjects: args, nil]; \
    return [INDUtils \
            unionRequirementsSetForClass:self \
            withSet:requirements \
            selector:@selector(ind_references)]; \
}

#define independence_initializer(selectorSymbols, args...) \
_ind_deprecated2(independence_initializer,ind_initializer) \
ind_initializer(selectorSymbols, args)

#define independence_class_initializer(selectorSymbols, args...) \
_ind_deprecated2(independence_class_initializer,ind_class_initializer) \
ind_class_initializer(selectorSymbols, args) \



