//
//  NVLineView.m
//  VirtualView
//
//  Copyright (c) 2017-2018 Alibaba. All rights reserved.
//

#import "NVLineView.h"
#import "UIColor+VirtualView.h"

@interface NVLineView ()

@property (nonatomic, strong, readwrite) UIView *cocoaView;

@end

@implementation NVLineView

@synthesize cocoaView = _cocoaView;

- (id)init
{
    if (self = [super init]) {
        _cocoaView = [[UIView alloc] init];
        _cocoaView.backgroundColor = [UIColor clearColor];
        _orientation = VVOrientationHorizontal;
        _gravity = VVGravityDefault;
        _lineLayer = [[VVLineLayer alloc] init];
        _lineLayer.contentsScale = [[UIScreen mainScreen] scale];
        [_cocoaView.layer addSublayer:_lineLayer];
    }
    return self;
}

- (void)setRootCocoaView:(UIView *)rootCocoaView
{
    if (self.cocoaView.superview !=  rootCocoaView) {
        if (self.cocoaView.superview) {
            [self.cocoaView removeFromSuperview];
        }
        [rootCocoaView addSubview:self.cocoaView];
    }
    [super setRootCocoaView:rootCocoaView];
}

- (void)setBackgroundColor:(UIColor *)backgroundColor
{
    [super setBackgroundColor:backgroundColor];
    self.cocoaView.backgroundColor = backgroundColor;
}

- (BOOL)setIntValue:(int)value forKey:(int)key
{
    BOOL ret = [super setIntValue:value forKey:key];
    if (!ret) {
        ret = YES;
        switch (key) {
            case STR_ID_color:
                _lineLayer.vv_lineColor = [UIColor vv_colorWithARGB:(NSUInteger)value];
                break;
            case STR_ID_orientation:
                self.orientation = value;
                break;
            case STR_ID_gravity:
                self.gravity = value;
                break;
            case STR_ID_style:
//                self.style = value;
                break;
            default:
                ret = NO;
                break;
        }
    }
    return ret;
}

- (BOOL)setFloatValue:(float)value forKey:(int)key
{
    BOOL ret = [super setFloatValue:value forKey:key];
    if (!ret) {
        ret = YES;
        switch (key) {
            case STR_ID_paintWidth:
                _lineLayer.vv_lineWidth = value;
                break;
            default:
                ret = NO;
                break;
        }
    }
    return ret;
}

- (BOOL)setStringValue:(NSString *)value forKey:(int)key
{
    BOOL ret = [super setStringValue:value forKey:key];
    if (!ret) {
        ret = YES;
        switch (key) {
            case STR_ID_dashEffect:
//                self.dashEffect = value;
                break;
            default:
                ret = NO;
                break;
        }
    }
    return ret;
}

- (BOOL)setStringData:(NSString*)data forKey:(int)key
{
    BOOL ret = YES;
    switch (key) {
        case STR_ID_color:
            _lineLayer.vv_lineColor = [UIColor vv_colorWithString:data] ?: [UIColor blackColor];
            break;
        default:
            ret = NO;
            break;
    }
    return ret;
}

- (void)layoutSubNodes
{
    CGSize lineSize;
    CGFloat lineX, lineY;
    if (_orientation == VVOrientationVertical) {
        lineSize = CGSizeMake(_lineLayer.vv_lineWidth, self.nodeHeight - self.paddingTop - self.paddingBottom);
        lineY = self.paddingTop;
        if (self.gravity & VVGravityHCenter) {
            CGFloat midX = (self.nodeWidth + self.paddingLeft - self.paddingRight) / 2;
            lineX = midX - lineSize.width / 2;
        } else if (self.gravity & VVGravityRight) {
            lineX = self.nodeWidth - self.paddingRight - lineSize.width;
        } else {
            lineX = self.paddingLeft;
        }
    } else {
        lineSize = CGSizeMake(self.nodeWidth - self.paddingLeft - self.paddingRight, _lineLayer.vv_lineWidth);
        lineX = self.paddingLeft;
        if (self.gravity & VVGravityVCenter) {
            CGFloat midY = (self.nodeHeight + self.paddingTop - self.paddingBottom) / 2;
            lineY = midY - lineSize.height;
        } else if (self.gravity & VVGravityBottom) {
            lineY = self.nodeHeight - self.paddingBottom - lineSize.height;
        } else {
            lineY = self.paddingTop;
        }
    }
    _lineLayer.frame = CGRectMake(lineX, lineY, lineSize.width, lineSize.height);
}

@end
