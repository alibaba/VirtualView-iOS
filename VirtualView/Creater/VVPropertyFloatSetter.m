//
//  VVPropertyFloatSetter.m
//  VirtualView
//
//  Copyright (c) 2017-2018 Alibaba. All rights reserved.
//

#import "VVPropertyFloatSetter.h"

@implementation VVPropertyFloatSetter

+ (instancetype)setterWithPropertyKey:(int)key floatValue:(CGFloat)value
{
    VVPropertyFloatSetter *setter = [[self alloc] initWithPropertyKey:key];
    setter.value = value;
    return setter;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"<%@: %p; name = %@; value = %f>", self.class, self, self.name, self.value];
}

- (void)applyToNode:(VVViewObject *)node
{
    [node setFloatValue:self.value forKey:self.key];
}

@end
