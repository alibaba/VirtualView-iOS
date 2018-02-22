//
//  VVPropertySetter.m
//  VirtualView
//
//  Copyright (c) 2017-2018 Alibaba. All rights reserved.
//

#import "VVPropertySetter.h"
#import "VVBinaryStringMapper.h"

@implementation VVPropertySetter

- (instancetype)initWithPropertyKey:(int)key
{
    if (self = [super init]) {
        _key = key;
        _name = [VVBinaryStringMapper stringForKey:key];
        if (!_name) {
#ifdef VV_DEBUG
            NSLog(@"VVPropertySetter - Key does not match a string: %d", key);
#endif
            _name = [NSString stringWithFormat:@"%d", key];
        }
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
        [self applyToNode:node withObject:nil];
    }
}

- (void)applyToNode:(VVBaseNode *)node withObject:(nullable NSDictionary *)object
{
    // override me
    if ([self isExpression] == NO) {
        [self applyToNode:node];
    }
}

@end
