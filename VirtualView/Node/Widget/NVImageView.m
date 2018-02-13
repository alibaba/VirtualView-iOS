//
//  NVImageView.m
//  VirtualView
//
//  Copyright (c) 2017-2018 Alibaba. All rights reserved.
//

#import "NVImageView.h"
#import "UIColor+VirtualView.h"
#import "VVPropertyExpressionSetter.h"
#import <SDWebImage/UIImageView+WebCache.h>

#ifdef VV_ALIBABA
#import "TMImageView.h"
#define VV_NImageViewType TMImageView
#else
#define VV_NImageViewType UIImageView
#endif

@interface NVImageView () {
    VV_NImageViewType *_imageView;
}

@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, assign) BOOL needReload;

@end

@implementation NVImageView

@dynamic cocoaView;

- (id)init
{
    if (self = [super init]) {
        _imageView = [[VV_NImageViewType alloc] init];
        _imageView.backgroundColor = [UIColor clearColor];
        _imageView.contentMode = UIViewContentModeScaleToFill;
        _scaleType = VVScaleTypeFitXY;
        _needReload = YES;
#ifdef VV_ALIBABA
        VVSelectorObserve(src, updateSrc);
#endif
        VVSelectorObserve(ratio, updateSize);
        VVSelectorObserve(paddingTop, updatePadding);
        VVSelectorObserve(paddingLeft, updatePadding);
        VVSelectorObserve(paddingBottom, updatePadding);
        VVSelectorObserve(paddingRight, updatePadding);
    }
    return self;
}

- (UIView *)cocoaView
{
    return _containerView ?: _imageView;
}

- (BOOL)needContainerView
{
    if (self.paddingTop > 0 || self.paddingRight > 0 || self.paddingLeft > 0 || self.paddingBottom > 0
        || [self.expressionSetters.allKeys containsObject:@"paddingTop"]
        || [self.expressionSetters.allKeys containsObject:@"paddingRight"]
        || [self.expressionSetters.allKeys containsObject:@"paddingLeft"]
        || [self.expressionSetters.allKeys containsObject:@"paddingBottom"]) {
        return YES;
    }
    return NO;
}

- (void)setRootCocoaView:(UIView *)rootCocoaView
{
    if (self.containerView == nil && [self needContainerView]) {
        CGRect frame = CGRectMake(0,
                                  0,
                                  self.paddingLeft + self.paddingRight + 10,
                                  self.paddingTop + self.paddingBottom + 10);
        self.containerView = [[UIView alloc] initWithFrame:frame];
        self.containerView.backgroundColor = self.imageView.backgroundColor;
        if (self.imageView.layer.cornerRadius > 0) {
            self.containerView.layer.cornerRadius = self.imageView.layer.cornerRadius;
            self.containerView.clipsToBounds = YES;
            self.imageView.layer.cornerRadius = 0;
        }
        self.containerView.layer.borderColor = self.imageView.layer.borderColor;
        if (self.imageView.layer.borderWidth > 0) {
            self.containerView.layer.borderWidth = self.imageView.layer.borderWidth;
            self.imageView.layer.borderWidth = 0;
        }
        [self updatePadding];
        self.imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [self.containerView addSubview:self.imageView];
    }
    if (self.cocoaView.superview != rootCocoaView) {
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

- (void)setBorderColor:(UIColor *)borderColor
{
    [super setBorderColor:borderColor];
    self.cocoaView.layer.borderColor = borderColor.CGColor;
}

- (void)setBorderWidth:(CGFloat)borderWidth
{
    [super setBorderWidth:borderWidth];
    self.cocoaView.layer.borderWidth = borderWidth;
}

- (void)setRatio:(CGFloat)ratio
{
    if (ratio >= 0) _ratio = ratio;
}

- (void)setScaleType:(VVScaleType)scaleType
{
    _scaleType = scaleType;
    switch (scaleType) {
        case VVScaleTypeFitCenter:
        case VVScaleTypeFitEnd: // best choice
        case VVScaleTypeFitStart: // best choice
        case VVScaleTypeCenterInside: // best choice
            self.imageView.contentMode = UIViewContentModeScaleAspectFit;
            break;
        case VVScaleTypeCenterCrop:
            self.imageView.contentMode = UIViewContentModeScaleAspectFill;
            self.imageView.clipsToBounds = YES;
            break;
        case VVScaleTypeCenter:
            self.imageView.contentMode = UIViewContentModeCenter;
            self.imageView.clipsToBounds = YES;
            break;
        case VVScaleTypeMatrix: // best choice
        default:
            self.imageView.contentMode = UIViewContentModeScaleToFill;
            break;
    }
}

#ifdef VV_ALIBABA
- (void)updateSrc
{
    self.ratio = [TMImageView imageWidthByHeight:1 imgUrl:self.src];
}
#endif

- (void)updateSize
{
    if ([self needResizeIfSubNodeResize]) {
        [self setNeedsResize];
    }
}

- (void)updatePadding
{
    CGSize size = self.containerView.frame.size;
    self.imageView.frame = CGRectMake(self.paddingLeft,
                                      self.paddingTop,
                                      size.width - self.paddingLeft - self.paddingRight,
                                      size.height - self.paddingTop - self.paddingBottom);
}

- (BOOL)setIntValue:(int)value forKey:(int)key
{
    BOOL ret = [super setIntValue:value forKey:key];
    if (!ret) {
        ret = YES;
        switch (key) {
            case STR_ID_scaleType:
                self.scaleType = value;
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
            case STR_ID_ratio:
                self.ratio = value;
                break;
            case STR_ID_borderRadius:
                self.cocoaView.layer.cornerRadius = value;
                self.cocoaView.clipsToBounds = YES;
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
    BOOL ret  = [super setStringValue:value forKey:key];
    if (!ret) {
        ret = YES;
        switch (key) {
            case STR_ID_src:
                self.src = value;
                break;
            default:
                ret = NO;
                break;
        }
    }
    return ret;
}

- (BOOL)setStringDataValue:(NSString*)value forKey:(int)key
{
    BOOL ret = YES;
    switch (key) {
        case STR_ID_src:
            self.src = value;
            break;
        default:
            ret = NO;
            break;
    }
    return ret;
}

- (void)reset
{
    self.imageView.image = nil;
    [self.imageView sd_setImageWithURL:nil];
    self.needReload = YES;
}

- (void)updateFrame
{
    [super updateFrame];
    if (self.needReload) {
        if ([self.src containsString:@"//"]) {
            [self.imageView sd_setImageWithURL:[NSURL URLWithString:self.src]];
        } else {
            self.imageView.image = [UIImage imageNamed:self.src];
        }
        self.needReload = NO;
    }
}

- (CGSize)calculateSize:(CGSize)maxSize
{
    [super calculateSize:maxSize];
    if (_ratio > 0) {
        if (self.nodeHeight <= 0 && self.layoutHeight == VV_WRAP_CONTENT) {
            self.nodeHeight = (self.nodeWidth - self.paddingLeft - self.paddingRight) / _ratio + self.paddingTop + self.paddingBottom;
        } else if (self.nodeWidth <= 0 && self.layoutWidth == VV_WRAP_CONTENT) {
            self.nodeWidth = (self.nodeHeight - self.paddingTop - self.paddingBottom) * _ratio + self.paddingLeft + self.paddingRight;
        }
    }
    return CGSizeMake(self.nodeWidth, self.nodeHeight);
}

@end
