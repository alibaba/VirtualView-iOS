//
//  VVPropertySetter.h
//  VirtualView
//
//  Copyright (c) 2017-2018 Alibaba. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VVBaseNode.h"

/**
 This is a base class for all PropertySetter. DO NOT use it directly.
 Please use the sub class of it.
 PropertySetter can save 'property => value' key-value-pair.
 It is used for setting a property with one call.
 
 这是所有 PropertySetter 类的基类，请不要直接使用。请使用它的子类。
 PropertySetter 可以存储 'property => value' 的键值对。
 它是用于一键设置对象属性的。
 */
@interface VVPropertySetter : NSObject

@property (nonatomic, assign, readonly) int key;
@property (nonatomic, strong, readonly, nullable) NSString *name;

- (nonnull instancetype)initWithPropertyKey:(int)key;

/**
 If this setter is an expression setter.
 For expression setter, you should implement and use "applyToNode:withDict:".
 Default value is NO, subclass must override this method to return YES.

 @return  YES for expression setter.
 */
- (BOOL)isExpression;
- (void)applyToNode:(nullable VVBaseNode *)node;
- (void)applyToNode:(nullable VVBaseNode *)node withDict:(nullable NSDictionary *)dict;


@end
