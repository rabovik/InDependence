//
//  RSInjectorSession.m
//  InDependence
//
//  Created by Yan Rabovik on 27.02.13.
//  Copyright (c) 2013 Yan Rabovik. All rights reserved.
//

#import "INDSession.h"
#import "INDDeprecatedAPI.h"

@interface NSObject ()
-(void)ind_awakeFromInjector;
@end

@implementation INDSession{
    NSMutableArray *_instantiatedObjects;
}

-(id)init{
	self = [super init];
	if (nil == self) return nil;
    
	_instantiatedObjects = [NSMutableArray new];
    
	return self;
}


-(void)registerInstantiatedObject:(id)object{
    [_instantiatedObjects addObject:object];
}

-(NSArray *)allObjects{
    return _instantiatedObjects;
}

-(void)notifyObjectsThatTheyAreReady{    
    for (id object in [_instantiatedObjects reverseObjectEnumerator]) {
        SEL selector = @selector(ind_awakeFromInjector);
        if([object respondsToSelector:selector]) {
            [object ind_awakeFromInjector];
        }
#if _IND_THROW_ON_AWAKE_FROM_INJECTOR
        if([object respondsToSelector:@selector(awakeFromInjector)]) {
            INDThrow(@"'awakeFromInjector' is deprecated. Use 'ind_awakeFromInjector' instead.");
        }
#endif
    }
}



@end
