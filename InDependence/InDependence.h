//
//  InDependence.h
//  InDependence
//
//  Created by Yan Rabovik on 26.02.13.
//  Copyright (c) 2013 Yan Rabovik. All rights reserved.
//

#import "RSInjector.h"
#import "RSInjectorUtils.h"

#import "RSInjectorSingletonExtension.h"

#define rs_requires(args...) \
+(NSSet *)rs_requires{ \
    NSSet *requirements = [NSSet setWithObjects: args, nil]; \
    return [RSInjectorUtils collectRequirementsForClass:self \
                                           requirements:requirements \
                                               selector:@selector(rs_requires)]; \
}