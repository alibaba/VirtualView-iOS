//
//  NVTextView.m
//  VirtualView
//
//  Copyright (c) 2017-2018 Alibaba. All rights reserved.
//

#import "NVTextView.h"
#import "UIColor+VirtualView.h"

@implementation VVLabel

- (void)drawTextInRect:(CGRect)rect
{
    UIEdgeInsets padding = UIEdgeInsetsMake(self.paddingTop, self.paddingLeft, self.paddingBottom, self.paddingRight);
    [super drawTextInRect:UIEdgeInsetsInsetRect(rect, padding)];
}

@end

//################################################################
#pragma mark -

@interface NVTextView ()

@property (nonatomic, strong) VVLabel *textView;
@property (nonatomic, strong, readwrite) NSAttributedString *attributedText;
@property (nonatomic, strong) NSDictionary *style;

@end

@implementation NVTextView

@dynamic cocoaView;

- (instancetype)init
{
    self = [super init];
    if (self) {
        _textView = [[VVLabel alloc] init];
        _textView.backgroundColor = [UIColor clearColor];
        _textColor = [UIColor blackColor];
        _textView.textColor = _textColor;
        _textSize = UIFont.labelFontSize;
        _textStyle = VVTextStyleNormal;
        _ellipsize = VVEllipsizeEnd;
        _lines = 1;
        _gravity = VVGravityDefault;
//        _lineSpaceMultiplier = 1;
        VVSelectorObserve(text, updateAttributedText);
        VVSelectorObserve(textColor, updateAttributedText);
        VVSelectorObserve(textSize, updateFont);
        VVSelectorObserve(textStyle, updateFont);
        VVSelectorObserve(textStyle, updateStyle);
        VVSelectorObserve(ellipsize, updateAttributedText);
        VVSelectorObserve(gravity, updateAttributedText);
//        VVSelectorObserve(lineSpaceMultiplier, updateAttributedText);
//        VVSelectorObserve(lineSpaceExtra, updateAttributedText);
    }
    return self;
}

#pragma mark Properties

- (UIView *)cocoaView
{
    return _textView;
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
    self.textView.backgroundColor = backgroundColor;
}

- (void)setBorderColor:(UIColor *)borderColor
{
    [super setBorderColor:borderColor];
    self.textView.layer.borderColor = borderColor.CGColor;
}

- (void)setBorderWidth:(CGFloat)borderWidth
{
    [super setBorderWidth:borderWidth];
    self.textView.layer.borderWidth = borderWidth;
}

- (void)setPaddingTop:(CGFloat)paddingTop
{
    [super setPaddingTop:paddingTop];
    self.textView.paddingTop = paddingTop;
}

- (void)setPaddingLeft:(CGFloat)paddingLeft
{
    [super setPaddingLeft:paddingLeft];
    self.textView.paddingLeft = paddingLeft;
}

- (void)setPaddingBottom:(CGFloat)paddingBottom
{
    [super setPaddingBottom:paddingBottom];
    self.textView.paddingBottom = paddingBottom;
}

- (void)setPaddingRight:(CGFloat)paddingRight
{
    [super setPaddingRight:paddingRight];
    self.textView.paddingRight = paddingRight;
}

- (void)setText:(NSString *)text
{
    _text = text;
    self.textView.text = text;
}

- (void)setTextColor:(UIColor *)textColor
{
    _textColor = textColor;
    self.textView.textColor = textColor;
}

- (void)setTextSize:(CGFloat)textSize
{
    if (textSize > 0) _textSize = textSize;
}

- (void)setEllipsize:(VVEllipsize)ellipsize
{
    _ellipsize = ellipsize;
    switch (ellipsize) {
        case VVEllipsizeEnd:
            self.textView.lineBreakMode = NSLineBreakByTruncatingTail;
            break;
        case VVEllipsizeStart:
            self.textView.lineBreakMode = NSLineBreakByTruncatingHead;
            break;
        case VVEllipsizeMiddle:
            self.textView.lineBreakMode = NSLineBreakByTruncatingMiddle;
            break;
        default:
            self.textView.lineBreakMode = 0;
            break;
    }
}

- (void)setLines:(int)lines
{
    if (lines >= 0) {
        _lines = lines;
        self.textView.numberOfLines = lines;
    }
}

- (void)setMaxLines:(int)maxLines
{
    if (maxLines >= 0) _maxLines = maxLines;
}

- (void)setGravity:(VVGravity)gravity
{
    _gravity = gravity;
    if (gravity & VVGravityRight) {
        self.textView.textAlignment = NSTextAlignmentRight;
    } else if (gravity & VVGravityHCenter) {
        self.textView.textAlignment = NSTextAlignmentCenter;
    } else {
        self.textView.textAlignment = NSTextAlignmentLeft;
    }
}

- (NSAttributedString *)attributedText
{
    if (_attributedText == nil && _style != nil) {
        NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
        paragraphStyle.alignment = self.textView.textAlignment;
        paragraphStyle.lineBreakMode = self.textView.lineBreakMode;
        NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
        [attributes setObject:self.textView.font forKey:NSFontAttributeName];
        [attributes setObject:self.textColor forKey:NSForegroundColorAttributeName];
        [attributes setObject:paragraphStyle forKey:NSParagraphStyleAttributeName];
        [attributes addEntriesFromDictionary:_style];
        _attributedText = [[NSAttributedString alloc] initWithString:self.text
                                                          attributes:attributes];
    }
    return _attributedText;
}

