//
//  InDependence.h
//  InDependence
//
//  Created by Yan Rabovik on 26.02.13.
//  Copyright (c) 2013 Yan Rabovik. All rights reserved.
//

#import "RSInjector.h"

#define rs_requires(args...) \
+(NSSet *)rs_requires{ \
    return [NSSet setWithObjects:args, nil]; \
}