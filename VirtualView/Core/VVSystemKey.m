//
//  VVSystemKey.m
//  VirtualView
//
//  Copyright (c) 2017 Alibaba. All rights reserved.
//

#import "VVSystemKey.h"
#import <UIKit/UIKit.h>
static VVSystemKey* _shareInstance;
@interface VVSystemKey ()
{
    NSDictionary* _originalCodeDic;
    NSMutableDictionary* _dynamicCodeDic;
    float                _rate;
}
@end

@implementation VVSystemKey
+ (VVSystemKey*)shareInstance{
    if (_shareInstance == nil) {
        _shareInstance = [[VVSystemKey alloc] init];
    }
    return _shareInstance;
}

- (float)rate{
    return _rate;
}

- (id)init{
    self = [super init];
    if (self) {
        NSString* path = [[NSBundle mainBundle] pathForResource:@"widgetCodeList" ofType:@"plist"];
        _originalCodeDic = [NSDictionary dictionaryWithContentsOfFile:path];
        _dynamicCodeDic = [[NSMutableDictionary alloc] initWithDictionary:_originalCodeDic];
        _keyArray = [NSArray arrayWithObjects:@"VVVHLayout", @"VVGridLayout", @"VVFrameLayout", @"NVTextView",
                     @"VVTextView", @"NVImageView", @"VVImageView", @"TMImage", @"List",
                     @"Component",@"id", @"width", @"height", @"paddingLeft",
                     @"paddingRight", @"paddingTop", @"paddingBottom", @"marginLeft",
                     @"marginRight", @"marginTop",@"marginBottom", @"orientation",
                     @"text", @"src", @"name", @"pos",
                     @"type", @"gravity", @"background", @"color",
                     @"size", @"layoutGravity", @"colCount", @"itemHeight",
                     @"flag", @"data", @"dataTag", @"style",
                     @"action", @"actionParam",@"scaleType", @"VLine",
                     @"textStyle", @"FlexLayout", @"flexDirection", @"flexWrap",
                     @"flexFlow", @"justifyContent", @"alignItems", @"alignContent",
                     @"alignSelf", @"order", @"flexGrow", @"flexShrink",
                     @"flexBasis", @"typeface", @"Scroller", @"minWidth",
                     @"minHeight", @"TMVImage",@"class", @"onClick",
                     @"onLongClick", @"self", @"textColor", @"textSize",
                     @"dataUrl", @"this", @"parent", @"ancestor",
                     @"siblings", @"module", @"RatioLayout", @"layoutRatio",
                     @"layoutDirection", @"VVVH2Layout", @"onAutoRefresh", @"initValue",
                     @"uuid", @"onBeforeDataLoad", @"onAfterDataLoad", @"VVPageView",
                     @"onPageFlip", @"autoSwitch", @"canSlide", @"stayTime",
                     @"animatorTime", @"autoSwitchTime", @"VVGridView", @"paintWidth",
                     @"itemHorizontalMargin", @"itemVerticalMargin", @"NVLineView", @"visibility",
                     @"mode", @"supportSticky", @"VGraph", @"diameterX",
                     @"diameterY", @"itemWidth",@"itemMargin", @"VH",
                     @"onSetData", @"children", @"lines", @"ellipsize",
                     @"autoDimDirection", @"autoDimX", @"autoDimY", @"VTime",
                     @"containerID", @"if", @"elseif", @"for", @"while",
                     @"do", @"else", @"VVSliderView", @"Progress", @"onScroll",
                     @"backgroundImage", @"Container", @"span", @"paintStyle",
                     @"var", @"vList", @"dataParam", @"autoRefreshThreshold", @"dataMode", @"waterfall", @"supportHTMLStyle",@"lineSpaceMultiplier", @"lineSpaceExtra", @"borderWidth", @"borderColor", @"maxLines", @"dashEffect", @"lineSpace", @"firstSpace", @"lastSpace", @"maskColor", @"blurRadius", @"filterWhiteBg", @"ratio", @"disablePlaceHolder", @"disableCache", @"fixBy", @"alpha",@"ck",nil];
        _keyDictionary = @{@"1302701180":@"VVVHLayout",@"-1822277072":@"VVGridLayout",@"1310765783":@"VVFrameLayout", @"74637979":@"NVTextView",
                           @"82026147":@"VVTextView", @"-1991132755":@"NVImageView", @"-1762099547":@"VVImageView", @"-2005645978":@"TMImage", @"2368702":@"List",
                           @"604060893":@"Component",@"3355":@"id", @"2003872956":@"width", @"1557524721":@"height", @"-1501175880":@"paddingLeft",
                           @"713848971":@"paddingRight",@"90130308":@"paddingTop",@"202355100":@"paddingBottom",@"1248755103":@"marginLeft",
                           @"62363524":@"marginRight",@"-2037919555":@"marginTop",@"1481142723":@"marginBottom",@"-1439500848":@"orientation",
                           @"3556653":@"text",@"114148":@"src",@"3373707":@"name",@"111188":@"pos",
                           @"3575610":@"type",@"280523342":@"gravity",@"-1332194002":@"background",@"94842723":@"color",
                           @"3530753":@"size",@"516361156":@"layoutGravity",@"-669528209":@"colCount",@"1671241242":@"itemHeight",
                           @"3145580":@"flag",@"3076010":@"data",@"1443184528":@"dataTag",@"109780401":@"style",
                           @"-1422950858":@"action",@"1569332215":@"actionParam",@"-1877911644":@"scaleType",@"81791338":@"VLine",
                           @"-1048634236":@"textStyle",@"-1477040989":@"FlexLayout",@"-975171706":@"flexDirection",@"1744216035":@"flexWrap",
                           @"1743704263":@"flexFlow",@"1860657097":@"justifyContent",@"-1063257157":@"alignItems",@"-752601676":@"alignContent",
                           @"1767100401":@"alignSelf",@"106006350":@"order",@"1743739820":@"flexGrow",@"1031115618":@"flexShrink",
                           @"-1783760955":@"flexBasis",@"-675792745":@"typeface",@"-337520550":@"Scroller",@"-1375815020":@"minWidth",
                           @"-133587431":@"minHeight",@"-1776612770":@"TMVImage",@"94742904":@"class",@"-1351902487":@"onClick",
                           @"71235917":@"onLongClick",@"3526476":@"self",@"-1063571914":@"textColor",@"-1003668786":@"textSize",
                           @"1443186021":@"dataUrl",@"3559070":@"this",@"-995424086":@"parent",@"-973829677":@"ancestor",
                           @"166965745":@"siblings",@"-1068784020":@"module",@"-2105120011":@"RatioLayout",@"1999032065":@"layoutRatio",
                           @"-1955718283":@"layoutDirection",@"-494312694":@"VVVH2Layout",@"173466317":@"onAutoRefresh",@"-266541503":@"initValue",
                           @"3601339":@"uuid",@"361078798":@"onBeforeDataLoad",@"-251005427":@"onAfterDataLoad",@"2479791":@"VVPageView",
                           @"-665970021":@"onPageFlip",@"-380157501":@"autoSwitch",@"-137744447":@"canSlide",@"1322318022":@"stayTime",
                           @"1347692116":@"animatorTime",@"78802736":@"autoSwitchTime",@"2228070":@"VVGridView",@"793104392":@"paintWidth",
                           @"2129234981":@"itemHorizontalMargin",@"196203191":@"itemVerticalMargin",@"74403170":@"NVLineView",@"1941332754":@"visibility",
                           @"3357091":@"mode",@"-977844584":@"supportSticky",@"-1763797352":@"VGraph",@"1360592235":@"diameterX",
                           @"1360592236":@"diameterY",@"2146088563":@"itemWidth",@"1810961057":@"itemMargin",@"2738":@"VH",
                           @"-974184371":@"onSetData",@"1659526655":@"children",@"102977279":@"lines",@"1554823821":@"ellipsize",
                           @"-1422893274":@"autoDimDirection",@"1438248735":@"autoDimX",@"1438248736":@"autoDimY",@"82029635":@"VTime",
                           @"207632732":@"containerID",@"3357":@"if",@"-1300156394":@"elseif",@"101577":@"for",@"113101617":@"while",
                           @"3211":@"do",@"3116345":@"else",@"-1815780095":@"VVSliderView", @"-936434099":@"Progress",@"1490730380":@"onScroll",
                           @"1292595405":@"backgroundImage",@"1593011297":@"Container",@"3536714":@"span",@"789757939":@"paintStyle",
                           @"116519":@"var",@"111344180":@"vList",@"-377785597":@"dataParam", @"-51356769":@"autoRefreshThreshold", @"1788852333":@"dataMode", @"-213632750":@"waterfall", @"506010071":@"supportHTMLStyle", @"-667362093":@"lineSpaceMultiplier", @"-1118334530":@"lineSpaceExtra", @"741115130":@"borderWidth", @"722830999":@"borderColor", @"390232059":@"maxLines", @"1037639619":@"dashEffect", @"-1807275662":@"lineSpace", @"-172008394":@"firstSpace", @"2002099216":@"lastSpace", @"-77812777":@"maskColor", @"-1428201511":@"blurRadius", @"617472950":@"filterWhiteBg", @"108285963":@"ratio", @"-1358064245":@"disablePlaceHolder", @"-1012322950":@"disableCache", @"97444684":@"fixBy", @"92909918":@"alpha",@"ck":@"3176",@"VVNavtiveViewContainer":@"1010"};
        _rate = [UIScreen mainScreen].bounds.size.width/750;
    }
    return self;
}

- (NSString*)classNameForIndex:(NSUInteger)index{
    NSString* className=[_dynamicCodeDic objectForKey:[NSString stringWithFormat:@"%lu",(unsigned long)index]];
    return className?className:@"";
}

- (NSString*)classNameForTag:(NSString*)tag{
    NSString* className=[_dynamicCodeDic objectForKey:tag];
    return className?className:@"";
}

- (void)registerWidget:(NSString*)className withIndex:(NSUInteger)index{
    [_dynamicCodeDic setObject:className forKey:[NSNumber numberWithUnsignedInteger:index]];
}
@end
