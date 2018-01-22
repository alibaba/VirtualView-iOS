//
//  VVPropertyIntSetter.h
//  VirtualView
//
//  Copyright (c) 2017-2018 Alibaba. All rights reserved.
//

#import "VVPropertySetter.h"

@interface VVPropertyIntSetter : VVPropertySetter

@property (nonatomic, assign, readonly) int value;

+ (nonnull VVPropertySetter *)setterWithPropertyKey:(int)key intValue:(int)value;

@end
