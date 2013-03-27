//
//  INDInjectWithFactoryBlockExtension.m
//  InDependence
//
//  Created by Yan Rabovik on 27.03.13.
//  Copyright (c) 2013 Yan Rabovik. All rights reserved.
//

#import "InDependence.h"
#import "INDInjectWithBlocksExtension.h"

@interface INDPropertyBlockPair : NSObject
@property (nonatomic,copy) NSString *propertyName;
@property (nonatomic,copy) id block;
@end

@implementation INDUtils (InjectWithBlocks)

+(NSArray *)constructPropertiesBlocksArrayFromPairs:(__unsafe_unretained id[])pairs
                                              count:(NSUInteger)count
{
    if (1 == count % 2) {
        @throw [NSException
                exceptionWithName:INDException
                reason:[NSString
                        stringWithFormat:@"Unable to construct array. Keys plus blocks count is not even."]
                userInfo:nil];
    }
    NSMutableArray *pbArray = [NSMutableArray arrayWithCapacity:count/2];
    for (NSUInteger i = 0; i<count; i+=2) {
        NSString *key = pairs[i];
        if (![key isKindOfClass:[NSString class]]) {
            @throw [NSException
                    exceptionWithName:INDException
                    reason:@"Unable to construct array. Key is not a NSString instance!"
                    userInfo:nil];
        }
        id block = pairs[i+1];
        INDPropertyBlockPair *pair = [INDPropertyBlockPair new];
        pair.propertyName = key;
        pair.block = block;
        [pbArray addObject:pair];
    }
    return pbArray;
}

@end

@implementation INDInjectWithBlocksExtension

-(void)injectRequirements:(NSSet *)_properties
                 toObject:(id)object
                  session:(INDSession*)session
                     info:(NSDictionary *)info
{
    [super injectRequirements:_properties
                     toObject:object
                      session:session
                         info:info];
    // Requirements
    NSArray *properties = [INDUtils
                           annotationsArrayForClass:[object class]
                           selector:@selector(independence_inject_with_blocks)];
}

@end
