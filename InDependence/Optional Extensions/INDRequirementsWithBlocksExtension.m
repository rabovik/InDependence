//
//  INDInjectWithFactoryBlockExtension.m
//  InDependence
//
//  Created by Yan Rabovik on 27.03.13.
//  Copyright (c) 2013 Yan Rabovik. All rights reserved.
//

#import "InDependence.h"
#import "INDRequirementsWithBlocksExtension.h"
#import "NSObject+INDObjectsTree.h"
#import "INDSession.h"

@interface INDPropertyBlockPair : NSObject
@property (nonatomic,copy) NSString *propertyName;
@property (nonatomic,copy) INDRequirementsFactoryBlock block;
@end

@implementation INDPropertyBlockPair
@end

@implementation INDUtils (RequirementsWithBlocks)

+(NSArray *)constructPropertiesBlocksArrayFromPairs:(__strong id[])pairs
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

@implementation INDRequirementsWithBlocksExtension

-(void)injectRequirements:(NSSet *)properties
                 toObject:(NSObject *)object
                  session:(INDSession*)session
                     info:(NSDictionary *)info
{
    [super injectRequirements:properties
                     toObject:object
                      session:session
                         info:info];
    NSArray *pairs = [INDUtils
                      annotationsArrayForClass:[object class]
                      selector:@selector(independence_requirements_with_blocks)];
    for (INDPropertyBlockPair *pair in pairs){
        // construct
        NSObject *objectUnderConstruction = pair.block(object,self.injector);
        // build tree
        if (nil == objectUnderConstruction.ind_parent) {
            [object ind_addChild:objectUnderConstruction];
        }
        [session registerInstantiatedObject:objectUnderConstruction];
        // inject
        [object setValue:objectUnderConstruction forKey:pair.propertyName];
    }
}

@end
