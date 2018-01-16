//
//  VVPropertySetter.m
//  VirtualView
//
//  Copyright (c) 2017-2018 Alibaba. All rights reserved.
//

#import "VVPropertySetter.h"
#import "VVSystemKey.h"

@implementation VVPropertySetter

- (instancetype)initWithPropertyKey:(int)key
{
    if (self = [super init]) {
        _key = key;
        _name = [[VVSystemKey shareInstance].keyDictionary objectForKey:[NSString stringWithFormat:@"%d", key]];
    }
    return self;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"<%@: %p; name = %@>", self.class, self, self.name];
}

- (void)applyToNode:(VVViewObject *)node
{
    // Override me.
}

@end
