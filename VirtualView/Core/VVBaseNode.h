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

// self position
@property (nonatomic, assign) VVGravity layoutGravity;
@property (nonatomic, assign) CGFloat layoutMarginLeft;
@property (nonatomic, assign) CGFloat layoutMarginRight;
@property (nonatomic, assign) CGFloat layoutMarginTop;
@property (nonatomic, assign) CGFloat layoutMarginBottom;

// calculated result
// DO NOT modify these properties unless you know what you are doing.
@property (nonatomic, assign) CGFloat nodeWidth;
@property (nonatomic, assign) CGFloat nodeHeight;
@property (nonatomic, assign) CGRect nodeFrame;

// for specicied nodes
// Need to be moved to those nodes.
@property (nonatomic, assign) VVGravity gravity;
@property (nonatomic, assign) CGFloat layoutRatio;
@property (nonatomic, assign) VVDirection layoutDirection;

@property (nonatomic, weak, readonly) VVBaseNode  *supernode;
@property (nonatomic, strong, readonly) NSArray<VVBaseNode *> *subnodes;
@property (nonatomic, strong, readonly) UIView *cocoaView;

@property (nonatomic, strong) NSMutableDictionary *expressionSetters;

@property (nonatomic, weak) CALayer *rootCanvasLayer;
@property (nonatomic, weak) UIView *rootCocoaView;

@property (nonatomic, assign) VVFlag flag;
@property (nonatomic, strong) NSString *dataTag;
@property (nonatomic, strong) NSString *action;
@property (nonatomic, strong) NSString *actionValue;
@property (nonatomic, strong) NSString *className;
@property (nonatomic, strong) UIColor *backgroundColor;

@property (nonatomic, assign) int childrenWidth;
@property (nonatomic, assign) int childrenHeight;

- (VVBaseNode *)hitTest:(CGPoint)point;

- (BOOL)isMatchParent;
- (BOOL)isWarpContent;
- (void)applyAutoDim;

- (void)setNeedsLayout;
- (void)layoutIfNeeded;
- (void)layoutSubnodes;
- (CGSize)calculateSize:(CGSize)maxSize;

- (VVBaseNode *)findViewByID:(int)tagid;
- (void)addSubview:(VVBaseNode *)view;
- (void)removeSubView:(VVBaseNode *)view;
- (void)removeFromSuperview;
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