#pragma mark Observers

- (void)updateFont
{
    if (self.textStyle & VVTextStyleBold) {
        self.textView.font = [UIFont boldSystemFontOfSize:self.textSize];
    } else if (self.textStyle & VVTextStyleItalic) {
        self.textView.font = [UIFont italicSystemFontOfSize:self.textSize];
    } else {
        self.textView.font = [UIFont systemFontOfSize:self.textSize];
    }
    [self updateAttributedText];
}

- (void)updateStyle
{
    self.style = nil;
    if ((self.textStyle & VVTextStyleUnderLine) == VVTextStyleUnderLine) {
        self.style = @{NSUnderlineStyleAttributeName : @(NSUnderlineStyleSingle)};
    } else if ((self.textStyle & VVTextStyleStrike) == VVTextStyleStrike) {
        self.style = @{NSStrikethroughStyleAttributeName : @(NSUnderlineStyleSingle)};
    }
    [self updateAttributedText];
}

- (void)updateAttributedText
{
    _attributedText = nil;
}

- (void)updateSize
{
    if ([self needResizeIfSubNodeResize]) {
        [self setNeedsResize];
    }
}
#pragma mark Update

- (BOOL)setIntValue:(int)value forKey:(int)key
{
    BOOL ret = [super setIntValue:value forKey:key];
    if (!ret) {
        ret = YES;
        switch (key) {
            case STR_ID_textColor:
                self.textColor = [UIColor vv_colorWithARGB:(NSUInteger)value];
                break;
            case STR_ID_textStyle:
                self.textStyle = value;
                break;
            case STR_ID_ellipsize:
                self.ellipsize = value;
                break;
            case STR_ID_lines:
                self.lines = value;
                break;
            case STR_ID_maxLines:
                self.maxLines = value;
                break;
            case STR_ID_gravity:
                self.gravity = value;
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
            case STR_ID_textSize:
                self.textSize = value;
                break;
            case STR_ID_lineSpaceMultiplier:
//                self.lineSpaceMultiplier = value;
                break;
            case STR_ID_lineSpaceExtra:
//                self.lineSpaceExtra = value;
                break;
            case STR_ID_borderRadius:
                self.textView.layer.cornerRadius = value;
                self.textView.clipsToBounds = YES;
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
            case STR_ID_text:
                self.text = value;
                break;
            default:
                ret = NO;
                break;
        }
    }
    return  ret;
}

- (BOOL)setStringData:(NSString*)data forKey:(int)key
{
    switch (key) {
        case STR_ID_textColor:
            self.textColor = [UIColor vv_colorWithString:data] ?: [UIColor blackColor];
            break;
    }
    return YES;
}

#pragma mark Layout

- (void)setupLayoutAndResizeObserver
{
    [super setupLayoutAndResizeObserver];
    VVSelectorObserve(text, updateSize);
    VVSelectorObserve(textSize, updateSize);
    VVSelectorObserve(textStyle, updateSize);
    VVSelectorObserve(lines, updateSize);
    VVSelectorObserve(maxLines, updateSize);
//    VVSelectorObserve(lineSpaceMultiplier, updateSize);
//    VVSelectorObserve(lineSpaceExtra, updateSize);
}

- (CGSize)calculateSize:(CGSize)maxSize
{
    [super calculateSize:maxSize];
    if (self.nodeHeight <= 0 && self.layoutHeight == VV_WRAP_CONTENT && _lines > 0) {
        self.nodeHeight = _lines * self.textView.font.lineHeight + self.paddingTop + self.paddingBottom;
        [self applyAutoDim];
    }
    if ((self.nodeWidth <= 0 && self.layoutWidth == VV_WRAP_CONTENT)
        || (self.nodeHeight <= 0 && self.layoutHeight == VV_WRAP_CONTENT)) {
        if (self.nodeWidth <= 0) {
            self.nodeWidth = maxSize.width;
        }
        if (self.nodeHeight <= 0) {
            if (self.maxLines > 0) {
                self.nodeHeight = MIN(maxSize.height, self.maxLines * self.textView.font.lineHeight);
            } else {
                self.nodeHeight = maxSize.height;
            }
        }
        CGSize contentSize = self.contentSize;
        
        // Calculate text frame.
        CGRect frame;
        if (self.attributedText) {
            frame = [self.attributedText boundingRectWithSize:contentSize
                                                     options:NSStringDrawingUsesLineFragmentOrigin
                                                     context:NULL];
        } else {
            frame = [self.text boundingRectWithSize:contentSize
                                           options:NSStringDrawingUsesLineFragmentOrigin
                                        attributes:@{NSFontAttributeName : self.textView.font}
                                           context:NULL];
        }
        
        if (self.layoutWidth == VV_WRAP_CONTENT) {
            self.nodeWidth = frame.size.width + self.paddingLeft + self.paddingRight;
        }
        if (self.layoutHeight == VV_WRAP_CONTENT) {
            self.nodeHeight = frame.size.height + self.paddingTop + self.paddingBottom;
        }
        [self applyAutoDim];
    }
    self.nodeHeight = ceil(self.nodeHeight);
    return CGSizeMake(self.nodeWidth, self.nodeHeight);
}
@end
