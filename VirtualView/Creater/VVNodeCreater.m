//
//  VVNodeCreater.m
//  VirtualView
//
//  Copyright (c) 2017-2018 Alibaba. All rights reserved.
//

#import "VVNodeCreater.h"
#import "VVPropertySetter.h"
#import "VVBaseNode.h"

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

- (VVBaseNode *)createNodeTree
{
    Class class = NSClassFromString(self.nodeClassName);
    
#ifdef VV_DEBUG
    NSAssert(class != NULL, @"Does not match a class.");
#endif
    
    VVBaseNode *node;
    if (class != NULL) {
        node = [class new];
    } else {
        node = [VVBaseNode new];
    }
    
    for (VVPropertySetter *setter in self.propertySetters) {
        if ([setter isExpression] == NO) {
            [setter applyToNode:node];
        } else {
            [node.expressionSetters setObject:setter forKey:setter.name];
        }
    }
    
    for (VVNodeCreater *creater in self.subCreaters) {
        VVBaseNode *subNode = [creater createNodeTree];
        [node addSubview:subNode];
    }
    
    return node;
}

@end
