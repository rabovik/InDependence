//
//  InDependenceAncestorsExtension.h
//  InDependence
//
//  Created by Yan Rabovik on 28.02.13.
//  Copyright (c) 2013 Yan Rabovik. All rights reserved.
//

#import "INDExtension.h"

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
