//
//  VVPropertyStringSetter.h
//  VirtualView
//
//  Copyright (c) 2017-2018 Alibaba. All rights reserved.
//

#import "VVPropertySetter.h"

@interface VVPropertyStringSetter : VVPropertySetter

@property (nonatomic, strong, nullable) NSString *value;

+ (nonnull instancetype)setterWithPropertyKey:(int)key stringValue:(nullable NSString *)value;

@end
