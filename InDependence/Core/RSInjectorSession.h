//
//  RSInjectorSession.h
//  InDependence
//
//  Created by Yan Rabovik on 27.02.13.
//  Copyright (c) 2013 Yan Rabovik. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RSInjectorSession : NSObject

-(void)registerInstantiatedObject:(id)object;
-(void)notifyObjectsThatTheyAreReady;
//@property (nonatomic,readonly) NSArray *instantiatedObjects;

@end
