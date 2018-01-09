//
//  VVLayer.h
//  VirtualView
//
//  Copyright (c) 2017-2018 Alibaba. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>

@interface VVLayer : CALayer

@property (nonatomic, assign) CGFloat vv_borderRadius;
@property (nonatomic, assign) CGFloat vv_borderTopLeftRadius;
@property (nonatomic, assign) CGFloat vv_borderTopRightRadius;
@property (nonatomic, assign) CGFloat vv_borderBottomLeftRadius;
@property (nonatomic, assign) CGFloat vv_borderBottomRightRadius;
@property (nonatomic, assign) CGFloat vv_borderWidth;
@property (nonatomic, strong) UIColor *vv_borderColor;
@property (nonatomic, strong) UIColor *vv_backgroundColor;

@end
