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
#import "NSObject+INDObjectsTree.h"

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
    INDAssert([extensionClass isSubclassOfClass:[INDExtension class]],
              @"Can not register %@ extension because it is not a subclass of INDExtension",
              NSStringFromClass(extensionClass));
    if (![gExtensions containsObject:extensionClass]) {
        [gExtensions addObject:extensionClass];
    }
}

+(void)unRegisterExtensionClass:(Class)extensionClass{
    [gExtensions removeObject:extensionClass];
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
        INDExtension *extension = [self getObject:extensionClass parent:self];
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
            gSharedInjector = [[self class] new];
        }
    }
    return gSharedInjector;
}

+(void)setSharedInjector:(INDInjector *)injector{
    @synchronized(self) {
        if (gSharedInjector != injector) {
            gSharedInjector = injector;
        }
    }
}

#pragma mark - Object Factory
+(id)getObject:(id)classOrProtocol parent:(id)parent{
    return [[[self class] sharedInjector] getObject:classOrProtocol parent:parent];
}

-(id)getObject:(id)classOrProtocol parent:(id)parent{
    return [self getObject:classOrProtocol session:nil parent:parent info:nil];
}

-(id)getObject:(id)classOrProtocol
       session:(INDSession *)session
        parent:(id)parent
          info:(NSDictionary *)info
{
    @synchronized(self){
        if (nil == session) {
            session = [INDSession new];
        }
        
        // Resolve class
        Class resolvedClass =
        [self.lastExtension resolveClass:classOrProtocol
                                 session:session
                                  parent:parent
                                    info:info];
        
        // Construct object
        NSObject *objectUnderConstruction =
        [self.lastExtension createObjectOfClass:resolvedClass
                                        session:session
                                         parent:parent
                                           info:info];
        
        // Build object tree
        if (nil == objectUnderConstruction.ind_parent) {
            if (nil != parent) {
                [parent ind_addChild:objectUnderConstruction];
            }else{
                [self ind_addChild:objectUnderConstruction];
            }
        }
        [session registerInstantiatedObject:objectUnderConstruction];
        
        // Satisfy requirements
        NSSet *properties = [INDUtils
                             requirementsSetForClass:classOrProtocol
                             selector:@selector(independence_requirements)];
        [self.lastExtension injectRequirements:properties
                                      toObject:objectUnderConstruction
                                       session:session
                                          info:info];
        
        // Notify objects
        if (nil == parent) {
            [self.lastExtension notifyObjectsInSession:session];
        }
        
        return objectUnderConstruction;
    }
}

#pragma mark └ extension delegate
-(Class)resolveClass:(id)classOrProtocol
             session:(INDSession*)session
              parent:(id)parent
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
                               parent:parent
                                 info:info];
        }
        return resolvedClass;
    }

    if (isClass) {
        return classOrProtocol;
    }
    
    INDThrow(@"Unable to find class for protocol: <%@>",
             NSStringFromProtocol(classOrProtocol));
}

-(id)createObjectOfClass:(Class)resolvedClass
                 session:(INDSession*)session
                  parent:(id)parent
                    info:(NSDictionary *)info
{    
    return [resolvedClass new];
}

-(void)injectRequirements:(NSSet *)properties
                 toObject:(id)object
                  session:(INDSession*)session
                     info:(NSDictionary *)info
{
    if (!properties) return;
    
    for (NSString *propertyName in properties) {
        objc_property_t property = [INDUtils getProperty:propertyName
                                               fromClass:[object class]];
        id desiredClassOrProtocol = [INDUtils
                                     classOrProtocolForProperty:property];
        id theObject = [self getObject:desiredClassOrProtocol
                               session:session
                                parent:object
                                  info:nil];
        [object setValue:theObject forKey:propertyName];
    }
}

-(void)notifyObjectsInSession:(INDSession *)session{
    [session notifyObjectsThatTheyAreReady];
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

-(NSArray *)modules{
    @synchronized(self){
        return [NSArray arrayWithArray:_modules];
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
