//
//  InDependenceModule.h
//  InDependence
//
//  Created by Yan Rabovik on 19.03.13.
//  Copyright (c) 2013 Yan Rabovik. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString *const INDBindedClassKey;

@class INDInjector;

@interface INDModule : NSObject

#pragma mark - Bindings storage
-(id)bindingForKey:(NSString *)key classOrProtocol:(id)classOrProtocol;
-(void)setBinding:(id)bindingEntry
           forKey:(NSString *)key
  classOrProtocol:(id)classOrProtocol;

#pragma mark - Class bindings
-(void)bindClass:(Class)aClass toClass:(Class)toClass;
-(void)bindClass:(Class)aClass toProtocol:(Protocol *)toProtocol;

#pragma mark - For overriding
-(void)configure;

#pragma mark - Properties
@property (nonatomic,weak) INDInjector *injector;

@end
