//
//  InDependenceAncestorsExtension.m
//  InDependence
//
//  Created by Yan Rabovik on 28.02.13.
//  Copyright (c) 2013 Yan Rabovik. All rights reserved.
//

#import "InDependenceAncestorsExtension.h"
#import "InDependenceUtils.h"

@implementation InDependenceAncestorsExtension

-(id)createObjectOfClass:(Class)resolvedClass injector:(InDependenceInjector *)injector session:(InDependenceSession *)session ancestors:(NSArray *)ancestors info:(NSDictionary *)info{
    id createdObject = [super createObjectOfClass:resolvedClass
                                         injector:injector session:session ancestors:ancestors info:info];
    
    NSSet *properties = [InDependenceUtils requirementsSetForClass:resolvedClass
                                                          selector:@selector(independence_requires_ancestors)];
    if (properties) {
        NSMutableDictionary *propertiesDictionary = [NSMutableDictionary dictionaryWithCapacity:properties.count];        
        for (NSString *propertyName in properties) {
            objc_property_t property = [InDependenceUtils getProperty:propertyName fromClass:resolvedClass];
            RSInjectorPropertyInfo propertyInfo = [InDependenceUtils classOrProtocolForProperty:property];
            id desiredClassOrProtocol = (__bridge id)(propertyInfo.value);
            
            NSString *attributes = [NSString stringWithCString: property_getAttributes(property) encoding: NSASCIIStringEncoding];


            NSLog(@"ANCESTOR PROP %@ DESIRED %@ Attr %@",propertyName,[InDependenceUtils key:desiredClassOrProtocol],attributes);
            
            /*
            id theObject = [self getObject:desiredClassOrProtocol
                                   session:session
                                 ancestors:ancestorsForProperties
                                      info:nil];
            
            if (nil == theObject) {
                theObject = [NSNull null];
            }
             */
            
            //[propertiesDictionary setObject:theObject forKey:propertyName];
        }
        //[objectUnderConstruction setValuesForKeysWithDictionary:propertiesDictionary];
    }
    
    return createdObject;
}

@end
