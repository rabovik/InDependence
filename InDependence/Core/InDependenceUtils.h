//
//  RSInjectorUtils.h
//  InDependence
//
//  Created by Yan Rabovik on 27.02.13.
//  Copyright (c) 2013 Yan Rabovik. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>

extern NSString *const InDependenceException;

typedef enum {
    RSInjectorTypeClass,
    RSInjectorTypeProtocol
} RSInjectorType;

typedef struct rsinjector_property_info {
    void *value;
    RSInjectorType type;
} RSInjectorPropertyInfo;

@interface InDependenceUtils : NSObject

+(NSString *)key:(id)classOrProtocol;

+(BOOL)isInstructionRequiredForClass:(Class)klass selector:(SEL)selector;

+(id)requirementObjectForClass:(Class)klass selector:(SEL)selector;

+(NSSet *)requirementsSetForClass:(Class)klass selector:(SEL)selector;
+(NSSet *)unionRequirementsSetForClass:(Class)klass withSet:(NSSet *)requirements selector:(SEL)selector;

+(RSInjectorPropertyInfo)classOrProtocolForProperty:(objc_property_t)property;

+(objc_property_t)getProperty:(NSString *)propertyName fromClass:(Class)klass;

+(id)buildObjectWithInitializer:(Class)klass initializer:(SEL)initializer arguments:(NSArray *)arguments;

+(NSArray*)transformVariadicArgsToArray:(va_list)va_arguments;

@end
