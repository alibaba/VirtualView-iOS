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
        VVSelectorObserve(text, updateAttributedText);
        VVSelectorObserve(textColor, updateAttributedText);
        VVSelectorObserve(textSize, updateFont);
        VVSelectorObserve(textStyle, updateFont);
        VVSelectorObserve(textStyle, updateStyle);
        VVSelectorObserve(ellipsize, updateAttributedText);
        VVSelectorObserve(gravity, updateAttributedText);
        VVSelectorObserve(lineHeight, updateAttributedText);
        VVSelectorObserve(lineSpaceExtra, updateAttributedText);
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
    if (maxLines >= 0) {
        _maxLines = maxLines;
        self.lines = 0;
    }
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

- (void)setLineHeight:(CGFloat)lineHeight
{
    if (lineHeight >= 0) _lineHeight = lineHeight;
}

- (void)setLineSpaceExtra:(CGFloat)lineSpaceExtra
{
    if (lineSpaceExtra >= 0) _lineSpaceExtra = lineSpaceExtra;
}

- (NSAttributedString *)attributedText
{
    if (_attributedText == nil && self.text && (self.style != nil || self.lineHeight > 0 || self.lineSpaceExtra > 0)) {
        NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
        paragraphStyle.alignment = self.textView.textAlignment;
        // Cannot get correct bounding size of text with truncating.
        // paragraphStyle.lineBreakMode = self.textView.lineBreakMode;
        if ([self needLineHeight]) {
            paragraphStyle.maximumLineHeight = self.lineHeight;
            paragraphStyle.minimumLineHeight = self.lineHeight;
        }
        if (self.lineSpaceExtra > 0) {
            paragraphStyle.lineSpacing = self.lineSpaceExtra;
        }
        NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
        [attributes setObject:self.textView.font forKey:NSFontAttributeName];
        [attributes setObject:self.textColor forKey:NSForegroundColorAttributeName];
        [attributes setObject:paragraphStyle forKey:NSParagraphStyleAttributeName];
        if ([self needLineHeight]) {
            [attributes setObject:@((self.lineHeight - self.textView.font.lineHeight) / 4)
                           forKey:NSBaselineOffsetAttributeName];
        }
        if (self.style) {
            [attributes addEntriesFromDictionary:self.style];
        }
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
    if (self.textStyle & VVTextStyleUnderLine) {
        self.style = @{NSUnderlineStyleAttributeName : @(NSUnderlineStyleSingle)};
    } else if (self.textStyle & VVTextStyleStrike) {
        self.style = @{NSStrikethroughStyleAttributeName : @(NSUnderlineStyleSingle)};
    }
    [self updateAttributedText];
}

- (void)updateAttributedText
{
    _attributedText = nil;
}

- (void)updateText
{
    if (self.layoutWidth == VV_WRAP_CONTENT || (self.layoutHeight == VV_WRAP_CONTENT && self.lines == 0)) {
        [self setNeedsResize];
    }
}

- (void)updateContentSize
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
            case STR_ID_borderRadius:
                self.textView.layer.cornerRadius = value;
                self.textView.clipsToBounds = YES;
                break;
            case STR_ID_lineHeight:
                self.lineHeight = value;
                break;
            case STR_ID_lineSpaceExtra:
                self.lineSpaceExtra = value;
                break;
            case STR_ID_lineSpaceMultiplier:
                // ignore this property
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
        if (key == STR_ID_text) {
            self.text = value;
            ret = YES;
        }
    }
    return  ret;
}

- (BOOL)setStringData:(NSString*)data forKey:(int)key
{
    BOOL ret = NO;
    if (key == STR_ID_textColor) {
        self.textColor = [UIColor vv_colorWithString:data] ?: [UIColor blackColor];
        ret = YES;
    }
    return ret;
}

#pragma mark Layout

- (void)setupLayoutAndResizeObserver
{
    [super setupLayoutAndResizeObserver];
    VVSelectorObserve(text, updateText);
    VVSelectorObserve(textSize, updateContentSize);
    VVSelectorObserve(textStyle, updateContentSize);
    VVSelectorObserve(lines, updateContentSize);
    VVSelectorObserve(maxLines, updateContentSize);
    VVSelectorObserve(lineHeight, updateContentSize);
    VVSelectorObserve(lineSpaceExtra, updateContentSize);
}

- (void)layoutSubNodes
{
    if (self.attributedText) {
        self.textView.attributedText = self.attributedText;
    } else {
        self.textView.text = self.text;
    }
}

- (CGSize)calcContentSize:(CGSize)maxSize
{
    if (self.maxLines > 0) {
        maxSize.height = MIN(maxSize.height, self.maxLines * [self expectedLineHeight]);
    }

    CGSize size;
    if (self.attributedText) {
        size = [self.attributedText boundingRectWithSize:maxSize
                                                  options:NSStringDrawingUsesLineFragmentOrigin
                                                  context:NULL].size;
    } else {
        size = [self.text boundingRectWithSize:maxSize
                                        options:NSStringDrawingUsesLineFragmentOrigin
                                     attributes:@{NSFontAttributeName : self.textView.font}
                                        context:NULL].size;
    }
    
    return size;
}

- (CGSize)calculateSize:(CGSize)maxSize
{    
    [super calculateSize:maxSize];
    if (self.nodeHeight <= 0 && self.layoutHeight == VV_WRAP_CONTENT && self.lines > 0) {
        self.nodeHeight = self.lines * [self expectedLineHeight] + self.paddingTop + self.paddingBottom;
        if (self.lines > 1 || [self needLineHeight] == NO) {
            // UILabel does not ignore line space for single line text when line height is set.
            // NOT a bug.
            self.nodeHeight -= self.lineSpaceExtra;
        }
        [self applyAutoDim];
    }
    if ((self.nodeWidth <= 0 && self.layoutWidth == VV_WRAP_CONTENT)
        || (self.nodeHeight <= 0 && self.layoutHeight == VV_WRAP_CONTENT)) {
        if (self.nodeWidth <= 0) {
            self.nodeWidth = maxSize.width - self.marginLeft - self.marginRight;
        }
        if (self.nodeHeight <= 0) {
            self.nodeHeight = maxSize.height - self.marginTop - self.marginBottom;
        }
        
        CGSize contentSize = self.contentSize;
        contentSize = [self calcContentSize:contentSize];
        
        if (self.layoutWidth == VV_WRAP_CONTENT) {
            self.nodeWidth = contentSize.width + self.paddingLeft + self.paddingRight;
        }
        if (self.layoutHeight == VV_WRAP_CONTENT) {
            self.nodeHeight = contentSize.height + self.paddingTop + self.paddingBottom;
        }
        [self applyAutoDim];
    }
    self.nodeHeight = ceil(self.nodeHeight);
    self.nodeWidth = ceil(self.nodeWidth);
    return CGSizeMake(self.nodeWidth, self.nodeHeight);
}

#pragma mark Helper

- (CGFloat)expectedLineHeight
{
    if ([self needLineHeight]) {
        return self.lineHeight + self.lineSpaceExtra;
    } else {
        return self.textView.font.lineHeight + self.lineSpaceExtra;
    }
}

- (BOOL)needLineHeight
{
    return self.lineHeight > self.textView.font.lineHeight;
}

@end
