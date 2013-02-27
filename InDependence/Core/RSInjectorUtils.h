//
//  RSInjectorUtils.h
//  InDependence
//
//  Created by Yan Rabovik on 27.02.13.
//  Copyright (c) 2013 Yan Rabovik. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RSInjectorUtils : NSObject

+(NSSet *)collectRequirementsForClass:(id)klass requirements:(NSSet *)requirements selector:(SEL)selector;

@end
