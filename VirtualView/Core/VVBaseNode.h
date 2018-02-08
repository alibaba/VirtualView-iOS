//
//  VVBaseNode.h
//  VirtualView
//
//  Copyright (c) 2017-2018 Alibaba. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VVDefines.h"

#define VVKeyPath(PATH) ((void)self.PATH, @#PATH)
#define VVNeedsLayoutObserve(PATH) \
    [self vv_addObserverForKeyPath:VVKeyPath(PATH) selector:@selector(setNeedsLayout)];
#define VVSubNodeNeedsLayoutObserve(PATH) \
    [self vv_addObserverForKeyPath:VVKeyPath(PATH) selector:@selector(setSubNodeNeedsLayout)];
#define VVSuperNodeNeedsLayoutObserve(PATH) \
    [self vv_addObserverForKeyPath:VVKeyPath(PATH) selector:@selector(setSuperNodeNeedsLayout)];

@interface VVBaseNode : NSObject

@property (nonatomic, readonly) NSInteger nodeID;

// self visibility
@property (nonatomic, assign) VVVisibility visibility;

// self size
@property (nonatomic, assign) CGFloat layoutWidth; // can be VV_MATCH_PARENT or VV_WARP_CONTENT
@property (nonatomic, assign) CGFloat layoutHeight; // can be VV_MATCH_PARENT or VV_WARP_CONTENT
@property (nonatomic, assign) CGFloat autoDimX;
@property (nonatomic, assign) CGFloat autoDimY;
@property (nonatomic, assign) VVAutoDimDirection autoDimDirection;

// content layout
@property (nonatomic, assign) CGFloat paddingLeft;
@property (nonatomic, assign) CGFloat paddingRight;
@property (nonatomic, assign) CGFloat paddingTop;
@property (nonatomic, assign) CGFloat paddingBottom;
@property (nonatomic, assign) VVGravity gravity;

// container layout
@property (nonatomic, assign) CGFloat marginLeft;
@property (nonatomic, assign) CGFloat marginRight;
@property (nonatomic, assign) CGFloat marginTop;
@property (nonatomic, assign) CGFloat marginBottom;
@property (nonatomic, assign) VVGravity layoutGravity;
@property (nonatomic, assign) CGFloat layoutRatio;
@property (nonatomic, assign) VVDirection layoutDirection;

// calculated result
// DO NOT modify these properties unless you know what you are doing.
@property (nonatomic, assign) CGFloat nodeWidth;
@property (nonatomic, assign) CGFloat nodeHeight;
@property (nonatomic, assign) CGRect nodeFrame;
/**
 helper method to get CGSizeMake(nodeWidth, nodeHeight)
 */
@property (nonatomic, assign, readonly) CGSize nodeSize;
/**
 the content maximun size = nodeSize - padding
 */
@property (nonatomic, assign, readonly) CGSize contentSize;
/**
 the size in container = nodeSize + margin
 */
@property (nonatomic, assign, readonly) CGSize containerSize;

// other
@property (nonatomic, assign) VVFlag flag;
@property (nonatomic, strong) NSString *dataTag;
@property (nonatomic, strong) NSString *action;
@property (nonatomic, strong) NSString *actionValue;
@property (nonatomic, strong) NSString *className;
@property (nonatomic, strong) UIColor *backgroundColor;

// node tree & native view
@property (nonatomic, weak, readonly) VVBaseNode  *superNode;
@property (nonatomic, strong, readonly) NSArray<VVBaseNode *> *subNodes;
@property (nonatomic, strong, readonly) UIView *cocoaView;

// root canvas & native view
@property (nonatomic, weak) CALayer *rootCanvasLayer;
@property (nonatomic, weak) UIView *rootCocoaView;

// expression setters
@property (nonatomic, strong) NSMutableDictionary *expressionSetters;

- (BOOL)isClickable;
- (BOOL)isLongClickable;
- (BOOL)supportExposure;
- (VVBaseNode *)hitTest:(CGPoint)point;

- (VVBaseNode *)nodeWithID:(NSInteger)nodeID;
- (void)addSubNode:(VVBaseNode *)node;
- (void)removeSubNode:(VVBaseNode *)node;
- (void)removeFromSuperNode;

- (BOOL)needsLayoutIfSuperNodeLayout;
- (BOOL)needsLayoutIfSubNodeLayout;
- (void)setSuperNodeNeedsLayout;
- (void)setSubNodeNeedsLayout;
/**
 Will set superNode and subNodes is it is necessary.
 */
- (void)setNeedsLayout;
/**
 Will set this node only.
 */
- (void)setNeedsLayoutNotRecursively;
/**
 Will set whole node tree, please call this method with root node.
 */
- (void)setNeedsLayoutRecursively;
- (void)layoutIfNeeded;
- (void)layoutSubNodes NS_REQUIRES_SUPER;
- (void)layoutSubviews __deprecated_msg("use layoutSubNodes");
- (void)applyAutoDim;
- (CGSize)calculateSize:(CGSize)maxSize;
- (CGSize)calculateLayoutSize:(CGSize)maxSize __deprecated_msg("use calculateSize");

- (BOOL)setIntValue:(int)value forKey:(int)key;
- (BOOL)setFloatValue:(float)value forKey:(int)key;
- (BOOL)setStringValue:(NSString *)value forKey:(int)key;
- (BOOL)setStringDataValue:(NSString *)value forKey:(int)key;
- (void)setDataObj:(NSObject *)obj forKey:(int)key;
- (void)reset;
- (void)didUpdated;

@end
