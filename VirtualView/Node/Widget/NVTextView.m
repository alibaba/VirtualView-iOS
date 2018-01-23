//
//  NVTextView.m
//  VirtualView
//
//  Copyright (c) 2017-2018 Alibaba. All rights reserved.
//

#import "NVTextView.h"
#import "UIColor+VirtualView.h"
#import "FrameView.h"

//****************************************************************

@interface StringInfo : NSObject

@property (nonatomic, assign) CGSize drawRect;
@property (nonatomic, strong) NSMutableAttributedString *attstr;

@end

@implementation StringInfo

@end

//****************************************************************

@interface StringCache : NSObject

+ (StringCache *)sharedCache;

@property (nonatomic, strong)NSMutableDictionary *stringDrawRectInfo;

- (StringInfo *)getDrawStringInfo:(NSString *)value andFrontSize:(CGFloat)size maxWidth:(CGFloat)maxWidth;
- (void)setDrawStringInfo:(StringInfo *)strInfo forString:(NSString *)value frontSize:(CGFloat)size maxWidth:(CGFloat)maxWidth;

@end

@implementation StringCache

+ (StringCache *)sharedCache
{
    static StringCache *_sharedCache;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedCache = [StringCache new];
    });
    return _sharedCache;
}

- (instancetype)init
{
    if (self = [super init]) {
        _stringDrawRectInfo = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (StringInfo *)getDrawStringInfo:(NSString *)value andFrontSize:(CGFloat)size maxWidth:(CGFloat)maxWidth
{
    NSDictionary *stringInfoDic = [self.stringDrawRectInfo objectForKey:value];
    NSString *key = [NSString stringWithFormat:@"%.2f-%.2f", size, maxWidth];
    StringInfo *info = [stringInfoDic objectForKey:key];
    return info;
}

- (void)setDrawStringInfo:(StringInfo *)strInfo forString:(NSString *)value frontSize:(CGFloat)size maxWidth:(CGFloat)maxWidth
{
    NSString *key = [NSString stringWithFormat:@"%.2f-%.2f", size, maxWidth];
    NSMutableDictionary *stringInfoDic = [self.stringDrawRectInfo objectForKey:value];
    if (stringInfoDic) {
        [stringInfoDic setObject:strInfo forKey:key];
    } else {
        NSMutableDictionary *stringInfoDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:strInfo, key, nil];
        [self.stringDrawRectInfo setObject:stringInfoDic forKey:value];
    }
}

@end

//****************************************************************

@interface NVTextView (){
    CGSize _maxSize;
}
@property(nonatomic, assign)CGSize  textSize;
@property(nonatomic, strong)UILabel* textView;
@property(nonatomic, assign)CGFloat lineSpace;
@property(nonatomic, strong)NSMutableAttributedString* attStr;
@end

@implementation NVTextView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (id)init{
    self = [super init];
    if (self) {
        self.cocoaView = [[FrameView alloc] init];
        self.textView = [[UILabel alloc] init];
        self.textView.backgroundColor=[UIColor clearColor];
        self.textView.numberOfLines=1;
        self.textView.textColor = [UIColor blackColor];
        self.cocoaView.backgroundColor = [UIColor clearColor];
        self.frontSize = 12.0f;
        self.textView.font = [UIFont systemFontOfSize:self.frontSize];
        [self.cocoaView addSubview:self.textView];
    }
    return self;
}

- (BOOL)bold
{
    return (self.textStyle & VVTextStyleBold) == VVTextStyleBold;
}

- (UIFont *)vv_font
{
    if (self.bold) {
        return [UIFont boldSystemFontOfSize:self.frontSize<=0?14:self.frontSize];
    } else if ((self.textStyle & VVTextStyleItalic) == VVTextStyleItalic) {
        return [UIFont italicSystemFontOfSize:self.frontSize<=0?14:self.frontSize];
    } else {
        return [UIFont systemFontOfSize:self.frontSize<=0?14:self.frontSize];
    }
}

- (void)layoutSubviews{
    
    
    CGFloat pY =0, pX=0;
    if ((self.gravity & VVGravityBottom)==VVGravityBottom) {
        pY = pY+self.frame.size.height-self.paddingBottom-self.textSize.height;
    }else if ((self.gravity & VVGravityVCenter)==VVGravityVCenter){
        pY += (self.frame.size.height-self.paddingTop-self.paddingBottom-self.textSize.height)/2.0;
    }else{
        pY += self.paddingTop;
    }
    
    if ((self.gravity & VVGravityRight)==VVGravityRight) {
        pX += self.frame.size.width-self.paddingRight-self.textSize.width;
    }else if ((self.gravity & VVGravityHCenter)==VVGravityHCenter){
        pX += (self.frame.size.width-self.paddingLeft-self.paddingRight-self.textSize.width)/2.0;
    }else{
        pX = self.paddingLeft;
    }
    UIFont *font = [self vv_font];
    self.textView.font = font;
    self.cocoaView.backgroundColor = self.backgroundColor;
    self.cocoaView.frame = self.frame;
    self.textView.frame = CGRectMake(pX, pY, _textSize.width, _textSize.height);

    switch (self.gravity) {
        case VVGravityLeft:
            self.textView.textAlignment = NSTextAlignmentLeft;
            break;
        case VVGravityHCenter:
        case VVGravityHCenter+VVGravityVCenter:
            self.textView.textAlignment = NSTextAlignmentCenter;
            break;
        case VVGravityRight:
            self.textView.textAlignment = NSTextAlignmentRight;
            break;
        default:
            self.textView.textAlignment = NSTextAlignmentLeft;
            break;
    }
}

- (void)setData:(NSData*)data{
    //
    self.text = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
}
- (void)setDataObj:(NSObject*)obj forKey:(int)key{
    
    switch (key) {
        case STR_ID_text:
            self.text = (NSString*)obj;
            break;
        case STR_ID_typeface:
            break;
        case STR_ID_textSize:
            self.textView.font = [UIFont systemFontOfSize:[(NSNumber *)obj floatValue]];
            self.frontSize = [(NSNumber*)obj floatValue];
            break;
        case STR_ID_textColor:
            if ([obj isKindOfClass:[NSString class]]) {
                self.textView.textColor = [UIColor vv_colorWithString:(NSString *)obj];
            } else {
                self.textView.textColor = [UIColor vv_colorWithRGB:[[obj description] integerValue]];
            }
            break;
        case STR_ID_textStyle:
            break;
        case STR_ID_lines:
            self.textView.numberOfLines = [(NSNumber*)obj intValue];
            break;
        case STR_ID_ellipsize:
            break;
        default:
            break;
    }
}

- (CGSize)calculateLayoutSize:(CGSize)maxSize{
    _maxSize = maxSize;
    CGSize textSize = CGSizeZero;
    CGFloat width = self.widthModle > 0 ? self.widthModle : maxSize.width-self.paddingLeft-self.paddingRight;
    CGFloat height = self.heightModle > 0 ? self.heightModle : maxSize.height-self.paddingTop-self.paddingBottom;
    CGSize textMaxRT = CGSizeMake(width, height);
    
    StringInfo* info =[[StringCache sharedCache] getDrawStringInfo:self.text andFrontSize:self.frontSize maxWidth:width];
    if(info){
        self.textSize = info.drawRect;
        //self.textView.frame = CGRectMake(0, 0, info.drawRect.width, info.drawRect.height);
    }else if(self.text && self.text.length>0){
        if (0/*[self.cacheInfoDic objectForKey:@"cached"]*/) {
            //textSize = CGSizeMake([[self.cacheInfoDic objectForKey:@"width"] floatValue], [[self.cacheInfoDic objectForKey:@"height"] floatValue]);
        }else{
            //CGSize textMaxRT = CGSizeMake(maxSize.width-self.paddingLeft-self.paddingRight, maxSize.height-self.paddingTop-self.paddingBottom);
            //CGSize textSize = CGSizeZero;
            
            UIFont *font = [self vv_font];;

            CGFloat fTextRealHeight=0.0f;
            NSInteger lines = self.textView.numberOfLines;
            if (lines>0) {
                fTextRealHeight = font.lineHeight*lines;
                if(textMaxRT.height<fTextRealHeight){
                    textMaxRT.height = fTextRealHeight;
                }
            }

            if(self.lineSpace <= 0)
            {
                textSize = [self.text boundingRectWithSize:textMaxRT options:NSStringDrawingTruncatesLastVisibleLine |
                            NSStringDrawingUsesLineFragmentOrigin |
                            NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:font} context:nil].size;
            }
            else
            {
                NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc]init];
                style.lineSpacing = self.lineSpace;
                textSize = [self.text boundingRectWithSize:textMaxRT options:NSStringDrawingTruncatesLastVisibleLine |
                            NSStringDrawingUsesLineFragmentOrigin |
                            NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:font,NSParagraphStyleAttributeName:style} context:nil].size;
            }
            
            if (textSize.height > fTextRealHeight) {
                textSize.height=fTextRealHeight;
            }
         }
        StringInfo* info = [[StringInfo alloc] init];
        info.drawRect = textSize;
        self.textSize = textSize;
        [[StringCache sharedCache] setDrawStringInfo:info forString:self.text frontSize:self.frontSize maxWidth:width];

    }

    _textSize.width  = _textSize.width>textMaxRT.width?textMaxRT.width:_textSize.width;
    _textSize.height = _textSize.height>textMaxRT.height?textMaxRT.height:_textSize.height;

    switch ((int)self.widthModle) {
        case VV_WRAP_CONTENT:
            //
            self.width = _textSize.width;
            self.width = self.paddingRight+self.paddingLeft+self.width;
            break;
        case VV_MATCH_PARENT:
            if (self.superview.widthModle==VV_WRAP_CONTENT) {
                self.width = self.paddingRight+self.paddingLeft+_textSize.width;
            }else{
                self.width=maxSize.width;
            }
            //_textSize.width = self.width;
            break;
        default:
            //_textSize.width = self.width;
            self.width = self.paddingRight+self.paddingLeft+self.width;
            break;
    }

    switch ((int)self.heightModle) {
        case VV_WRAP_CONTENT:
            //
            self.height= _textSize.height;
            self.height = self.paddingTop+self.paddingBottom+self.height;
            break;
        case VV_MATCH_PARENT:
            if (self.superview.heightModle==VV_WRAP_CONTENT){
                self.height = self.paddingTop+self.paddingBottom+_textSize.height;
            }else{
                self.height=maxSize.height;
            }
            //_textSize.height = self.height;
            break;
        default:
            //_textSize.height = self.height;
            self.height = self.paddingTop+self.paddingBottom+self.height;
            break;
    }
    [self autoDim];
    CGSize size = CGSizeMake(self.width=self.width<maxSize.width?self.width:maxSize.width, self.height=self.height<maxSize.height?self.height:maxSize.height);
    return size;
}

