//
//  VVPropertyStringSetter.h
//  VirtualView
//
//  Copyright (c) 2017-2018 Alibaba. All rights reserved.
//

#import "VVPropertySetter.h"

@interface VVPropertyStringSetter : VVPropertySetter

@property (nonatomic, copy, readonly, nullable) NSString *value;

/**
 Make and return a string setter for normal string.
 Make and return an expression setter for expression string.
 Expression string starts with "@{" or @"${".

 @param key    Property key.
 @param value  Property value.
 @return       A string setter or a string expression setter.
 */
+ (nonnull VVPropertySetter *)setterWithPropertyKey:(int)key stringValue:(nullable NSString *)value;

@end
