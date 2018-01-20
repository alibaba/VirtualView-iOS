//
//  VVSystemKey.m
//  VirtualView
//
//  Copyright (c) 2017-2018 Alibaba. All rights reserved.
//

#import "VVSystemKey.h"
#import <UIKit/UIKit.h>
#import "VVNodeClassMapper.h"
#import "VVConfig.h"

@implementation VVSystemKey

+ (VVSystemKey *)shareInstance
{
    static VVSystemKey* _shareInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _shareInstance = [[VVSystemKey alloc] init];
    });
    return _shareInstance;
}

- (void)setRate:(CGFloat)rate
{
    VVConfig.pointRatio = rate;
}

- (CGFloat)rate
{
    return VVConfig.pointRatio;
}

@end
