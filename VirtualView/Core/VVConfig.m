//
//  VVConfig.m
//  VirtualView
//
//  Copyright (c) 2017-2018 Alibaba. All rights reserved.
//

#import "VVConfig.h"
#ifdef VV_ALIBABA
#import "Orange.h"
#endif

@interface VVConfig ()

@property (nonatomic, assign) CGFloat pointRatio;
@property (nonatomic, assign) BOOL alwaysRefresh;

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
#ifdef VV_ALIBABA
        NSString *alwaysRefreshConfig = [Orange getConfigByGroupName:@"tangram" key:@"vv_forceRefresh" defaultConfig:nil isDefault:nil];
        _alwaysRefresh = [alwaysRefreshConfig integerValue] != 0;
#endif
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

+ (BOOL)alwaysRefresh
{
    return [self sharedConfig].alwaysRefresh;
}

+ (void)setAlwaysRefresh:(BOOL)alwaysRefresh
{
    [self sharedConfig].alwaysRefresh = alwaysRefresh;
}

@end