- (void)updateTextFrameSize{
    CGSize textSize = CGSizeZero;
    
    if ([self.cacheInfoDic objectForKey:@"cached"]) {
        textSize = CGSizeMake([[self.cacheInfoDic objectForKey:@"width"] floatValue], [[self.cacheInfoDic objectForKey:@"height"] floatValue]);
    }else{
        CGSize textMaxRT = CGSizeMake(_maxSize.width-self.paddingLeft-self.paddingRight, _maxSize.height-self.paddingTop-self.paddingBottom);
        
        UIFont *font = [self vv_font];;
        if(self.lineSpace <= 0)
        {
            textSize = [self.text boundingRectWithSize:textMaxRT options:NSStringDrawingTruncatesLastVisibleLine |
                        NSStringDrawingUsesLineFragmentOrigin |
                        NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:font} context:nil].size;
        }
        else
        {
            NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc]init];
            style.lineSpacing = self.lineSpace;
            textSize = [self.text boundingRectWithSize:textMaxRT options:NSStringDrawingTruncatesLastVisibleLine |
                        NSStringDrawingUsesLineFragmentOrigin |
                        NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:font,NSParagraphStyleAttributeName:style} context:nil].size;
        }
        [self.cacheInfoDic setObject:[NSNumber numberWithBool:YES] forKey:@"cached"];
        [self.cacheInfoDic setObject:[NSNumber numberWithFloat:textSize.width] forKey:@"width"];
        [self.cacheInfoDic setObject:[NSNumber numberWithFloat:textSize.height] forKey:@"height"];
    }
    self.textView.frame = CGRectMake(self.cocoaView.frame.origin.x, self.cocoaView.frame.origin.y, textSize.width, textSize.height);
    [self.textView sizeToFit];
    _textSize.width = self.textView.frame.size.width;
    _textSize.height = self.textView.frame.size.height;
    //self.cocoaView.frame = CGRectMake(self.cocoaView.frame.origin.x, self.cocoaView.frame.origin.y, _textSize.width, _textSize.height);
}

