//
//  RSInjector.m
//  InDependence
//
//  Created by Yan Rabovik on 26.02.13.
//  Copyright (c) 2013 Yan Rabovik. All rights reserved.
//

#import "InDependenceInjector.h"
#import <objc/runtime.h>
#import "InDependenceBindingEntry.h"
#import "InDependenceSession.h"
#import "InDependenceUtils.h"

#import "InDependenceCustomInitializerExtension.h"
#import "InDependenceSingletonExtension.h"

static NSMutableArray *gExtensions;
static InDependenceInjector *gSharedInjector;

@interface InDependenceInjector () <InDependenceExtensionDelegate>
@property (nonatomic,readonly) id<InDependenceExtensionDelegate> lastExtension;
@end

@implementation InDependenceInjector{
    NSMutableDictionary *_bindings;
}

#pragma mark - Extensions
+(void)registerExtension:(InDependenceExtension *)extension{
    extension.delegate = [gExtensions lastObject];
    [gExtensions addObject:extension];
}

+(void)registerExtensions:(InDependenceExtension *)first, ... NS_REQUIRES_NIL_TERMINATION{
    va_list extensions;
    [self registerExtension:first];
    va_start(extensions, first);
    InDependenceExtension *extension;
    while ((extension = va_arg( extensions, InDependenceExtension *) )) {
        [self registerExtension:extension];
    }
    va_end(extensions);
}

-(id<InDependenceExtensionDelegate>)lastExtension{
    if (gExtensions.count == 0) {
        return self;
    }else{
        return [gExtensions lastObject];
    }
}

#pragma mark - Initializing

+(void)initialize  {
    if (self != [InDependenceInjector class]) return;

    gExtensions = [NSMutableArray new];
    
    [self registerDefaultExtensions];
}

+(void)registerDefaultExtensions{
    [self registerExtensions:
        [InDependenceCustomInitializerExtension new],
        [InDependenceSingletonExtension new],
        nil
     ];
}

- (id)init{
    self = [super init];
    if (!self) return nil;
    
    _bindings = [NSMutableDictionary new];
    
    return self;
}

+(InDependenceInjector *)sharedInjector{
    @synchronized(self) {
        if (nil == gSharedInjector) {
            [self setDefaultInjector:[[self class] new]];
        }
    }
    return gSharedInjector;
}

+(void)setDefaultInjector:(InDependenceInjector *)injector{
    @synchronized(self) {
        if (gSharedInjector != injector) {
            gSharedInjector = injector;
            if (gExtensions.count > 0) {
                InDependenceExtension *firstExtension = [gExtensions objectAtIndex:0];
                firstExtension.delegate = gSharedInjector;
            }
        }
    }
}

#pragma mark - Object Factory
-(id)getObject:(id)klass{
    return [self getObject:klass session:nil ancestors:nil info:nil];
}

-(id)getObject:(id)classOrProtocol
       session:(InDependenceSession *)session
     ancestors:(NSArray *)ancestors
          info:(NSDictionary *)info{
    //NSLog(@"GET OBJECT class %@. ANCESTORS %@",classOrProtocol,ancestors);
    
    BOOL isRootObjectInSession = NO;
    if (nil == session) {
        isRootObjectInSession = YES;
        session = [InDependenceSession new];
    }
    
    Class resolvedClass = [self.lastExtension resolveClass:classOrProtocol];
    
    id objectUnderConstruction = [self.lastExtension createObjectOfClass:resolvedClass
                                                                injector:self
                                                                 session:session
                                                               ancestors:ancestors
                                                                    info:info];
    
    NSSet *properties = [InDependenceUtils requirementsSetForClass:classOrProtocol selector:@selector(independence_requires)];
    if (properties) {
        NSMutableDictionary *propertiesDictionary = [NSMutableDictionary dictionaryWithCapacity:properties.count];
        NSMutableArray *ancestorsForProperties = [NSMutableArray arrayWithArray:ancestors];
        [ancestorsForProperties addObject:objectUnderConstruction];

        for (NSString *propertyName in properties) {
            objc_property_t property = [InDependenceUtils getProperty:propertyName fromClass:classOrProtocol];
            RSInjectorPropertyInfo propertyInfo = [InDependenceUtils classOrProtocolForProperty:property];
            id desiredClassOrProtocol = (__bridge id)(propertyInfo.value);
            
            id theObject = [self getObject:desiredClassOrProtocol
                                   session:session
                                 ancestors:ancestorsForProperties
                                      info:nil];
            
            if (nil == theObject) {
                theObject = [NSNull null];
            }
            
            [propertiesDictionary setObject:theObject forKey:propertyName];
        }
        [objectUnderConstruction setValuesForKeysWithDictionary:propertiesDictionary];
    }
    
    [session registerInstantiatedObject:objectUnderConstruction];
    
    if (isRootObjectInSession) {
        [session notifyObjectsThatTheyAreReady];
    }
    
    return objectUnderConstruction;
}

#pragma mark Extension delegate
-(Class)resolveClass:(id)classOrProtocol{
    return classOrProtocol;
    //return [self.delegate resolveClass:classOrProtocol];
}

-(id)createObjectOfClass:(Class)resolvedClass
                injector:(InDependenceInjector*)injector
                 session:(InDependenceSession*)session
               ancestors:(NSArray *)ancestors
                    info:(NSDictionary *)info{
    
    return [resolvedClass new];
}

#pragma mark - Bindings
-(InDependenceBindingEntry *)getBinding:(id)classOrProtocol{
    NSString *key = [InDependenceUtils key:classOrProtocol];
    InDependenceBindingEntry *binding = [_bindings objectForKey:key];
    if (!binding) {
        binding = [InDependenceBindingEntry new];
        [_bindings setObject:binding forKey:key];
    }
    return binding;
}

-(void)bindClass:(Class)aClass toClass:(Class)toClass{
    // todo
}


@end
