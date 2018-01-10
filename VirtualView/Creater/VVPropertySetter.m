//
//  VVPropertySetter.m
//  VirtualView
//
//  Copyright (c) 2017-2018 Alibaba. All rights reserved.
//

#import "VVPropertySetter.h"

@implementation VVPropertySetter

- (instancetype)initWithPropertyKey:(int)key
{
    if (self = [super init]) {
        _key = key;
    }
    return self;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"<%@: %p; key = %d>", self.class, self, self.key];
}

- (void)applyToNode:(VVViewObject *)node
{
    // Override me.
}

@end
