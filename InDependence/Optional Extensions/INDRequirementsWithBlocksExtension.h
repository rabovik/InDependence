//
//  INDInjectWithFactoryBlockExtension.h
//  InDependence
//
//  Created by Yan Rabovik on 27.03.13.
//  Copyright (c) 2013 Yan Rabovik. All rights reserved.
//

#import "INDExtension.h"

typedef id(^INDRequirementsFactoryBlock)(id self,INDInjector *injector);

#define independence_requirements_with_blocks(keyBlockPairs...) \
+(NSArray *)independence_requirements_with_blocks{ \
    __strong id objs[]= {keyBlockPairs}; \
    NSArray *propertiesBlocksPairs = \
        [INDUtils \
         constructPropertiesBlocksArrayFromPairs:objs \
         count:sizeof(objs)/sizeof(id)]; \
    return [INDUtils \
            appendAnnotationsArrayForClass:self \
            toArray:propertiesBlocksPairs \
            selector:@selector(independence_requirements_with_blocks)]; \
}

@interface INDUtils (RequirementsWithBlocks)
+(NSArray *)constructPropertiesBlocksArrayFromPairs:(__strong id[])pairs
                                              count:(NSUInteger)count;
@end

@interface INDRequirementsWithBlocksExtension : INDExtension

@end
