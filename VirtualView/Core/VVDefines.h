//
//  VVDefines.h
//  VirtualView
//
//  Copyright (c) 2017-2018 Alibaba. All rights reserved.
//

#ifndef VVDefines_h
#define VVDefines_h

#ifdef DEBUG
#define VV_DEBUG    1
#endif
//#define VV_ALIBABA  1

/**
 * Special value for height or width.
 * VV_MATCH_PARENT means that the node wants to be as big as its container,
 * The result will minus padding of its container.
 */
#define VV_MATCH_PARENT -1
/**
 * Special value for height or width.
 * VV_WRAP_CONTENT means that the node wants to fit its contents.
 * The result will contain padding of itself.
 */
#define VV_WRAP_CONTENT -2

typedef NS_ENUM(NSUInteger, VVOrientation) {
    VVOrientationVertical = 0,
    VVOrientationHorizontal = 1
};

typedef NS_ENUM(NSUInteger, VVGravity) {
    VVGravityLeft = 1,
    VVGravityRight = 2,
    VVGravityHCenter = 4,
    VVGravityTop = 8,
    VVGravityBottom = 16,
    VVGravityVCenter = 32
};

typedef NS_ENUM(NSUInteger, VVAutoDimDirection) {
    VVAutoDimDirectionNone = 0,
    VVAutoDimDirectionX = 1,
    VVAutoDimDirectionY = 2
};

typedef NS_ENUM(NSUInteger, VVVisibility) {
    VVVisibilityInvisible = 0,
    VVVisibilityVisible = 1,
    VVVisibilityGone = 2
};

typedef NS_ENUM(NSUInteger, VVFlag) {
    VVFlagDraw = 1 << 0,
    VVFlagEvent = 1 << 1,
    VVFlagDynamic = 1 << 2,
    VVFlagSoftware = 1 << 3,
    VVFlagExposure = 1 << 4,
    VVFlagClickable = 1 << 5,
    VVFlagLongClickable = 1 << 6,
    VVFlagTouchable = 1 << 7
};

typedef NS_ENUM(NSUInteger, VVDirection) {
    VVDirectionLeft = 1,
    VVDirectionRight = 2,
    VVDirectionTop = 4,
    VVDirectionBottom = 8
};

typedef NS_ENUM(NSUInteger, VVTextStyle) {
    VVTextStyleNormal = 0,
    VVTextStyleBold = 1,
    VVTextStyleItalic = 2,
    VVTextStyleUnderLine = 4,
    VVTextStyleStrike = 8
};

typedef NS_ENUM(NSUInteger, VVEllipsize) {
    VVEllipsizeNone = -1,
    VVEllipsizeStart = 0,
    VVEllipsizeMiddle = 1,
    VVEllipsizeEnd = 2,
    VVEllipsizeMarquee = 3
};

typedef NS_ENUM(NSUInteger, VVScaleType) {
    VVScaleTypeMatrix = 0,
    VVScaleTypeFitXY = 1,
    VVScaleTypeFitStart = 2,
    VVScaleTypeFitCenter = 3,
    VVScaleTypeFitEnd = 4,
    VVScaleTypeCenter = 5,
    VVScaleTypeCenterCrop = 6,
    VVScaleTypeCenterInside = 7
};

typedef NS_ENUM(NSUInteger, VVLineStyle) {
    VVLineStyleSolid = 1,
    VVLineStyleDash = 2
};

