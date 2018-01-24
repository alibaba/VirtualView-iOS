//
//  VVLayout.m
//  VirtualView
//
//  Copyright (c) 2017-2018 Alibaba. All rights reserved.
//

#import "VVLayout.h"
#import "UIColor+VirtualView.h"

@implementation VVLayout
@synthesize frame = _frame;

- (id)init{
    self = [super init];
    if (self) {
        self.borderColor=[UIColor clearColor];
        self.backgroundColor=[UIColor clearColor];
    }
    return self;
}

- (void)dealloc
{
    if (self.drawLayer) {
        self.drawLayer.delegate = nil;
    }
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

- (void)drawRect:(CGRect)rect{
    for (VVBaseNode* item in self.subViews) {
        if(item.visible==VVVisibilityGone){
            continue;
        }
        [item drawRect:rect];
    }
}

- (void)setFrame:(CGRect)frame{
    _frame = frame;
    if (self.drawLayer) {
        self.drawLayer.bounds=CGRectMake(0, 0, frame.size.width, frame.size.height);
        self.drawLayer.anchorPoint=CGPointMake(0,0);
        self.drawLayer.position=CGPointMake(frame.origin.x,frame.origin.y);
        [self.drawLayer setNeedsDisplay];
    }
}

- (void)setUpdateDelegate:(id<VVWidgetAction>)delegate{
    if (!self.drawLayer.superlayer) {
        [((UIView*)delegate).layer addSublayer:self.drawLayer];
    }
    [super setUpdateDelegate:delegate];
}

- (void)dataUpdateFinished{
    [self.drawLayer setNeedsDisplay];
}

- (VVLayer *)drawLayer
{
    if (_drawLayer == nil) {
        _drawLayer = [VVLayer layer];
        _drawLayer.drawsAsynchronously = YES;
        _drawLayer.contentsScale = [[UIScreen mainScreen] scale];
    }
    return _drawLayer;
}

- (void)setBackgroundColor:(UIColor *)backgroundColor
{
    [super setBackgroundColor:backgroundColor];
    self.drawLayer.vv_backgroundColor = backgroundColor;
    [self.drawLayer setNeedsDisplay];
}

- (void)setBorderColor:(UIColor *)borderColor
{
    _borderColor = borderColor;
    self.drawLayer.vv_borderColor = borderColor;
    [self.drawLayer setNeedsDisplay];
}

- (BOOL)setIntValue:(int)value forKey:(int)key{
    BOOL ret = [ super setIntValue:value forKey:key];
    
    if (!ret) {
        ret = true;
        switch (key) {
            case STR_ID_borderWidth:
                self.drawLayer.vv_borderWidth = value;
                break;
            case STR_ID_borderRadius:
                self.drawLayer.vv_borderRadius = value;
                break;
            case STR_ID_borderTopLeftRadius:
                self.drawLayer.vv_borderTopLeftRadius = value;
                break;
            case STR_ID_borderTopRightRadius:
                self.drawLayer.vv_borderTopRightRadius = value;
                break;
            case STR_ID_borderBottomLeftRadius:
                self.drawLayer.vv_borderBottomLeftRadius = value;
                break;
            case STR_ID_borderBottomRightRadius:
                self.drawLayer.vv_borderBottomRightRadius = value;
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
                self.drawLayer.vv_borderWidth = value;
                break;
            case STR_ID_borderRadius:
                self.drawLayer.vv_borderRadius = value;
                break;
            case STR_ID_borderTopLeftRadius:
                self.drawLayer.vv_borderTopLeftRadius = value;
                break;
            case STR_ID_borderTopRightRadius:
                self.drawLayer.vv_borderTopRightRadius = value;
                break;
            case STR_ID_borderBottomLeftRadius:
                self.drawLayer.vv_borderBottomLeftRadius = value;
                break;
            case STR_ID_borderBottomRightRadius:
                self.drawLayer.vv_borderBottomRightRadius = value;
                break;

            default:
                ret = false;
                break;
        }
    }
    return ret;
}

@end
