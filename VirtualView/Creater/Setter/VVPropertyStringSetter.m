//
//  VVPropertyStringSetter.m
//  VirtualView
//
//  Copyright (c) 2017-2018 Alibaba. All rights reserved.
//

#import "VVPropertyStringSetter.h"
#import "VVPropertyExpressionSetter.h"

@interface VVPropertyStringSetter ()

@property (nonatomic, copy, readwrite) NSString *value;

@end

@implementation VVPropertyStringSetter

+ (VVPropertySetter *)setterWithPropertyKey:(int)key stringValue:(NSString *)value
{
    VVPropertyExpressionSetter *expressionSetter = [VVPropertyExpressionSetter setterWithPropertyKey:key expressionString:value];
    if (expressionSetter) {
        return expressionSetter;
    }
    VVPropertyStringSetter *setter = [[self alloc] initWithPropertyKey:key];
    setter.value = value;
    return setter;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"<%@: %p; name = %@; value = %@>", self.class, self, self.name, self.value];
}

- (void)applyToNode:(VVBaseNode *)node
{
    [node setStringValue:self.value forKey:self.key];
}

@end
