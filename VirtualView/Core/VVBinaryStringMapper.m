//
//  VVBinaryStringMapper.m
//  VirtualView
//
//  Copyright (c) 2017-2018 Alibaba. All rights reserved.
//

#import "VVBinaryStringMapper.h"

@interface VVBinaryStringMapper ()

@property (nonatomic, strong) NSMutableDictionary *mapperDict;

@end

@implementation VVBinaryStringMapper

+ (VVBinaryStringMapper *)sharedMapper
{
    static VVBinaryStringMapper *_sharedMapper;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedMapper = [VVBinaryStringMapper new];
    });
    return _sharedMapper;
}

- (instancetype)init
{
    if (self = [super init]) {
        NSArray *strings = @[
            @"action", @"actionParam", @"alignContent", @"alignItems", @"alignSelf", @"alpha", @"ancestor",
            @"animatorStyle", @"animatorTime", @"autoDimDirection", @"autoDimX", @"autoDimY",
            @"autoRefreshThreshold", @"autoSwitch", @"autoSwitchTime", @"background", @"backgroundImage",
            @"blurRadius", @"borderBottomLeftRadius", @"borderBottomRightRadius", @"borderColor",
            @"borderRadius", @"borderTopLeftRadius", @"borderTopRightRadius", @"borderWidth", @"canSlide",
            @"children", @"ck", @"class", @"colCount", @"color", @"Component", @"Container", @"containerID",
            @"dashEffect", @"data", @"dataMode", @"dataParam", @"dataTag", @"dataUrl", @"diameterX",
            @"diameterY", @"disableCache", @"disablePlaceHolder", @"do", @"ellipsize", @"else", @"elseif",
            @"filterWhiteBg", @"firstSpace", @"fixBy", @"flag", @"flexBasis", @"flexDirection", @"flexFlow",
            @"flexGrow", @"FlexLayout", @"flexShrink", @"flexWrap", @"for", @"FrameLayout", @"gravity",
            @"Grid", @"GridLayout", @"id", @"if", @"initValue", @"itemHeight", @"itemHorizontalMargin",
            @"itemMargin", @"itemVerticalMargin", @"itemWidth", @"justifyContent", @"lastSpace",
            @"layoutDirection", @"layoutGravity", @"layoutHeight", @"layoutMarginBottom", @"layoutMarginLeft",
            @"layoutMarginRight", @"layoutMarginTop", @"layoutOrientation", @"layoutRatio", @"layoutWidth",
            @"lines", @"lineSpace", @"lineSpaceExtra", @"lineSpaceMultiplier", @"List", @"maskColor",
            @"maxLines", @"minHeight", @"minWidth", @"mode", @"module", @"name", @"NImage", @"NLine", @"NText",
            @"onAfterDataLoad", @"onAutoRefresh", @"onBeforeDataLoad", @"onClick", @"onLongClick",
            @"onPageFlip", @"onScroll", @"onSetData", @"order", @"orientation", @"paddingBottom",
            @"paddingLeft", @"paddingRight", @"paddingTop", @"Page", @"paintStyle", @"paintWidth", @"parent",
            @"pos", @"Progress", @"ratio", @"RatioLayout", @"scaleType", @"Scroller", @"self", @"siblings",
            @"size", @"Slider", @"span", @"src", @"stayTime", @"style", @"supportHTMLStyle", @"supportSticky",
            @"tag", @"text", @"textColor", @"textSize", @"textStyle", @"this", @"TMNImage", @"TMVImage",
            @"type", @"typeface", @"uuid", @"var", @"VGraph", @"VH", @"VH2Layout", @"VHLayout", @"VImage",
            @"visibility", @"VLine", @"vList", @"VText", @"VTime", @"waterfall", @"while"
        ];
        _mapperDict = [NSMutableDictionary dictionaryWithCapacity:strings.count];
        for (NSString *string in strings) {
            [_mapperDict setObject:string forKey:@([VVBinaryStringMapper hashOfString:string])];
        }
    }
    return self;
}

+ (NSString *)stringForKey:(int)key
{
    return [[VVBinaryStringMapper sharedMapper].mapperDict objectForKey:@(key)];
}

+ (void)registerString:(NSString *)string forKey:(int)key
{
    if (string && string.length > 0) {
        [[VVBinaryStringMapper sharedMapper].mapperDict setObject:string forKey:@(key)];
    }
}

+ (void)registerString:(NSString *)string
{
    if (string && string.length > 0) {
        [self registerString:string forKey:[self hashOfString:string]];
    }
}

+ (int)hashOfString:(NSString *)string
{
    int hash = 0;
    if (string && string.length > 0) {
        const char *chars = [string UTF8String];
        NSInteger length = strlen(chars);
        for (NSInteger index = 0; index < length; index++) {
            hash = (hash * 31) + chars[index];
        }
    }
    return hash;
}

@end
