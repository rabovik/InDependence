//
//  INDWeakCollection.m
//  InDependence
//
//  Created by Yan Rabovik on 21.03.13.
//  Copyright (c) 2013 Yan Rabovik. All rights reserved.
//

#import "INDWeakCollection.h"

@interface INDWeakObjectContainer : NSObject
@property (nonatomic,weak) id object;
@end

@implementation INDWeakObjectContainer
@end


@implementation INDWeakCollection{
    NSMutableSet *_containers;
}

#pragma mark - Init
-(id)init{
    if (!(self = [super init])) return self;
    
	_containers = [NSMutableSet new];
    
	return self;
}

-(void)addObject:(id)object{
    @synchronized(self){
        INDWeakObjectContainer *container = [INDWeakObjectContainer new];
        container.object = object;
        [_containers addObject:container];
    }
}

-(NSSet *)allObjects{
    @synchronized(self){
        NSMutableSet *objectsSet = [NSMutableSet setWithCapacity:_containers.count];
        NSSet *containersSet = [NSSet setWithSet:_containers];
        for (INDWeakObjectContainer *container in containersSet) {
            id object = container.object;
            if (object) {
                [objectsSet addObject:object];
            }else{
                [_containers removeObject:container];
            }
        }
        return objectsSet;
    }
}

#ifdef DEBUG
-(NSNumber *)_containersCount{
    return @(_containers.count);
}
#endif

@end
