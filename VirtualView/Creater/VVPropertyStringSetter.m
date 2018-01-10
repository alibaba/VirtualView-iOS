//
//  VVPropertyStringSetter.m
//  VirtualView
//
//  Copyright (c) 2017-2018 Alibaba. All rights reserved.
//

#import "VVPropertyStringSetter.h"

@implementation VVPropertyStringSetter

+ (instancetype)setterWithPropertyKey:(int)key stringValue:(NSString *)value
{
    VVPropertyStringSetter *setter = [[self alloc] initWithPropertyKey:key];
    setter.value = value;
    return setter;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"<%@: %p; key = %d; value = %@>", self.class, self, self.key, self.value];
}

- (void)applyToNode:(VVViewObject *)node
{
    [node setStringValue:self.value forKey:self.key];
}

@end
