//
//  RSInjector.h
//  InDependence
//
//  Created by Yan Rabovik on 26.02.13.
//  Copyright (c) 2013 Yan Rabovik. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RSInjector : NSObject

+(id)sharedInjector;

-(id)getObject:(id)klass;

-(void)bindClass:(Class)aClass toClass:(Class)toClass;

@end