- (void)dataUpdateFinished{
    [self updateTextFrameSize];
    [super dataUpdateFinished];
}

- (void)setText:(NSString *)text{
    _text = text;
    if ((self.textStyle & VVTextStyleUnderLine) == VVTextStyleUnderLine) {
        self.textView.attributedText = [[NSAttributedString alloc] initWithString:text
                                                                       attributes:@{NSUnderlineStyleAttributeName : @(NSUnderlineStyleSingle)}];
    } else if ((self.textStyle & VVTextStyleStrike) == VVTextStyleStrike) {
        self.textView.attributedText = [[NSAttributedString alloc] initWithString:text
                                                                       attributes:@{NSStrikethroughStyleAttributeName : @(NSUnderlineStyleSingle)}];
    } else {
        self.textView.text = text;
    }
}

- (BOOL)setStringDataValue:(NSString*)value forKey:(int)key{
    
    switch (key) {
        case STR_ID_text:
            self.text = value;
            if(self.lineSpace > 0)
            {
                if(self.text.length > 0)
                {
                    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc]init];
                    style.lineSpacing = self.lineSpace;
                    style.lineBreakMode = self.textView.lineBreakMode;
                    if (self.attStr==nil) {
                        self.attStr = [[NSMutableAttributedString alloc]initWithString:self.text attributes:@{NSParagraphStyleAttributeName:style}];
                    }
                    [self.attStr replaceCharactersInRange:NSMakeRange(0, self.attStr.length) withString:self.text];
                }
            }
            break;
        case STR_ID_typeface:
            break;
        case STR_ID_textSize:
            self.textView.font = [UIFont systemFontOfSize:[value floatValue]];
            self.frontSize = [value floatValue];
            break;
        case STR_ID_textColor:
            if (value) {
                self.textView.textColor = [UIColor vv_colorWithString:value];
            }else{
                self.textView.textColor = [UIColor blackColor];
            }
            break;
        case STR_ID_borderColor:
            self.borderColor = [UIColor vv_colorWithString:value];
            break;
        case STR_ID_background:
            self.backgroundColor = [UIColor vv_colorWithString:value];
            self.cocoaView.backgroundColor = self.backgroundColor;
            break;
    }
    return YES;
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
                
            case STR_ID_typeface:
                break;
                
            case STR_ID_textSize:
                self.textView.font = [UIFont systemFontOfSize:[value floatValue]];
                self.frontSize = [value floatValue];
                break;
            case STR_ID_textColor:
                if (value) {
                    self.textView.textColor = [UIColor vv_colorWithString:value];
                }else{
                    self.textView.textColor = [UIColor blackColor];
                }
                break;
            case STR_ID_borderColor:
                self.borderColor = [UIColor vv_colorWithString:value];
                break;
            default:
                ret = false;
                break;
        }
    }
    return  ret;
}

