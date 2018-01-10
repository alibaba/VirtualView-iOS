//
//  VVNodeCreater.h
//  VirtualView
//
//  Copyright (c) 2017-2018 Alibaba. All rights reserved.
//

#import <Foundation/Foundation.h>

@class VVPropertySetter;

@interface VVNodeCreater : NSObject

@property (nonatomic, assign) short nodeId;
@property (nonatomic, strong, nonnull) NSMutableArray<VVPropertySetter *> *propertySetters;

@property (nonatomic, strong, nonnull) NSMutableArray<VVNodeCreater *> *subCreaters;

@end
