//
//  VVViewFactory.m
//  VirtualView
//
//  Copyright (c) 2017-2018 Alibaba. All rights reserved.
//

#import "VVViewFactory.h"

@implementation VVViewFactory

+ (VVViewFactory *)shareFactoryInstance
{
    static VVViewFactory *shareFactory_;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareFactory_ = [VVViewFactory new];
    });
    return shareFactory_;
}

- (VVViewContainer *)obtainVirtualWithKey:(NSString *)key
{
    return [VVViewContainer viewContainerWithTemplateType:key];
}

@end
