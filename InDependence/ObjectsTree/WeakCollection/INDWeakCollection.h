//
//  INDWeakCollection.h
//  InDependence
//
//  Created by Yan Rabovik on 21.03.13.
//  Copyright (c) 2013 Yan Rabovik. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface INDWeakObjectContainer : NSObject
@property (nonatomic,weak) id object;
@end

@interface INDWeakCollection : NSObject

-(void)addObject:(id)object;
-(NSSet *)allObjects;

@end
