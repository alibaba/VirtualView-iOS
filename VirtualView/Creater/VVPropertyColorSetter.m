//
//  VVPropertyColorSetter.m
//  VirtualView
//
//  Copyright (c) 2017-2018 Alibaba. All rights reserved.
//

#import "VVPropertyColorSetter.h"

@implementation VVPropertyColorSetter

+ (instancetype)setterWithPropertyKey:(int)key colorValue:(UIColor *)value
{
    VVPropertyColorSetter *setter = [[self alloc] initWithPropertyKey:key];
    setter.value = value;
    return setter;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"<%@: %p; key = %d; value = %@>", self.class, self, self.key, self.value];
}

- (void)applyToNode:(VVViewObject *)node
{
#warning TODO: Need to add implementation.
}

@end