#define  STR_ID_VHLayout  1302701180
#define  STR_ID_GridLayout  -1822277072
#define  STR_ID_FrameLayout  1310765783
#define  STR_ID_NText  74637979
#define  STR_ID_VText  82026147
#define  STR_ID_NImage  -1991132755
#define  STR_ID_VImage  -1762099547
#define  STR_ID_TMNImage  -2005645978
#define  STR_ID_List  2368702
#define  STR_ID_Component  604060893
#define  STR_ID_id  3355
#define  STR_ID_layoutWidth  2003872956
#define  STR_ID_layoutHeight  1557524721
#define  STR_ID_paddingLeft  -1501175880
#define  STR_ID_paddingRight  713848971
#define  STR_ID_paddingTop  90130308
#define  STR_ID_paddingBottom  202355100
#define  STR_ID_layoutMarginLeft  1248755103
#define  STR_ID_layoutMarginRight  62363524
#define  STR_ID_layoutMarginTop  -2037919555
#define  STR_ID_layoutMarginBottom  1481142723
#define  STR_ID_orientation  -1439500848
#define  STR_ID_text  3556653
#define  STR_ID_src  114148
#define  STR_ID_name  3373707
#define  STR_ID_pos  111188
#define  STR_ID_type  3575610
#define  STR_ID_gravity  280523342
#define  STR_ID_background  -1332194002
#define  STR_ID_color  94842723
#define  STR_ID_size  3530753
#define  STR_ID_layoutGravity  516361156
#define  STR_ID_colCount  -669528209
#define  STR_ID_itemHeight  1671241242
#define  STR_ID_flag  3145580
#define  STR_ID_data  3076010
#define  STR_ID_dataTag  1443184528
#define  STR_ID_style  109780401
#define  STR_ID_action  -1422950858
#define  STR_ID_actionParam  1569332215
#define  STR_ID_scaleType  -1877911644
#define  STR_ID_VLine  81791338
#define  STR_ID_textStyle  -1048634236
#define  STR_ID_FlexLayout  -1477040989
#define  STR_ID_flexDirection  -975171706
#define  STR_ID_flexWrap  1744216035
#define  STR_ID_flexFlow  1743704263
#define  STR_ID_justifyContent  1860657097
#define  STR_ID_alignItems  -1063257157
#define  STR_ID_alignContent  -752601676
#define  STR_ID_alignSelf  1767100401
#define  STR_ID_order  106006350
#define  STR_ID_flexGrow  1743739820
#define  STR_ID_flexShrink  1031115618
#define  STR_ID_flexBasis  -1783760955
#define  STR_ID_typeface  -675792745
#define  STR_ID_Scroller  -337520550
#define  STR_ID_minWidth  -1375815020
#define  STR_ID_minHeight  -133587431
#define  STR_ID_TMVImage  -1776612770
#define  STR_ID_class  94742904
#define  STR_ID_onClick  -1351902487
#define  STR_ID_onLongClick  71235917
#define  STR_ID_self  3526476
#define  STR_ID_textColor  -1063571914
#define  STR_ID_textSize  -1003668786
#define  STR_ID_dataUrl  1443186021
#define  STR_ID_this  3559070
#define  STR_ID_parent  -995424086
#define  STR_ID_ancestor  -973829677
#define  STR_ID_siblings  166965745
#define  STR_ID_module  -1068784020
#define  STR_ID_RatioLayout  -2105120011
#define  STR_ID_layoutRatio  1999032065
#define  STR_ID_layoutDirection  -1955718283
#define  STR_ID_VH2Layout  -494312694
#define  STR_ID_onAutoRefresh  173466317
#define  STR_ID_initValue  -266541503
#define  STR_ID_uuid  3601339
#define  STR_ID_onBeforeDataLoad  361078798
#define  STR_ID_onAfterDataLoad  -251005427
#define  STR_ID_Page  2479791
#define  STR_ID_onPageFlip  -665970021
#define  STR_ID_autoSwitch  -380157501
#define  STR_ID_canSlide  -137744447
#define  STR_ID_stayTime  1322318022
#define  STR_ID_animatorTime  1347692116
#define  STR_ID_autoSwitchTime  78802736
#define  STR_ID_Grid  2228070
#define  STR_ID_paintWidth  793104392
#define  STR_ID_itemHorizontalMargin  2129234981
#define  STR_ID_itemVerticalMargin  196203191
#define  STR_ID_NLine  74403170
#define  STR_ID_visibility  1941332754
#define  STR_ID_mode  3357091
#define  STR_ID_supportSticky  -977844584
#define  STR_ID_VGraph  -1763797352
#define  STR_ID_diameterX  1360592235
#define  STR_ID_diameterY  1360592236
#define  STR_ID_itemWidth  2146088563
#define  STR_ID_itemMargin  1810961057
#define  STR_ID_VH  2738
#define  STR_ID_onSetData  -974184371
#define  STR_ID_children  1659526655
#define  STR_ID_lines  102977279
#define  STR_ID_ellipsize  1554823821
#define  STR_ID_autoDimDirection  -1422893274
#define  STR_ID_autoDimX  1438248735
#define  STR_ID_autoDimY  1438248736
#define  STR_ID_VTime  82029635
#define  STR_ID_containerID  207632732
#define  STR_ID_if  3357
#define  STR_ID_elseif  -1300156394
#define  STR_ID_for  101577
#define  STR_ID_while  113101617
#define  STR_ID_do  3211
#define  STR_ID_else  3116345
#define  STR_ID_Slider  -1815780095
#define  STR_ID_Progress  -936434099
#define  STR_ID_onScroll  1490730380
#define  STR_ID_backgroundImage  1292595405
#define  STR_ID_Container  1593011297
#define  STR_ID_span  3536714
#define  STR_ID_paintStyle  789757939
#define  STR_ID_var  116519
#define  STR_ID_vList  111344180
#define  STR_ID_dataParam  -377785597
#define  STR_ID_autoRefreshThreshold  -51356769
#define  STR_ID_dataMode  1788852333
#define  STR_ID_waterfall  -213632750
#define  STR_ID_supportHTMLStyle  506010071
#define  STR_ID_lineSpaceMultiplier  -667362093
#define  STR_ID_lineSpaceExtra  -1118334530
#define  STR_ID_borderWidth  741115130
#define  STR_ID_borderColor  722830999
#define  STR_ID_borderRadius   1349188574
#define  STR_ID_borderTopLeftRadius  -1228066334
#define  STR_ID_borderTopRightRadius  333432965
#define  STR_ID_borderBottomLeftRadius  581268560
#define  STR_ID_borderBottomRightRadius  588239831
#define  STR_ID_maxLines  390232059
#define  STR_ID_dashEffect  1037639619
#define  STR_ID_lineSpace  -1807275662
#define  STR_ID_firstSpace  -172008394
#define  STR_ID_lastSpace  2002099216
#define  STR_ID_maskColor  -77812777
#define  STR_ID_blurRadius  -1428201511
#define  STR_ID_filterWhiteBg  617472950
#define  STR_ID_ratio  108285963
#define  STR_ID_disablePlaceHolder  -1358064245
#define  STR_ID_disableCache  -1012322950
#define  STR_ID_fixBy  97444684
#define  STR_ID_alpha  92909918
#define  STR_ID_ck     3176
#define  STR_ID_inmainthread  999999
#define  STR_ID_NativeContainer     -1052618729

#define TYPE_INT         0
#define TYPE_FLOAT       1
#define TYPE_STRING      2
#define TYPE_COLOR       3
#define TYPE_BOOLEAN     4
#define TYPE_VISIBILITY  5
#define TYPE_GRAVITY     6
#define TYPE_OBJECT      7

#endif
