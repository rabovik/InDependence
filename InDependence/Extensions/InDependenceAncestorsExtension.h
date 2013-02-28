//
//  InDependenceAncestorsExtension.h
//  InDependence
//
//  Created by Yan Rabovik on 28.02.13.
//  Copyright (c) 2013 Yan Rabovik. All rights reserved.
//

#import "InDependenceExtension.h"

#define independence_requires_ancestors(args...) \
+(NSSet *)independence_requires_ancestors{ \
    NSSet *requirements = [NSSet setWithObjects: args, nil]; \
    return [InDependenceUtils unionRequirementsSetForClass:self \
                                                   withSet:requirements \
                                                  selector:@selector(independence_requires_ancestors)]; \
}

@interface InDependenceAncestorsExtension : InDependenceExtension

@end
