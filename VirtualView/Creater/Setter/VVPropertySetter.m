//
//  VVPropertySetter.m
//  VirtualView
//
//  Copyright (c) 2017-2018 Alibaba. All rights reserved.
//

#import "VVPropertySetter.h"
#import "VVBinarySringMapper.h"

@implementation VVPropertySetter

- (instancetype)initWithPropertyKey:(int)key
{
    if (self = [super init]) {
        _key = key;
        _name = [VVBinarySringMapper stringForKey:key];
    }
    return self;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"<%@: %p; name = %@>", self.class, self, self.name];
}

- (BOOL)isExpression
{
    return NO;
}

- (void)applyToNode:(VVBaseNode *)node
{
    // override me
    if ([self isExpression] == YES) {
        [self applyToNode:node withDict:nil];
    }
}

- (void)applyToNode:(VVBaseNode *)node withDict:(NSDictionary *)dict
{
    // override me
    if ([self isExpression] == NO) {
        [self applyToNode:node];
    }
}

@end
