//
//  VVNodeCreater.m
//  VirtualView
//
//  Copyright (c) 2017-2018 Alibaba. All rights reserved.
//

#import "VVNodeCreater.h"
#import "VVPropertySetter.h"
#import "VVViewObject.h"

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

- (VVViewObject *)createNodeTree
{
    Class class = NSClassFromString(self.nodeClassName);
    
#ifdef VV_DEBUG
    NSAssert(class != NULL, @"Does not match a class.");
#endif
    
    VVViewObject *node;
    if (class != NULL) {
        node = [class new];
    } else {
        node = [VVViewObject new];
    }
    
    for (VVPropertySetter *setter in self.propertySetters) {
        [setter applyToNode:node];
    }
    
    for (VVNodeCreater *creater in self.subCreaters) {
        VVViewObject *subNode = [creater createNodeTree];
        [node addSubview:subNode];
    }
    
    return node;
}

@end
