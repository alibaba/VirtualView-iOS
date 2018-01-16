//
//  VVPropertyIntSetter.m
//  VirtualView
//
//  Copyright (c) 2017-2018 Alibaba. All rights reserved.
//

#import "VVPropertyIntSetter.h"

@implementation VVPropertyIntSetter

+ (instancetype)setterWithPropertyKey:(int)key intValue:(int)value
{
    VVPropertyIntSetter *setter = [[self alloc] initWithPropertyKey:key];
    setter.value = value;
    return setter;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"<%@: %p; name = %@; value = %d>", self.class, self, self.name, self.value];
}

- (void)applyToNode:(VVViewObject *)node
{
    [node setIntValue:self.value forKey:self.key];
}

@end
