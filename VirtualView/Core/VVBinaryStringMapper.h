//
//  VVBinaryStringMapper.h
//  VirtualView
//
//  Copyright (c) 2017-2018 Alibaba. All rights reserved.
//

#import <Foundation/Foundation.h>

// Internal supported string list.
// Key is hash of string by default.
//
// @"action", @"actionParam", @"alignContent", @"alignItems", @"alignSelf", @"alpha", @"ancestor",
// @"animatorStyle", @"animatorTime", @"autoDimDirection", @"autoDimX", @"autoDimY",
// @"autoRefreshThreshold", @"autoSwitch", @"autoSwitchTime", @"background", @"backgroundImage",
// @"blurRadius", @"borderBottomLeftRadius", @"borderBottomRightRadius", @"borderColor",
// @"borderRadius", @"borderTopLeftRadius", @"borderTopRightRadius", @"borderWidth", @"canSlide",
// @"children", @"ck", @"class", @"colCount", @"color", @"Component", @"Container", @"containerID",
// @"dashEffect", @"data", @"dataMode", @"dataParam", @"dataTag", @"dataUrl", @"diameterX",
// @"diameterY", @"disableCache", @"disablePlaceHolder", @"do", @"ellipsize", @"else", @"elseif",
// @"filterWhiteBg", @"firstSpace", @"fixBy", @"flag", @"flexBasis", @"flexDirection", @"flexFlow",
// @"flexGrow", @"FlexLayout", @"flexShrink", @"flexWrap", @"for", @"FrameLayout", @"gravity",
// @"Grid", @"GridLayout", @"id", @"if", @"initValue", @"itemHeight", @"itemHorizontalMargin",
// @"itemMargin", @"itemVerticalMargin", @"itemWidth", @"justifyContent", @"lastSpace",
// @"layoutDirection", @"layoutGravity", @"layoutHeight", @"layoutMarginBottom", @"layoutMarginLeft",
// @"layoutMarginRight", @"layoutMarginTop", @"layoutOrientation", @"layoutRatio", @"layoutWidth",
// @"lines", @"lineSpace", @"lineSpaceExtra", @"lineSpaceMultiplier", @"List", @"maskColor",
// @"maxLines", @"minHeight", @"minWidth", @"mode", @"module", @"name", @"NImage", @"NLine", @"NText",
// @"onAfterDataLoad", @"onAutoRefresh", @"onBeforeDataLoad", @"onClick", @"onLongClick",
// @"onPageFlip", @"onScroll", @"onSetData", @"order", @"orientation", @"paddingBottom",
// @"paddingLeft", @"paddingRight", @"paddingTop", @"Page", @"paintStyle", @"paintWidth", @"parent",
// @"pos", @"Progress", @"ratio", @"RatioLayout", @"scaleType", @"Scroller", @"self", @"siblings",
// @"size", @"Slider", @"span", @"src", @"stayTime", @"style", @"supportHTMLStyle", @"supportSticky",
// @"tag", @"text", @"textColor", @"textSize", @"textStyle", @"this", @"TMNImage", @"TMVImage",
// @"type", @"typeface", @"uuid", @"var", @"VGraph", @"VH", @"VH2Layout", @"VHLayout", @"VImage",
// @"visibility", @"VLine", @"vList", @"VText", @"VTime", @"waterfall", @"while"

@interface VVBinaryStringMapper : NSObject

+ (nullable NSString *)stringForKey:(int)key;
/**
 DO NOT use this method unless you know what you are doing.
 Please use "registerString:" to register new custom string.

 @param string  The string to be resistered.
 @param key     The specified key.
 */
+ (void)registerString:(nonnull NSString *)string forKey:(int)key;

/**
 Register a string, the key will be hash of the string.

 @param string  The string to be resistered.
 */
+ (void)registerString:(nonnull NSString *)string;
+ (int)hashOfString:(nonnull NSString *)string;

@end
