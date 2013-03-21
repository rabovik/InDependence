//
//  NSObject+INDObjectsTree.h
//  InDependence
//
//  Created by Yan Rabovik on 21.03.13.
//  Copyright (c) 2013 Yan Rabovik. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (INDObjectsTree)

-(void)ind_addChild:(id)child;

@property (nonatomic,weak) id ind_parent;
@property (nonatomic,readonly) NSSet *ind_childs;
@property (nonatomic,readonly) id ind_root;

@end
