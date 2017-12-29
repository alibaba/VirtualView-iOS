//
//  VVViewObject.h
//  VirtualView
//
//  Copyright (c) 2017 Alibaba. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "VVCommTools.h"
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
#define macro




/**
 * Special value for the height or width requested by a View.
 * MATCH_PARENT means that the view wants to be as big as its parent,
 * minus the parent's padding, if any.
 */
#define MATCH_PARENT  -1

/**
 * Special value for the height or width requested by a View.
 * WRAP_CONTENT means that the view wants to be just large enough to fit
 * its own internal content, taking its own padding into account.
 */
#define WRAP_CONTENT  -2

#define CONSTRAINT    -3

#define VERTICAL       0
#define HORIZONTAL     1


#define Gravity_LEFT       1
#define Gravity_RIGHT      2
#define Gravity_H_CENTER   4
#define Gravity_TOP        8
#define Gravity_BOTTOM     16
#define Gravity_V_CENTER   32

#define AUTO_DIM_DIR_NONE  0
#define AUTO_DIM_DIR_X     1
#define AUTO_DIM_DIR_Y     2

#define FLAG_DRAW             1
#define FLAG_EVENT            2
#define FLAG_DYNAMIC          4
#define FLAG_SOFTWARE         8
#define FLAG_EXPOSURE         16
#define FLAG_CLICKABLE        32
#define FLAG_LONG_CLICKABLE   64
#define FLAG_TOUCHABLE        128

#define INVISIBLE        0
#define VISIBLE          1
#define GONE             2

#define TYPE_INT         0

#define TYPE_FLOAT       1

#define TYPE_STRING      2

#define TYPE_COLOR       3

#define TYPE_BOOLEAN     4

#define TYPE_VISIBILITY  5

#define TYPE_GRAVITY     6

#define TYPE_OBJECT      7

#define UIColorARGBWithHexValue(value) [UIColor colorWithRed:((value>>16)&0xFF)/255.f green:((value>>8)&0xFF)/255.f blue:(value&0xFF)/255.f alpha:((value >> 24)&0xFF)/255.f];


#define DIRECTION_LEFT     1
#define DIRECTION_TOP      2
#define DIRECTION_RIGHT    4
#define DIRECTION_BOTTOM   8

typedef NS_ENUM(NSUInteger, LINESTYLE) {
    SOLID=1,
    DASH
};
@protocol NativeViewObject <NSObject>
- (void)setDataObject:(NSObject*)obj forKey:(int)key;

@end

@protocol VVWidgetObject <NSObject>
- (CGSize)nativeContentSize;
- (void)layoutSubviews;
- (CGSize)calculateLayoutSize:(CGSize)maxSize;
- (void)dataUpdateFinished;
@property(nonatomic, assign)CGSize   maxSize;
@property(nonatomic, strong)NSString* action;
@property(nonatomic, strong)NSString* actionValue;
@end

@protocol VVWidgetAction <NSObject>
- (void)updateDisplayRect:(CGRect)rect;
//-(id<VVWidgetObject>)hitTest:(CGPoint)point;
@end



@class VVExpressCode;
@interface VVViewObject : NSObject<VVWidgetObject>
@property(nonatomic, readonly)NSUInteger  objectID;
@property(nonatomic, strong)NSString      *name;
//@property(nonatomic, strong)NSString      *data;
@property(nonatomic, assign)int           flag;
@property(nonatomic, assign)int           visible;
@property(nonatomic, strong)NSString      *dataUrl;
@property(nonatomic, strong)NSString      *dataTag;
@property(nonatomic, strong)NSString      *action;
@property(nonatomic, strong)NSString      *actionValue;
@property(nonatomic, assign)CGSize        maxSize;
@property(nonatomic, strong)NSString      *actionParam;
@property(nonatomic, strong)NSString      *classString;
@property(nonatomic, weak)  VVViewObject  *superview;
@property(nonatomic, strong)UIView        *cocoaView;
@property(nonatomic, assign)CGRect        frame;
@property(nonatomic, assign)int           childrenWidth;
@property(nonatomic, assign)int           childrenHeight;
@property(nonatomic, assign)CGFloat       alpha;
@property(nonatomic, assign)BOOL          hidden;
@property(nonatomic, copy) UIColor        *backgroundColor;

@property(nonatomic, assign)CGFloat           width;
@property(nonatomic, assign)CGFloat           height;
@property(nonatomic, assign)CGFloat           widthModle;//MATCH_PARENT:-1,WRAP_CONTENT:-2
@property(nonatomic, assign)CGFloat           heightModle;//MATCH_PARENT:-1,WRAP_CONTENT:-2

@property(nonatomic, assign)int           gravity;
@property(nonatomic, assign)CGFloat       layoutRatio;
@property(nonatomic, assign)int           layoutGravity;
@property(nonatomic, assign)int           autoDimDirection;//0：AUTO_DIM_DIR_NONE，1：AUTO_DIM_DIR_X，2：AUTO_DIM_DIR_Y
@property(nonatomic, assign)CGFloat       autoDimX;
@property(nonatomic, assign)CGFloat       autoDimY;
@property(nonatomic, assign)int           layoutDirection;

@property(nonatomic, assign)int           paddingLeft;
@property(nonatomic, assign)int           paddingRight;
@property(nonatomic, assign)int           paddingTop;
@property(nonatomic, assign)int           paddingBottom;

@property(nonatomic, assign)int           marginLeft;
@property(nonatomic, assign)int           marginRight;
@property(nonatomic, assign)int           marginTop;
@property(nonatomic, assign)int           marginBottom;
@property(nonatomic, strong)NSMutableDictionary     *userVarDic;
@property(nonatomic, weak)id<VVWidgetAction>      updateDelegate;
@property(nonatomic, readonly, copy) NSArray<__kindof VVViewObject *> *subViews;
@property(nonatomic, strong)NSMutableDictionary      *dataTagObjs;
@property(nonatomic, strong)NSMutableDictionary      *mutablePropertyDic;
@property(strong, nonatomic)NSMutableDictionary      *cacheInfoDic;

-(id<VVWidgetObject>)hitTest:(CGPoint)pt;
- (VVViewObject*)findViewByID:(int)tagid;
- (void)addSubview:(VVViewObject*)view;
- (void)removeSubView:(VVViewObject*)view;
- (void)removeFromSuperview;
- (void)setNeedsLayout;
- (CGSize)nativeContentSize;
- (void)layoutSubviews;
- (CGSize)calculateLayoutSize:(CGSize)maxSize;
- (void)autoDim;
- (void)drawRect:(CGRect)rect;
- (BOOL)setIntValue:(int)value forKey:(int)key;
- (BOOL)setFloatValue:(float)value forKey:(int)key;
- (BOOL)setStringValue:(int)value forKey:(int)key;
- (BOOL)setStringDataValue:(NSString*)value forKey:(int)key;
- (BOOL)setExprossValue:(int)value forKey:(int)key;

- (void)addUserVar:(int)type nameID:(int)nameid value:(int)value;
- (void)reset;
- (void)didFinishBinding;
- (void)setData:(NSData*)data;
- (void)setDataObj:(NSObject*)obj forKey:(int)key;
- (void)setTagsValue:(NSArray*)tags withData:(NSDictionary*)dic;
- (void)parseData:(NSObject*)bizData;
- (BOOL)isClickable;
- (BOOL)isLongClickable;
- (BOOL)supportExposure;
@end
