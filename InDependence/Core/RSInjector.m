//
//  RSInjector.m
//  InDependence
//
//  Created by Yan Rabovik on 26.02.13.
//  Copyright (c) 2013 Yan Rabovik. All rights reserved.
//

#import "RSInjector.h"
#import <objc/runtime.h>
#import "RSInjectorBindingEntry.h"
#import "RSInjectorSession.h"

#import "RSInjectorCustomInitializerExtension.h"
#import "RSInjectorSingletonExtension.h"

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

+(void)registerExtensions:(RSInjectorExtension *)first, ... NS_REQUIRES_NIL_TERMINATION{
    va_list extensions;
    [self registerExtension:first];
    va_start(extensions, first);
    RSInjectorExtension *extension;
    while ((extension = va_arg( extensions, RSInjectorExtension *) )) {
        [self registerExtension:extension];
    }
    va_end(extensions);
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

    gExtensions = [NSMutableArray new];
    
    [self registerDefaultExtensions];
}

+(void)registerDefaultExtensions{
    [self registerExtensions:
        [RSInjectorCustomInitializerExtension new],
        [RSInjectorSingletonExtension new],
        nil
     ];
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

#pragma mark - Bindings
-(RSInjectorBindingEntry *)getBinding:(id)classOrProtocol{
    NSString *key = [RSInjectorUtils key:classOrProtocol];
    RSInjectorBindingEntry *binding = [_bindings objectForKey:key];
    if (!binding) {
        binding = [RSInjectorBindingEntry new];
        [_bindings setObject:binding forKey:key];
    }
    return binding;
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
    
    Class resolvedClass = [self.lastExtension resolveClass:klass];
    
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
        [session notifyObjectsThatTheyAreReady];
    }
    
    return objectUnderConstruction;
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
    // todo
}

#pragma mark - Bindings

-(void)bindClass:(Class)aClass toClass:(Class)toClass{
    // todo
}


@end
