//
//  RSInjectorExtension.h
//  InDependence
//
//  Created by Yan Rabovik on 27.02.13.
//  Copyright (c) 2013 Yan Rabovik. All rights reserved.
//

#import <Foundation/Foundation.h>

@class InDependenceInjector,InDependenceSession;

@protocol InDependenceExtensionDelegate <NSObject>

-(Class)resolveClass:(id)classOrProtocol
             session:(InDependenceSession*)session
           ancestors:(NSArray *)ancestors
                info:(NSDictionary *)info;

-(id)createObjectOfClass:(Class)resolvedClass
                 session:(InDependenceSession*)session
               ancestors:(NSArray *)ancestors
                    info:(NSDictionary *)info;

@end

@interface InDependenceExtension : NSObject <InDependenceExtensionDelegate>
@property (nonatomic,weak) id<InDependenceExtensionDelegate> delegate;
@property (nonatomic,weak) InDependenceInjector *injector;
@end
