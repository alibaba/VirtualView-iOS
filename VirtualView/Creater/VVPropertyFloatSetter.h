//
//  VVPropertyFloatSetter.h
//  VirtualView
//
//  Copyright (c) 2017-2018 Alibaba. All rights reserved.
//

#import "VVPropertySetter.h"

@interface VVPropertyFloatSetter : VVPropertySetter

@property (nonatomic, assign) CGFloat value;

+ (nonnull instancetype)setterWithPropertyKey:(int)key floatValue:(CGFloat)value;

@end
