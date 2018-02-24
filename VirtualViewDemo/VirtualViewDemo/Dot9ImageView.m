//
//  Dot9ImageView.m
//  VirtualViewDemo
//
//  Copyright (c) 2017-2018 Alibaba. All rights reserved.
//

#import "Dot9ImageView.h"
#import "UIColor+VirtualView.h"
#import <VirtualView/VVBinaryStringMapper.h>
#import <SDWebImage/UIImageView+WebCache.h>

@interface Dot9ImageView ()

@property (nonatomic, assign) BOOL needReload;
@property (nonatomic, strong) UIImageView *imageView;

@end

@implementation Dot9ImageView

@dynamic cocoaView;

- (id)init
{
    if (self = [super init]) {
        _imageView = [[UIImageView alloc] init];
        _imageView.backgroundColor = [UIColor clearColor];
        _imageView.contentMode = UIViewContentModeScaleToFill;
        _needReload = YES;
    }
    return self;
}

- (UIView *)cocoaView
{
    return _imageView;
}

- (UIEdgeInsets)dot9Insets
{
    return UIEdgeInsetsMake(self.dot9Top, self.dot9Left, self.dot9Bottom, self.dot9Right);
}

- (void)setRootCocoaView:(UIView *)rootCocoaView
{
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

- (BOOL)setIntValue:(int)value forKey:(int)key
{
    BOOL ret = [super setIntValue:value forKey:key];
    if (!ret) {
        if (key == [VVBinaryStringMapper hashOfString:@"dot9Scale"]) {
            self.dot9Scale = value;
            ret = YES;
        }
    }
    return ret;
}

- (BOOL)setFloatValue:(float)value forKey:(int)key
{
    BOOL ret = [super setFloatValue:value forKey:key];
    if (!ret) {
        ret = YES;
        if (key == STR_ID_borderRadius) {
            self.cocoaView.layer.cornerRadius = value;
            self.cocoaView.clipsToBounds = YES;
        } else if (key == [VVBinaryStringMapper hashOfString:@"dot9Left"]) {
            self.dot9Left = value;
        } else if (key == [VVBinaryStringMapper hashOfString:@"dot9Bottom"]) {
            self.dot9Bottom = value;
        } else if (key == [VVBinaryStringMapper hashOfString:@"dot9Right"]) {
            self.dot9Right = value;
        } else if (key == [VVBinaryStringMapper hashOfString:@"dot9Top"]) {
            self.dot9Top = value;
        } else {
            ret = NO;
        }
    }
    return ret;
}

- (BOOL)setStringValue:(NSString *)value forKey:(int)key
{
    BOOL ret  = [super setStringValue:value forKey:key];
    if (!ret) {
        if (key == STR_ID_src) {
            self.src = value;
            ret = YES;
        }
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
        if (self.src && self.src.length > 0) {
            if ([self.src containsString:@"//"]) {
                [self.imageView sd_setImageWithURL:[NSURL URLWithString:self.src] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
                    if (self.dot9Scale > 1) {
                        image = [UIImage imageWithCGImage:image.CGImage
                                                    scale:self.dot9Scale
                                              orientation:image.imageOrientation];
                    }
                    self.imageView.image = [image resizableImageWithCapInsets:[self dot9Insets]
                                                                 resizingMode:UIImageResizingModeStretch];
                }];
            } else {
                UIImage *image = [UIImage imageNamed:self.src];
                self.imageView.image = [image resizableImageWithCapInsets:[self dot9Insets]
                                                             resizingMode:UIImageResizingModeStretch];
            }
        }
        self.needReload = NO;
    }
}

@end

