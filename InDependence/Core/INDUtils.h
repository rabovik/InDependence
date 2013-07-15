//
//  RSInjectorUtils.h
//  InDependence
//
//  Created by Yan Rabovik on 27.02.13.
//  Copyright (c) 2013 Yan Rabovik. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>

#define INDThrow(desc, ...) \
    @throw [NSException \
            exceptionWithName:@"INDException" \
            reason:[NSString stringWithFormat:(desc), ##__VA_ARGS__] \
            userInfo:nil]

#define INDAssert(condition, desc, ...) \
    do{ \
        if (!(condition)){ \
            INDThrow((desc), ##__VA_ARGS__); \
        } \
    } while(0)

@interface INDUtils : NSObject

+(NSString *)key:(id)classOrProtocol;

+(BOOL)isInstructionRequiredForClass:(Class)klass selector:(SEL)selector;

+(id)requirementObjectForClass:(Class)klass selector:(SEL)selector;

+(NSArray *)annotationsArrayForClass:(Class)klass selector:(SEL)selector;
+(NSArray *)appendAnnotationsArrayForClass:(Class)klass
                                   toArray:(NSArray *)annotations
                                  selector:(SEL)selector;

+(NSSet *)requirementsSetForClass:(Class)klass selector:(SEL)selector;
+(NSSet *)unionRequirementsSetForClass:(Class)klass
                               withSet:(NSSet *)requirements
                              selector:(SEL)selector;

+(BOOL)propertyIsWeak:(objc_property_t)property;
+(id)classOrProtocolForProperty:(objc_property_t)property;

+(objc_property_t)getProperty:(NSString *)propertyName fromClass:(Class)klass;

+(id)buildObjectWithInitializer:(Class)klass
                    initializer:(SEL)initializer
                      arguments:(NSArray *)arguments
             isClassInitializer:(BOOL)isClassInitializer;

@end
