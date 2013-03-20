//
//  InDependenceAncestorsExtension.h
//  InDependence
//
//  Created by Yan Rabovik on 28.02.13.
//  Copyright (c) 2013 Yan Rabovik. All rights reserved.
//

#import "INDExtension.h"

#define independence_references(args...) \
+(NSSet *)independence_references{ \
    NSSet *requirements = [NSSet setWithObjects: args, nil]; \
    return [INDUtils \
            unionRequirementsSetForClass:self \
            withSet:requirements \
            selector:@selector(independence_references)]; \
}

@interface INDReferencesExtension : INDExtension

@end
