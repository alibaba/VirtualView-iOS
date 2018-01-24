//
//  VVBaseNode.h
//  VirtualView
//
//  Copyright (c) 2017-2018 Alibaba. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


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


@interface VVBaseNode : NSObject<VVWidgetObject>
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
@property(nonatomic, weak)  VVBaseNode  *superview;
@property(nonatomic, strong)UIView        *cocoaView;
@property(nonatomic, assign)CGRect        frame;
@property(nonatomic, assign)int           childrenWidth;
@property(nonatomic, assign)int           childrenHeight;
@property(nonatomic, assign)CGFloat       alpha;
@property(nonatomic, assign)BOOL          hidden;
@property(nonatomic, copy) UIColor        *backgroundColor;

@property(nonatomic, assign)CGFloat           width;
@property(nonatomic, assign)CGFloat           height;
@property(nonatomic, assign)CGFloat           widthModle;//VV_MATCH_PARENT:-1,VV_WRAP_CONTENT:-2
@property(nonatomic, assign)CGFloat           heightModle;//VV_MATCH_PARENT:-1,VV_WRAP_CONTENT:-2

@property(nonatomic, assign)int           gravity;
@property(nonatomic, assign)CGFloat       layoutRatio;
@property(nonatomic, assign)int           layoutGravity;
@property(nonatomic, assign)int           autoDimDirection;//0：VVAutoDimDirectionNone，1：VVAutoDimDirectionX，2：VVAutoDimDirectionY
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
@property(nonatomic, readonly, copy) NSArray<__kindof VVBaseNode *> *subViews;
@property(strong, nonatomic)NSMutableDictionary      *cacheInfoDic;

@property (nonatomic, strong) NSMutableDictionary *expressionSetters;

-(id<VVWidgetObject>)hitTest:(CGPoint)pt;
- (VVBaseNode*)findViewByID:(int)tagid;
- (void)addSubview:(VVBaseNode*)view;
- (void)removeSubView:(VVBaseNode*)view;
- (void)removeFromSuperview;
- (void)setNeedsLayout;
- (CGSize)nativeContentSize;
- (void)layoutSubviews;
- (CGSize)calculateLayoutSize:(CGSize)maxSize;
- (void)autoDim;
- (void)drawRect:(CGRect)rect;
- (BOOL)setIntValue:(int)value forKey:(int)key;
- (BOOL)setFloatValue:(float)value forKey:(int)key;
- (BOOL)setStringValue:(NSString *)value forKey:(int)key;
- (BOOL)setStringDataValue:(NSString*)value forKey:(int)key;

- (void)reset;
- (void)didFinishBinding;
- (void)setData:(NSData*)data;
- (void)setDataObj:(NSObject*)obj forKey:(int)key;
- (BOOL)isClickable;
- (BOOL)isLongClickable;
- (BOOL)supportExposure;
@end
