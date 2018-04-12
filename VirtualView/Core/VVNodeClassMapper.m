//
//  VVNodeClassMapper.m
//  VirtualView
//
//  Copyright (c) 2017-2018 Alibaba. All rights reserved.
//

#import "VVNodeClassMapper.h"

@interface VVNodeClassMapper ()

@property (nonatomic, strong) NSMutableDictionary *mapperDict;

@end

@implementation VVNodeClassMapper

+ (VVNodeClassMapper *)sharedMapper
{
    static VVNodeClassMapper *_sharedMapper;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedMapper = [VVNodeClassMapper new];
    });
    return _sharedMapper;
}

- (instancetype)init
{
    if (self = [super init]) {
        _mapperDict = [NSMutableDictionary dictionary];
        [_mapperDict setObject:@"VVFrameLayout" forKey:@(VV_NODE_ID_FrameLayout)];
        [_mapperDict setObject:@"VVVHLayout" forKey:@(VV_NODE_ID_VHLayout)];
        [_mapperDict setObject:@"VVVH2Layout" forKey:@(VV_NODE_ID_VH2Layout)];
        [_mapperDict setObject:@"VVGridLayout" forKey:@(VV_NODE_ID_GridLayout)];
        [_mapperDict setObject:@"VVRatioLayout" forKey:@(VV_NODE_ID_RatioLayout)];
        [_mapperDict setObject:@"NVTextView" forKey:@(VV_NODE_ID_NativeText)];
        [_mapperDict setObject:@"NVTextView" forKey:@(VV_NODE_ID_VirtualText)];
        [_mapperDict setObject:@"NVImageView" forKey:@(VV_NODE_ID_NativeImage)];
        [_mapperDict setObject:@"NVImageView" forKey:@(VV_NODE_ID_VirtualImage)];
        [_mapperDict setObject:@"NVLineView" forKey:@(VV_NODE_ID_NativeLine)];
        [_mapperDict setObject:@"NVLineView" forKey:@(VV_NODE_ID_VirtualLine)];
        [_mapperDict setObject:@"VVPageView" forKey:@(VV_NODE_ID_Page)];
        [_mapperDict setObject:@"VVGridView" forKey:@(VV_NODE_ID_Grid)];
        [_mapperDict setObject:@"NVFrameLayout" forKey:@(VV_NODE_ID_NFrameLayout)];
        [_mapperDict setObject:@"NVVHLayout" forKey:@(VV_NODE_ID_NVHLayout)];
        [_mapperDict setObject:@"NVVH2Layout" forKey:@(VV_NODE_ID_NVH2Layout)];
        [_mapperDict setObject:@"NVGridLayout" forKey:@(VV_NODE_ID_NGridLayout)];
        [_mapperDict setObject:@"NVRatioLayout" forKey:@(VV_NODE_ID_NRatioLayout)];
        [_mapperDict setObject:@"VVFrameLayout" forKey:VV_NODE_TYPE_FrameLayout];
        [_mapperDict setObject:@"VVVHLayout" forKey:VV_NODE_TYPE_VHLayout];
        [_mapperDict setObject:@"VVVH2Layout" forKey:VV_NODE_TYPE_VH2Layout];
        [_mapperDict setObject:@"VVGridLayout" forKey:VV_NODE_TYPE_GridLayout];
        [_mapperDict setObject:@"VVRatioLayout" forKey:VV_NODE_TYPE_RatioLayout];
        [_mapperDict setObject:@"NVTextView" forKey:VV_NODE_TYPE_NativeText];
        [_mapperDict setObject:@"NVTextView" forKey:VV_NODE_TYPE_VirtualText];
        [_mapperDict setObject:@"NVImageView" forKey:VV_NODE_TYPE_NativeImage];
        [_mapperDict setObject:@"NVImageView" forKey:VV_NODE_TYPE_VirtualImage];
        [_mapperDict setObject:@"NVLineView" forKey:VV_NODE_TYPE_NativeLine];
        [_mapperDict setObject:@"NVLineView" forKey:VV_NODE_TYPE_VirtualLine];
        [_mapperDict setObject:@"VVPageView" forKey:VV_NODE_TYPE_Page];
        [_mapperDict setObject:@"VVGridView" forKey:VV_NODE_TYPE_Grid];
        [_mapperDict setObject:@"NVFrameLayout" forKey:VV_NODE_TYPE_NFrameLayout];
        [_mapperDict setObject:@"NVVHLayout" forKey:VV_NODE_TYPE_NVHLayout];
        [_mapperDict setObject:@"NVVH2Layout" forKey:VV_NODE_TYPE_NVH2Layout];
        [_mapperDict setObject:@"NVGridLayout" forKey:VV_NODE_TYPE_NGridLayout];
        [_mapperDict setObject:@"NVRatioLayout" forKey:VV_NODE_TYPE_NRatioLayout];
#ifdef VV_ALIBABA
        [_mapperDict setObject:@"TMNVImageView" forKey:@(11)];
        [_mapperDict setObject:@"TMNVImageView" forKey:@(12)];
        [_mapperDict setObject:@"NVTextView" forKey:@(1001)];
        [_mapperDict setObject:@"TMVVRecommendSubView" forKey:@(1003)];
        [_mapperDict setObject:@"TMVVRecommendImageView" forKey:@(1005)];
        [_mapperDict setObject:@"TMVVRecommendBenefitView" forKey:@(1008)];
        [_mapperDict setObject:@"TMVVRecommendPriceView" forKey:@(1009)];
        [_mapperDict setObject:@"VVNavtiveViewContainer" forKey:@(1010)];
        [_mapperDict setObject:@"TMVVSelectedRecommendMagicStick" forKey:@(1011)];
        [_mapperDict setObject:@"TMVVSelectedCountDown" forKey:@(1012)];
        [_mapperDict setObject:@"TMVVVideoView" forKey:@(1014)];
        [_mapperDict setObject:@"TMVVVideoView" forKey:@"TMMediaPlayerContainer"];
        [_mapperDict setObject:@"TMVVVideoView" forKey:@"TMPlayableContainer"];
        [_mapperDict setObject:@"TMVVSelectedBrandAnimtionView" forKey:@"TMBrandWallItemView"];
#endif
    }
    return self;
}

+ (NSString *)classNameForID:(short)nodeID
{
    if (nodeID > 0) {
        return [[VVNodeClassMapper sharedMapper].mapperDict objectForKey:@(nodeID)];
    }
    return nil;
}

+ (void)registerClassName:(NSString *)className forID:(short)nodeID
{
    if (className && className.length > 0 && nodeID > 0) {
        [[VVNodeClassMapper sharedMapper].mapperDict setObject:className forKey:@(nodeID)];
    }
}

+ (NSString *)classNameForType:(NSString *)type
{
    if (type && type.length > 0) {
        return [[VVNodeClassMapper sharedMapper].mapperDict objectForKey:type];
    }
    return nil;
}

+ (void)registerClassName:(NSString *)className forType:(NSString *)type
{
    if (className && className.length > 0 && type && type.length > 0) {
        [[VVNodeClassMapper sharedMapper].mapperDict setObject:className forKey:type];
    }
}

@end
