//
//  RSInjectorRegistrationEntry.h
//  InDependence
//
//  Created by Yan Rabovik on 27.02.13.
//  Copyright (c) 2013 Yan Rabovik. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface InDependenceBindingEntry : NSObject

-(void)setObject:(id)object forKey:(NSString *)aKey;
-(id)objectForKey:(NSString *)key;

@property (nonatomic,unsafe_unretained) Class bindedClass;

@end
