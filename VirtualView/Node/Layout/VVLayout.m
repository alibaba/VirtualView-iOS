//
//  VVLayout.m
//  VirtualView
//
//  Copyright (c) 2017-2018 Alibaba. All rights reserved.
//

#import "VVLayout.h"

@interface VVLayout () {
    VVLayer *_privateLayer;
}

@end

@implementation VVLayout

- (id)init
{
    self = [super init];
    if (self) {
        _privateLayer = [VVLayer layer];
    }
    return self;
}

- (void)dealloc
{
    _privateLayer.delegate = nil;
}

- (BOOL)needDrawLayer
{
    if (self.borderColor && [self.borderColor isEqual:[UIColor clearColor]] == NO) {
        return YES;
    }
    if ([self.expressionSetters.allKeys containsObject:@"borderColor"]) {
        return YES;
    }
    if (self.backgroundColor && [self.backgroundColor isEqual:[UIColor clearColor]] == NO) {
        return YES;
    }
    if ([self.expressionSetters.allKeys containsObject:@"background"]) {
        return YES;
    }
    return NO;
}

- (void)setRootCanvasLayer:(CALayer *)rootCanvasLayer
{
    if (self.drawLayer == nil && [self needDrawLayer]) {
        self.drawLayer = _privateLayer;
        self.drawLayer.drawsAsynchronously = YES;
        self.drawLayer.contentsScale = [[UIScreen mainScreen] scale];
    }
    if (self.drawLayer) {
        if (self.drawLayer.superlayer) {
            [self.drawLayer removeFromSuperlayer];
        }
        [rootCanvasLayer addSublayer:self.drawLayer];
    }
    [super setRootCanvasLayer:rootCanvasLayer];
}

- (void)updateFrame
{
    [super updateFrame];
    _privateLayer.frame = self.nodeFrame;
}

- (void)setVisibility:(VVVisibility)visibility
{
    [super setVisibility:visibility];
    _privateLayer.hidden = !(visibility == VVVisibilityVisible);
}

- (void)setBackgroundColor:(UIColor *)backgroundColor
{
    [super setBackgroundColor:backgroundColor];
    _privateLayer.vv_backgroundColor = backgroundColor;
}

- (void)setBorderColor:(UIColor *)borderColor
{
    [super setBorderColor:borderColor];
    _privateLayer.vv_borderColor = borderColor;
}

- (void)setBorderWidth:(CGFloat)borderWidth
{
    [super setBorderWidth:borderWidth];
    _privateLayer.vv_borderWidth = borderWidth;
}

- (BOOL)setFloatValue:(float)value forKey:(int)key
{
    BOOL ret = [super setFloatValue:value forKey:key];
    if (!ret) {
        ret = YES;
        switch (key) {
            case STR_ID_borderRadius:
                _privateLayer.vv_borderRadius = value;
                break;
            case STR_ID_borderTopLeftRadius:
                _privateLayer.vv_borderTopLeftRadius = value;
                break;
            case STR_ID_borderTopRightRadius:
                _privateLayer.vv_borderTopRightRadius = value;
                break;
            case STR_ID_borderBottomLeftRadius:
                _privateLayer.vv_borderBottomLeftRadius = value;
                break;
            case STR_ID_borderBottomRightRadius:
                _privateLayer.vv_borderBottomRightRadius = value;
                break;
            default:
                ret = NO;
                break;
        }
    }
    return ret;
}

@end
