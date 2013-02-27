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
#import "RSInjectorSession.h"
#import "RSInjectorSingletonExtension.h"

typedef id(^InstantiatorBlock)(void);

static NSMutableDictionary *gRegistrationContext;
static NSMutableArray *gExtensions;

@interface RSInjector () <RSInjectorExtensionDelegate>
@property (nonatomic,readonly) id<RSInjectorExtensionDelegate> lastExtension;
@end

@implementation RSInjector{
    NSMutableDictionary *_bindings;
}

#pragma mark - Extensions
+(void)registerExtension:(RSInjectorExtension *)extension{
    extension.delegate = [gExtensions lastObject];
    [gExtensions addObject:extension];
}

-(id<RSInjectorExtensionDelegate>)lastExtension{
    if (gExtensions.count == 0) {
        return self;
    }else{
        return [gExtensions lastObject];
    }
}

#pragma mark - Init

+ (void)initialize  {
    if (self != [RSInjector class]) return;

    gRegistrationContext = [NSMutableDictionary new];
    gExtensions = [NSMutableArray new];
    
    [self registerDefaultExtensions];
}

+(void)registerDefaultExtensions{
    [self registerExtension:[RSInjectorSingletonExtension new]];
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
        if (gExtensions.count > 0) {
            RSInjectorExtension *firstExtension = [gExtensions objectAtIndex:0];
            firstExtension.delegate = sharedInstance;
        }
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
    return [self getObject:klass session:nil ancestors:[NSArray array]];
}

-(id)getObject:(id)klass session:(RSInjectorSession *)session ancestors:(NSArray *)ancestors{
    NSLog(@"GET OBJECT class %@. ANCESTORS %@",klass,ancestors);
    
    BOOL isRootObjectInSession = NO;
    if (nil == session) {
        isRootObjectInSession = YES;
        session = [RSInjectorSession new];
    }
    
    //[[self class] registerClass:klass];
    
    Class resolvedClass = [self desiredClassForClass:klass];
    
    id objectUnderConstruction = [self.lastExtension createObjectOfClass:resolvedClass
                                                                injector:self
                                                                 session:session
                                                               ancestors:ancestors];
    
    NSSet *properties = [RSInjectorUtils requirementsForClass:klass selector:@selector(rs_requires)];
    if (properties) {
        NSMutableDictionary *propertiesDictionary = [NSMutableDictionary dictionaryWithCapacity:properties.count];
        NSMutableArray *ancestorsForProperties = [NSMutableArray arrayWithArray:ancestors];
        [ancestorsForProperties addObject:objectUnderConstruction];

        for (NSString *propertyName in properties) {
            objc_property_t property = [RSInjectorUtils getProperty:propertyName fromClass:klass];
            RSInjectorPropertyInfo propertyInfo = [RSInjectorUtils classOrProtocolForProperty:property];
            id desiredClassOrProtocol = (__bridge id)(propertyInfo.value);
            
            id theObject = [self getObject:desiredClassOrProtocol session:session ancestors:ancestorsForProperties];
            
            if (nil == theObject) {
                theObject = [NSNull null];
            }
            
            [propertiesDictionary setObject:theObject forKey:propertyName];
        }
        [objectUnderConstruction setValuesForKeysWithDictionary:propertiesDictionary];
    }
    
    [session registerInstantiatedObject:objectUnderConstruction];
    
    if (isRootObjectInSession) {
        NSLog(@"ROOT OBJECT INSTANTIATED. objects = %@",session.instantiatedObjects);
    }
    
    return objectUnderConstruction;
}

-(Class)desiredClassForClass:(id)klass{
    return klass;
}

#pragma mark - Extension delegate

-(Class)resolveClass:(id)classOrProtocol{
    return classOrProtocol;
    //return [self.delegate resolveClass:classOrProtocol];
}

-(id)createObjectOfClass:(Class)resolvedClass
                injector:(RSInjector*)injector
                 session:(RSInjectorSession*)session
               ancestors:(NSArray *)ancestors{
    
    return [resolvedClass new];
}

-(void)informObjectsCreatedInSessionThatTheyAreReady{
    
    //[self.delegate informObjectsCreatedInSessionThatTheyAreReady];
}

#pragma mark - Bindings

-(void)bindClass:(Class)aClass toClass:(Class)toClass{
    NSString *key = NSStringFromClass(toClass);
    NSString *val = NSStringFromClass(aClass);
    [_bindings setObject:val forKey:key];
}


@end
