//
//  VVPropertyFloatSetter.h
//  VirtualView
//
//  Copyright (c) 2017-2018 Alibaba. All rights reserved.
//

#import "VVPropertySetter.h"

@interface VVPropertyFloatSetter : VVPropertySetter

@property (nonatomic, assign, readonly) CGFloat value;

+ (nonnull VVPropertyFloatSetter *)setterWithPropertyKey:(int)key floatValue:(CGFloat)value;

@end
