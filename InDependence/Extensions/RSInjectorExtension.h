//
//  RSInjectorExtension.h
//  InDependence
//
//  Created by Yan Rabovik on 27.02.13.
//  Copyright (c) 2013 Yan Rabovik. All rights reserved.
//

#import <Foundation/Foundation.h>

@class RSInjector,RSInjectorSession;

@protocol RSInjectorExtensionDelegate <NSObject>

-(Class)resolveClass:(id)classOrProtocol;

-(id)createObjectOfClass:(Class)resolvedClass
                injector:(RSInjector*)injector
                 session:(RSInjectorSession*)session
               ancestors:(NSArray *)ancestors;

-(void)informObjectsCreatedInSessionThatTheyAreReady;

@end

@interface RSInjectorExtension : NSObject <RSInjectorExtensionDelegate>
@property (nonatomic,weak) id<RSInjectorExtensionDelegate> delegate;
@end
