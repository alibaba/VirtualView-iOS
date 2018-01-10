//
//  VVPropertyColorSetter.h
//  VirtualView
//
//  Copyright (c) 2017-2018 Alibaba. All rights reserved.
//

#import "VVPropertySetter.h"

@interface VVPropertyColorSetter : VVPropertySetter

@property (nonatomic, strong, nullable) UIColor *value;

+ (nonnull instancetype)setterWithPropertyKey:(int)key colorValue:(nullable UIColor *)value;

@end
