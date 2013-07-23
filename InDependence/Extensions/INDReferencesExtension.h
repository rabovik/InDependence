//
//  InDependenceAncestorsExtension.h
//  InDependence
//
//  Created by Yan Rabovik on 28.02.13.
//  Copyright (c) 2013 Yan Rabovik. All rights reserved.
//

#import "INDExtension.h"
#import "INDUtils.h"

#define independence_references(args...) \
_ind_deprecated2(independence_references,ind_references) \
+(NSSet *)ind_references{ \
    NSSet *requirements = [NSSet setWithObjects: args, nil]; \
    return [INDUtils \
            unionRequirementsSetForClass:self \
            withSet:requirements \
            selector:@selector(ind_references)]; \
}

#define ind_references(args...) \
_ind_static_check_properties(references,args) \
+(NSSet *)ind_references{ \
    NSSet *references = _ind_set_of_strings_from_properties(args); \
    return [INDUtils \
            unionRequirementsSetForClass:self \
            withSet:references \
            selector:@selector(ind_references)]; \
}

@interface INDReferencesExtension : INDExtension

@end
