//
//  VVLineLayer.h
//  VirtualView
//
//  Copyright (c) 2017-2018 Alibaba. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

@interface VVLineLayer : CALayer

@property (nonatomic, strong, nullable) UIColor *vv_lineColor;
@property (nonatomic, assign) CGFloat vv_lineWidth;

@end
