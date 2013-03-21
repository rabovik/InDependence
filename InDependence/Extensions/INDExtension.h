//
//  RSInjectorExtension.h
//  InDependence
//
//  Created by Yan Rabovik on 27.02.13.
//  Copyright (c) 2013 Yan Rabovik. All rights reserved.
//

#import <Foundation/Foundation.h>

@class INDInjector,INDSession;

@protocol INDExtensionDelegate <NSObject>

-(Class)resolveClass:(id)classOrProtocol
             session:(INDSession*)session
              parent:(id)parent
                info:(NSDictionary *)info;

-(id)createObjectOfClass:(Class)resolvedClass
                 session:(INDSession*)session
                  parent:(id)parent
                    info:(NSDictionary *)info;

@end

@interface INDExtension : NSObject <INDExtensionDelegate>
@property (nonatomic,weak) id<INDExtensionDelegate> delegate;
@property (nonatomic,weak) INDInjector *injector;
@end
