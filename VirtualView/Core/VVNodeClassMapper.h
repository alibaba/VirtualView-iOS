//
//  VVNodeClassMapper.h
//  VirtualView
//
//  Copyright (c) 2017-2018 Alibaba. All rights reserved.
//

#import <Foundation/Foundation.h>

// Internal supported node list.
#define VV_NODE_ID_FrameLayout    1
#define VV_NODE_ID_VHLayout       2
#define VV_NODE_ID_VH2Layout      3
#define VV_NODE_ID_GridLayout     4
#define VV_NODE_ID_RatioLayout    6
#define VV_NODE_ID_NativeText     7
#define VV_NODE_ID_VirtualText    8
#define VV_NODE_ID_NativeImage    9
#define VV_NODE_ID_VirtualImage   10
#define VV_NODE_ID_NativeLine     13
#define VV_NODE_ID_VirtualLine    14
#define VV_NODE_ID_Page           16
#define VV_NODE_ID_Grid           17
#define VV_NODE_TYPE_FrameLayout  @"FrameLayout"
#define VV_NODE_TYPE_VHLayout     @"VHLayout"
#define VV_NODE_TYPE_VH2Layout    @"VH2Layout"
#define VV_NODE_TYPE_GridLayout   @"GridLayout"
#define VV_NODE_TYPE_RatioLayout  @"RatioLayout"
#define VV_NODE_TYPE_NativeText   @"NativeText"
#define VV_NODE_TYPE_VirtualText  @"VirtualText"
#define VV_NODE_TYPE_NativeImage  @"NativeImage"
#define VV_NODE_TYPE_VirtualImage @"VirtualImage"
#define VV_NODE_TYPE_NativeLine   @"NativeLine"
#define VV_NODE_TYPE_VirtualLine  @"VirtualLine"
#define VV_NODE_TYPE_Page         @"Page"
#define VV_NODE_TYPE_Grid         @"Grid"

@interface VVNodeClassMapper : NSObject

+ (nullable NSString *)classNameForID:(short)nodeID;
+ (void)registerClassName:(nonnull NSString *)className forID:(short)nodeID;
+ (nullable NSString *)classNameForType:(nonnull NSString *)type;
+ (void)registerClassName:(nonnull NSString *)className forType:(nonnull NSString *)type;

@end
