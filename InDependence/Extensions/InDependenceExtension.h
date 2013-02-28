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

-(Class)resolveClass:(id)classOrProtocol;

-(id)createObjectOfClass:(Class)resolvedClass
                injector:(InDependenceInjector*)injector
                 session:(InDependenceSession*)session
               ancestors:(NSArray *)ancestors
                    info:(NSDictionary *)info;

@end

@interface InDependenceExtension : NSObject <InDependenceExtensionDelegate>
@property (nonatomic,weak) id<InDependenceExtensionDelegate> delegate;
@end
