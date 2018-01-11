//
//  VVNodeCreater.h
//  VirtualView
//
//  Copyright (c) 2017-2018 Alibaba. All rights reserved.
//

#import <Foundation/Foundation.h>

@class VVPropertySetter;

/**
 VVNodeCreater's struct is similar with XML struct.
 It is used for creating a node tree with one call.
 
 VVNodeCreater 的结构和 XML 的结构十分类似。
 它是用来一键创建一个 node 树的。
 */
@interface VVNodeCreater : NSObject

@property (nonatomic, assign) short nodeID;
@property (nonatomic, strong, nonnull) NSMutableArray<VVPropertySetter *> *propertySetters;

@property (nonatomic, strong, nonnull) NSMutableArray<VVNodeCreater *> *subCreaters;

@end
