//
//  RSInjectorUtils.h
//  InDependence
//
//  Created by Yan Rabovik on 27.02.13.
//  Copyright (c) 2013 Yan Rabovik. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>

typedef enum {
    RSInjectorTypeClass,
    RSInjectorTypeProtocol
} RSInjectorType;

typedef struct rsinjector_property_info {
    void *value;
    RSInjectorType type;
} RSInjectorPropertyInfo;

@interface RSInjectorUtils : NSObject

+(NSSet *)requirementsForClass:(Class)klass selector:(SEL)selector;
+(NSSet *)collectRequirementsForClass:(Class)klass requirements:(NSSet *)requirements selector:(SEL)selector;

+(RSInjectorPropertyInfo)classOrProtocolForProperty:(objc_property_t)property;

+(objc_property_t)getProperty:(NSString *)propertyName fromClass:(Class)klass;

@end
