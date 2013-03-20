//
//  RSInjector.m
//  InDependence
//
//  Created by Yan Rabovik on 26.02.13.
//  Copyright (c) 2013 Yan Rabovik. All rights reserved.
//

#import "INDInjector.h"
#import <objc/runtime.h>
#import "INDModule.h"
#import "INDSession.h"
#import "INDUtils.h"

#import "INDCustomInitializerExtension.h"
#import "INDSingletonExtension.h"
#import "INDReferencesExtension.h"

static NSMutableArray *gExtensions;
static INDInjector *gSharedInjector;

@interface INDInjector () <INDExtensionDelegate>
@property (nonatomic,readonly) id<INDExtensionDelegate> lastExtension;
@end

@implementation INDInjector{
    NSMutableDictionary *_bindings;
    NSMutableArray *_extensions;
    NSMutableArray *_modules;
}

#pragma mark - Extensions
+(void)registerExtensionClass:(Class)extensionClass{
    if (![extensionClass isSubclassOfClass:[INDExtension class]]) {
        @throw [NSException
                exceptionWithName:INDException
                reason:[NSString
                        stringWithFormat:
                        @"Can not register %@ extension because it is not a subclass of INDExtension",
                        NSStringFromClass(extensionClass)]
                userInfo:nil];
    }
    [gExtensions addObject:extensionClass];
}

-(id<INDExtensionDelegate>)lastExtension{
    if (_extensions.count == 0) {
        return self;
    }else{
        return [_extensions lastObject];
    }
}

#pragma mark - Initializing

+(void)initialize  {
    if (self != [INDInjector class]) return;

    gExtensions = [NSMutableArray new];
    
    [self registerDefaultExtensions];
}

+(void)registerDefaultExtensions{
    [self registerExtensionClass:[INDCustomInitializerExtension class]];
    [self registerExtensionClass:[INDSingletonExtension class]];
    [self registerExtensionClass:[INDReferencesExtension class]];
}

-(id)init{
    self = [super init];
    if (!self) return nil;

    _bindings = [NSMutableDictionary new];
    
    _extensions = [NSMutableArray new];
    for (Class extensionClass in gExtensions) {
        INDExtension *extension = [self getObject:extensionClass];
        id delegate = [_extensions lastObject];
        if (nil == delegate) {
            delegate = self;
        }
        extension.delegate = delegate;
        extension.injector = self;
        [_extensions addObject:extension];
    }
    
    _modules = [NSMutableArray new];
        
    return self;
}

+(INDInjector *)sharedInjector{
    @synchronized(self){
        if (nil == gSharedInjector) {
            gSharedInjector = [self createInjector];
        }
    }
    return gSharedInjector;
}

+(INDInjector *)createInjector{
    return [[self class] new];
}

+(void)setSharedInjector:(INDInjector *)injector{
    @synchronized(self) {
        if (gSharedInjector != injector) {
            gSharedInjector = injector;
        }
    }
}

#pragma mark - Object Factory
-(id)getObject:(id)classOrProtocol{
    return [self getObject:classOrProtocol session:nil ancestors:nil info:nil];
}

-(id)getObject:(id)classOrProtocol
       session:(INDSession *)session
     ancestors:(NSArray *)ancestors
          info:(NSDictionary *)info
{
    @synchronized(self){
        BOOL isRootObjectInSession = NO;
        if (nil == session) {
            isRootObjectInSession = YES;
            session = [INDSession new];
        }
        
        // 1. Resolve class
        Class resolvedClass =
        [self.lastExtension resolveClass:classOrProtocol
                                 session:session
                               ancestors:ancestors
                                    info:info];
        
        // 2. Construct object
        id objectUnderConstruction =
        [self.lastExtension createObjectOfClass:resolvedClass
                                        session:session
                                      ancestors:ancestors
                                           info:info];
        
        [session registerInstantiatedObject:objectUnderConstruction];
        
        // 3. Satisfy requirements
        NSSet *properties = [INDUtils
                             requirementsSetForClass:classOrProtocol
                             selector:@selector(independence_requirements)];
        if (properties) {
            NSMutableDictionary *propertiesDictionary =
            [NSMutableDictionary dictionaryWithCapacity:properties.count];
            NSMutableArray *ancestorsForProperties =
            [NSMutableArray arrayWithArray:ancestors];
            [ancestorsForProperties addObject:objectUnderConstruction];
            
            for (NSString *propertyName in properties) {
                objc_property_t property = [INDUtils
                                            getProperty:propertyName
                                            fromClass:classOrProtocol];
                INDPropertyInfo propertyInfo =
                [INDUtils classOrProtocolForProperty:property];
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
            [objectUnderConstruction
             setValuesForKeysWithDictionary:propertiesDictionary];
        }
        
        // 4. Notify objects
        if (isRootObjectInSession) {
            [session notifyObjectsThatTheyAreReady];
        }
        
        return objectUnderConstruction;
    }
}

#pragma mark └ extension delegate
-(Class)resolveClass:(id)classOrProtocol
             session:(INDSession*)session
           ancestors:(NSArray *)ancestors
                info:(NSDictionary *)info
{
    BOOL isClass = class_isMetaClass(object_getClass(classOrProtocol));
    
    Class bindedClass = [self bindingForKey:INDBindedClassKey
                            classOrProtocol:classOrProtocol];
    if (bindedClass) {
        Class resolvedClass = bindedClass;
        if (isClass && resolvedClass != classOrProtocol) {
            return [self resolveClass:resolvedClass
                              session:session
                            ancestors:ancestors
                                 info:info];
        }
        return resolvedClass;
    }

    if (isClass) {
        return classOrProtocol;
    }
    
    @throw [NSException
            exceptionWithName:INDException
            reason:[NSString
                    stringWithFormat:@"Unable to find class for protocol: <%@>",
                    NSStringFromProtocol(classOrProtocol)]
            userInfo:nil];
}

-(id)createObjectOfClass:(Class)resolvedClass
                 session:(INDSession*)session
               ancestors:(NSArray *)ancestors
                    info:(NSDictionary *)info
{    
    return [resolvedClass new];
}

#pragma mark - Modules
-(void)addModule:(INDModule *)module{
    @synchronized(self){
        [_modules addObject:module];
        module.injector = self;
        [module configure];
    }
}

-(void)removeModule:(INDModule *)module{
    @synchronized(self){
        module.injector = nil;
        [_modules removeObject:module];
    }
}

-(void)removeModuleOfClass:(Class)moduleClass{
    @synchronized(self){
        NSArray *currentModules = [_modules copy];
        for (INDModule *module in currentModules) {
            if ([module isKindOfClass:moduleClass]) {
                [self removeModule:module];
            }
        }
    }
}

#pragma mark - Bindings
-(id)bindingForKey:(NSString *)key classOrProtocol:(id)classOrProtocol{
    for (INDModule *module in _modules) {
        id binding = [module bindingForKey:key classOrProtocol:classOrProtocol];
        if (binding) {
            return binding;
        }
    }
    return nil;
}

@end
