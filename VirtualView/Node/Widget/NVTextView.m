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

@property (nonatomic, strong, readwrite) VVLabel *textView;

@end

@implementation NVTextView
@synthesize cocoaView;

- (instancetype)init
{
    self = [super init];
    if (self) {
        _textView = [[VVLabel alloc] init];
        _textView.backgroundColor = [UIColor clearColor];
        _textColor = [UIColor blackColor];
        _textView.textColor = _textColor;
        _textSize = 17;
        _textStyle = VVTextStyleNormal;
        _ellipsize = VVEllipsizeEnd;
        _lines = 1;
        _gravity = VVGravityDefault;
//        _lineSpaceMultiplier = 1;
        VVSelectorObserve(textStyle, updateFont);
        VVSelectorObserve(textSize, updateFont);
        VVSelectorObserve(ellipsize, updateLineBreakMode);
        VVSelectorObserve(lines, updateNumberOfLines);
        VVSelectorObserve(maxLines, updateNumberOfLines);
        VVSelectorObserve(textStyle, updateAttributedText);
        VVSelectorObserve(text, updateAttributedText);
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
    if (self.textView.superview !=  rootCocoaView) {
        if (self.textView.superview) {
            [self.textView removeFromSuperview];
        }
        [rootCocoaView addSubview:self.textView];
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

- (void)setTextColor:(UIColor *)textColor
{
    _textColor = textColor;
    self.textView.textColor = textColor;
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

- (void)setGravity:(VVGravity)gravity
{
    _gravity = gravity;
    if (_gravity & VVGravityRight) {
        self.textView.textAlignment = NSTextAlignmentRight;
    } else if (_gravity & VVGravityHCenter) {
        self.textView.textAlignment = NSTextAlignmentCenter;
    } else {
        self.textView.textAlignment = NSTextAlignmentLeft;
    }
}

- (void)setTextSize:(CGFloat)textSize
{
    if (textSize > 0) _textSize = textSize;
}

- (void)setLines:(int)lines
{
    if (lines >= 0) _lines = lines;
}

- (void)setMaxLines:(int)maxLines
{
    if (maxLines >= 0) _maxLines = maxLines;
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
    if ([self needResizeIfSubNodeResize]) {
        [self setNeedsResize];
    }
}

- (void)updateLineBreakMode
{
    switch (self.ellipsize) {
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
    if ([self needResizeIfSubNodeResize]) {
        [self setNeedsResize];
    }
}

- (void)updateNumberOfLines
{
    self.textView.numberOfLines = self.lines;
    if ([self needResizeIfSubNodeResize]) {
        [self setNeedsResize];
    }
}

- (void)updateAttributedText
{
    NSDictionary *attributes = nil;
    if ((self.textStyle & VVTextStyleUnderLine) == VVTextStyleUnderLine) {
        attributes = @{NSUnderlineStyleAttributeName : @(NSUnderlineStyleSingle)};
    } else if ((self.textStyle & VVTextStyleStrike) == VVTextStyleStrike) {
        attributes = @{NSStrikethroughStyleAttributeName : @(NSUnderlineStyleSingle)};
    }
    if (attributes && self.text) {
        self.textView.attributedText = [[NSAttributedString alloc] initWithString:self.text
                                                                       attributes:attributes];
    } else {
        self.textView.attributedText = nil;
        self.textView.text = self.text;
    }
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
            case STR_ID_supportHTMLStyle:
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

- (BOOL)setStringDataValue:(NSString*)value forKey:(int)key
{
    switch (key) {
        case STR_ID_text:
            self.text = value;
            break;
        case STR_ID_textColor:
            self.textColor = [UIColor vv_colorWithString:value] ?: [UIColor blackColor];
            break;
    }
    return YES;
}

#pragma mark Layout

- (void)updateHidden
{
    [super updateHidden];
    self.textView.hidden = self.hidden;
}

- (void)updateFrame
{
    [super updateFrame];
    self.textView.frame = self.nodeFrame;
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
        
        // Calculate text size.
        self.textView.frame = CGRectMake(0, 0, contentSize.width, contentSize.height);
        [self.textView sizeToFit];
        
        if (self.layoutWidth == VV_WRAP_CONTENT) {
            self.nodeWidth = self.textView.frame.size.width + self.paddingLeft + self.paddingRight;
        }
        if (self.layoutHeight == VV_WRAP_CONTENT) {
            self.nodeHeight = self.textView.frame.size.height + self.paddingTop + self.paddingBottom;
        }
        [self applyAutoDim];
    }
    return CGSizeMake(self.nodeWidth, self.nodeHeight);
}
@end
