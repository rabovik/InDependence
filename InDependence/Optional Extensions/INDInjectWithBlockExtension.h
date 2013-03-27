//
//  INDInjectWithFactoryBlockExtension.h
//  InDependence
//
//  Created by Yan Rabovik on 27.03.13.
//  Copyright (c) 2013 Yan Rabovik. All rights reserved.
//

#import "INDExtension.h"

#define independence_inject_with_blocks(args...) \
+(NSArray *)independence_inject_with_blocks{ \
    __unsafe_unretained id objs[]= {args}; \
    NSArray *propertiesBlocksPairs = \
        [INDUtils \
         constructPropertiesBlocksArrayFromPairs:objs \
         count:sizeof(objs)/sizeof(id)]; \
    return [INDUtils \
            appendAnnotationsArrayForClass:self \
            toArray:propertiesBlocksPairs \
            selector:@selector(independence_inject_with_blocks)]; \
}

@interface INDUtils (InjectWithBlocks)
+(NSArray *)constructPropertiesBlocksArrayFromPairs:(__unsafe_unretained id[])pairs
                                              count:(NSUInteger)count;
@end

@interface INDInjectWithBlockExtension : INDExtension

@end