- (BOOL)setIntValue:(int)value forKey:(int)key{
    BOOL ret = [ super setIntValue:value forKey:key];
    
    if (!ret) {
        ret = true;
        switch (key) {
            case STR_ID_textSize:
                self.frontSize = value;
                self.textView.font = [UIFont systemFontOfSize:self.frontSize];
                break;
            case STR_ID_textColor:
                self.textView.textColor = [UIColor vv_colorWithARGB:(NSUInteger)value];
                break;
            case STR_ID_textStyle:
                self.textStyle = (VVTextStyle)value;
                break;
            case STR_ID_maxLines:
                self.textView.numberOfLines = value;
                break;
            case STR_ID_lines:
                self.textView.numberOfLines = value;
                break;
            case STR_ID_ellipsize:
                self.textView.lineBreakMode = value+2;
                break;
            case STR_ID_borderWidth:
                ((FrameView*)self.cocoaView).lineWidth = value;
                break;
            case STR_ID_borderColor:
                self.borderColor = [UIColor vv_colorWithARGB:(NSUInteger)value];
                ((FrameView*)self.cocoaView).borderColor = self.borderColor;
                break;
            default:
                ret = false;
                break;
        }
    }else if (key==STR_ID_background){
        self.cocoaView.backgroundColor = self.backgroundColor;
    }
    return ret;
}

- (BOOL)setFloatValue:(float)value forKey:(int)key
{
    BOOL ret = [ super setIntValue:value forKey:key];
    if(!ret)
    {
        ret = true;
        switch (key) {
            case STR_ID_lineSpaceExtra:
                self.lineSpace = value;
                break;
            case STR_ID_textSize:
                self.frontSize = value;
                self.textView.font = [UIFont systemFontOfSize:self.frontSize];
                break;
            case STR_ID_borderWidth:
                //self.textView.lineWidth = value;
                ((FrameView*)self.cocoaView).lineWidth = value;
                break;
            case STR_ID_borderRadius:
                //self.textView.lineWidth = value;
                ((FrameView*)self.cocoaView).borderRadius = value;
                break;
            default:
                ret = false;
                break;
        }
    }
    return ret;
}

@end
