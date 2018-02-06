//
//  VVLayout.m
//  VirtualView
//
//  Copyright (c) 2017-2018 Alibaba. All rights reserved.
//

#import "VVLayout.h"
#import "UIColor+VirtualView.h"

@interface VVLayout () {
    VVLayer *_privateLayer;
}

@end

@implementation VVLayout

- (id)init{
    self = [super init];
    if (self) {
        self.borderColor=[UIColor clearColor];
        self.backgroundColor=[UIColor clearColor];
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

- (BOOL)setStringDataValue:(NSString*)value forKey:(int)key{
    BOOL ret = true;
    switch (key) {
        case STR_ID_onClick:
            break;
        case STR_ID_borderColor:
           self.borderColor = [UIColor vv_colorWithString:value];
            break;

        case STR_ID_background:
            self.backgroundColor = [UIColor vv_colorWithString:value];
            
        default:
            ret = false;
    }
    return ret;
}

- (void)setNodeFrame:(CGRect)frame
{
    [super setNodeFrame:frame];
    if (self.drawLayer) {
        self.drawLayer.bounds=CGRectMake(0, 0, frame.size.width, frame.size.height);
        self.drawLayer.anchorPoint=CGPointMake(0,0);
        self.drawLayer.position=CGPointMake(frame.origin.x,frame.origin.y);
        [self.drawLayer setNeedsDisplay];
    }
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

- (void)setBackgroundColor:(UIColor *)backgroundColor
{
    [super setBackgroundColor:backgroundColor];
    _privateLayer.vv_backgroundColor = backgroundColor;
    if (self.drawLayer) {
        [self.drawLayer setNeedsDisplay];
    }
}

- (void)setBorderColor:(UIColor *)borderColor
{
    _borderColor = borderColor;
    _privateLayer.vv_borderColor = borderColor;
    if (self.drawLayer) {
        [self.drawLayer setNeedsDisplay];
    }
}

- (BOOL)setIntValue:(int)value forKey:(int)key{
    BOOL ret = [ super setIntValue:value forKey:key];
    
    if (!ret) {
        ret = true;
        switch (key) {
            case STR_ID_borderWidth:
                _privateLayer.vv_borderWidth = value;
                break;
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
            case STR_ID_borderColor:
                self.borderColor = [UIColor vv_colorWithARGB:(NSUInteger)value];
                break;
            default:
                ret = false;
                break;
        }
    }
    return ret;
}

- (BOOL)setFloatValue:(float)value forKey:(int)key{
    BOOL ret = [ super setFloatValue:value forKey:key];
    
    if (!ret) {
        ret = true;
        switch (key) {
            case STR_ID_borderWidth:
                _privateLayer.vv_borderWidth = value;
                break;
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
                ret = false;
                break;
        }
    }
    return ret;
}

@end
