//
//  VVNodeCreater.m
//  VirtualView
//
//  Copyright (c) 2017-2018 Alibaba. All rights reserved.
//

#import "VVNodeCreater.h"
#import "VVPropertySetter.h"

@implementation VVNodeCreater

- (NSMutableArray<VVPropertySetter *> *)propertySetters
{
    if (!_propertySetters) {
        _propertySetters = [NSMutableArray array];
    }
    return _propertySetters;
}

- (NSMutableArray<VVNodeCreater *> *)subCreaters
{
    if (!_subCreaters) {
        _subCreaters = [NSMutableArray array];
    }
    return _subCreaters;
}

@end
