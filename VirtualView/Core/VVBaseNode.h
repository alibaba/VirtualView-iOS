//
//  VVBaseNode.h
//  VirtualView
//
//  Copyright (c) 2017-2018 Alibaba. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VVDefines.h"

@interface VVBaseNode : NSObject

@property (nonatomic, readonly) NSUInteger nodeID;

// self visibility
@property (nonatomic, assign) VVVisibility visibility;

// self size
@property (nonatomic, assign) CGFloat layoutWidth; // can be VV_MATCH_PARENT or VV_WARP_CONTENT
@property (nonatomic, assign) CGFloat layoutHeight; // can be VV_MATCH_PARENT or VV_WARP_CONTENT
@property (nonatomic, assign) CGFloat autoDimX;
@property (nonatomic, assign) CGFloat autoDimY;
@property (nonatomic, assign) VVAutoDimDirection autoDimDirection;
@property (nonatomic, assign) CGFloat paddingLeft;
@property (nonatomic, assign) CGFloat paddingRight;
@property (nonatomic, assign) CGFloat paddingTop;
@property (nonatomic, assign) CGFloat paddingBottom;

// self position in parent layout
@property (nonatomic, assign) CGFloat layoutMarginLeft;
@property (nonatomic, assign) CGFloat layoutMarginRight;
@property (nonatomic, assign) CGFloat layoutMarginTop;
@property (nonatomic, assign) CGFloat layoutMarginBottom;
@property (nonatomic, assign) VVGravity layoutGravity;

// calculated result
@property (nonatomic, assign) CGFloat nodeWidth;
@property (nonatomic, assign) CGFloat nodeHeight;
@property (nonatomic, assign) CGRect nodeFrame;

@property(nonatomic, strong)NSString      *name;
@property(nonatomic, assign)int           flag;
@property(nonatomic, strong)NSString      *dataUrl;
@property(nonatomic, strong)NSString      *dataTag;
@property(nonatomic, strong)NSString      *action;
@property(nonatomic, strong)NSString      *actionValue;
@property(nonatomic, strong)NSString      *actionParam;
@property(nonatomic, strong)NSString      *classString;
@property(nonatomic, weak)  VVBaseNode  *superview;
@property(nonatomic, strong)UIView        *cocoaView;
@property(nonatomic, assign)int           childrenWidth;
@property(nonatomic, assign)int           childrenHeight;
@property(nonatomic, assign)CGFloat       alpha;
@property(nonatomic, assign)BOOL          hidden;
@property(nonatomic, copy) UIColor        *backgroundColor;

@property(nonatomic, assign)int           gravity;
@property(nonatomic, assign)CGFloat       layoutRatio;
@property(nonatomic, assign)int           layoutDirection;

@property(nonatomic, strong)NSMutableDictionary     *userVarDic;
@property(nonatomic, readonly, copy) NSArray<__kindof VVBaseNode *> *subViews;
@property(strong, nonatomic)NSMutableDictionary      *cacheInfoDic;

@property (nonatomic, strong) NSMutableDictionary *expressionSetters;

@property (nonatomic, weak) CALayer *rootCanvasLayer;
@property (nonatomic, weak) UIView *rootCocoaView;

- (VVBaseNode *)hitTest:(CGPoint)pt;
- (VVBaseNode *)findViewByID:(int)tagid;
- (void)addSubview:(VVBaseNode *)view;
- (void)removeSubView:(VVBaseNode *)view;
- (void)removeFromSuperview;
- (void)setNeedsLayout;
- (void)layoutSubnodes;
- (CGSize)calculateSize:(CGSize)maxSize;
- (void)autoDim;
- (BOOL)setIntValue:(int)value forKey:(int)key;
- (BOOL)setFloatValue:(float)value forKey:(int)key;
- (BOOL)setStringValue:(NSString *)value forKey:(int)key;
- (BOOL)setStringDataValue:(NSString *)value forKey:(int)key;

- (void)reset;
- (void)didFinishBinding;
- (void)setData:(NSData *)data;
- (void)setDataObj:(NSObject *)obj forKey:(int)key;
- (BOOL)isClickable;
- (BOOL)isLongClickable;
- (BOOL)supportExposure;

@end
