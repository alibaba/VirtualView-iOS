//
//  VVConfig.m
//  VirtualView
//
//  Copyright (c) 2017-2018 Alibaba. All rights reserved.
//

#import "VVConfig.h"

@interface VVConfig ()

@property (nonatomic, assign) CGFloat pointRatio;

@end

@implementation VVConfig

+ (VVConfig *)sharedConfig
{
    static VVConfig *_sharedConfig;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedConfig = [VVConfig new];
    });
    return _sharedConfig;
}

- (instancetype)init
{
    if (self = [super init]) {
        _pointRatio = [UIScreen mainScreen].bounds.size.width / 750;
    }
    return self;
}

+ (CGFloat)pointRatio
{
    return [self sharedConfig].pointRatio;
}

+ (void)setPointRatio:(CGFloat)pointRatio
{
    [self sharedConfig].pointRatio = pointRatio;
}

@end
