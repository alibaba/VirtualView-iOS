//
//  VVPropertySetter.h
//  VirtualView
//
//  Copyright (c) 2017-2018 Alibaba. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VVViewObject.h"

/**
 This is a base class for all PropertySetter. DO NOT use it directly.
 Please use the sub class of it.
 PropertySetter can save 'property => value' key-value-pair.
 It is used for setting a property with one call.
 
 PropertySetter 可以存储 'property => value' 的键值对。
 它是用于一键设置对象属性的。
 */
@interface VVPropertySetter : NSObject

@property (nonatomic, assign, readonly) int key;

- (nonnull instancetype)initWithPropertyKey:(int)key;
- (void)applyToNode:(nullable VVViewObject *)node;

@end
