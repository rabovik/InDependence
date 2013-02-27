//
//  RSInjector.m
//  InDependence
//
//  Created by Yan Rabovik on 26.02.13.
//  Copyright (c) 2013 Yan Rabovik. All rights reserved.
//

#import "RSInjector.h"
#import <objc/runtime.h>
#import "RSInjectorRegistrationEntry.h"

typedef id(^InstantiatorBlock)(void);

static NSMutableDictionary *gRegistrationContext;

@implementation RSInjector{
    NSMutableDictionary *_bindings;
}

#pragma mark - Init

+ (void)initialize  {
    if (self == [RSInjector class]) {
        gRegistrationContext = [NSMutableDictionary new];
    }
}

- (id)init{
    self = [super init];
    if (!self) return nil;
    
    _bindings = [NSMutableDictionary new];
    
    return self;
}

+(id)sharedInjector{
    static dispatch_once_t once;
    static id sharedInstance;
    dispatch_once(&once, ^{
        sharedInstance = [[self class] new];
    });
    return sharedInstance;
}

#pragma mark - Registrations
+(void)registerClass:(id)klass{
    if (!klass) return;
    NSString *key = NSStringFromClass(klass);
    if ([gRegistrationContext objectForKey:key]) return;
    
    RSInjectorRegistrationEntry *entry = [RSInjectorRegistrationEntry new];
    //entry.klass = klass;
    [gRegistrationContext setObject:entry forKey:key];
    
    //entry.registeredProperties = [RSInjectorUtils requirementsForClass:klass selector:@selector(rs_requires)];
    
    NSLog(@"Registered class %@",klass/*,entry.registeredProperties*/);
    
    Class superClass = class_getSuperclass([klass class]);
    [self registerClass:superClass];
}

#pragma mark - Object factory
-(id)getObject:(id)klass{
    return [self getObject:klass ancestors:[NSArray new]];
}

-(id)getObject:(id)klass ancestors:(NSArray *)ancestors{
    NSLog(@"GET OBJECT class %@. ANCESTORS %@",klass,ancestors);
    
    //[[self class] registerClass:klass];
    
    Class desiredClass = [self desiredClassForClass:klass];
    
    id objectUnderConstruction = [desiredClass new];
    
    NSSet *properties = [RSInjectorUtils requirementsForClass:klass selector:@selector(rs_requires)];
    if (properties) {
        NSMutableDictionary *propertiesDictionary = [NSMutableDictionary dictionaryWithCapacity:properties.count];
        NSMutableArray *ancestorsForProperties = [NSMutableArray arrayWithArray:ancestors];
        [ancestorsForProperties addObject:objectUnderConstruction];

        for (NSString *propertyName in properties) {
            objc_property_t property = [RSInjectorUtils getProperty:propertyName fromClass:klass];
            RSInjectorPropertyInfo propertyInfo = [RSInjectorUtils classOrProtocolForProperty:property];
            id desiredClassOrProtocol = (__bridge id)(propertyInfo.value);
            
            id theObject = [self getObject:desiredClassOrProtocol ancestors:ancestorsForProperties];
            
            if (nil == theObject) {
                theObject = [NSNull null];
            }
            
            [propertiesDictionary setObject:theObject forKey:propertyName];
        }
        [objectUnderConstruction setValuesForKeysWithDictionary:propertiesDictionary];
    }
    
    return objectUnderConstruction;
}

-(Class)desiredClassForClass:(id)klass{
    return klass;
}

#pragma mark - Bindings

-(void)bindClass:(Class)aClass toClass:(Class)toClass{
    NSString *key = NSStringFromClass(toClass);
    NSString *val = NSStringFromClass(aClass);
    [_bindings setObject:val forKey:key];
}


@end
