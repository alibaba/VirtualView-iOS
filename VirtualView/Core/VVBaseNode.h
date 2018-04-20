//
//  VVBaseNode.h
//  VirtualView
//
//  Copyright (c) 2017-2018 Alibaba. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VVDefines.h"

@interface VVBaseNode : NSObject

@property (nonatomic, assign, readonly) NSInteger nodeID;
@property (nonatomic, strong) NSString *templateType;

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

// container layout
@property (nonatomic, assign) CGFloat marginLeft;
@property (nonatomic, assign) CGFloat marginRight;
@property (nonatomic, assign) CGFloat marginTop;
@property (nonatomic, assign) CGFloat marginBottom;
@property (nonatomic, assign) VVGravity layoutGravity;
@property (nonatomic, assign) CGFloat layoutRatio;
@property (nonatomic, assign) VVDirection layoutDirection;

// other
@property (nonatomic, assign) VVFlag flag;
@property (nonatomic, strong) NSString *action;
@property (nonatomic, strong) NSString *actionValue;
@property (nonatomic, strong) NSString *className;
@property (nonatomic, strong) UIColor *backgroundColor;
@property (nonatomic, strong) UIColor *borderColor;
@property (nonatomic, assign) CGFloat borderWidth;

// node tree & native view
@property (nonatomic, weak, readonly) VVBaseNode  *superNode;
@property (nonatomic, strong, readonly) NSArray<VVBaseNode *> *subNodes;
@property (nonatomic, strong, readonly) UIView *cocoaView;

// root canvas & native view
@property (nonatomic, weak) CALayer *rootCanvasLayer;
@property (nonatomic, weak) UIView *rootCocoaView;

// expression setters
@property (nonatomic, strong) NSMutableDictionary *expressionSetters;

- (BOOL)containsClickable;
- (BOOL)containsLongClickable;
- (BOOL)isClickable;
- (BOOL)isLongClickable;
- (BOOL)supportExposure;
- (VVBaseNode *)hitTest:(CGPoint)point;

- (VVBaseNode *)nodeWithID:(NSInteger)nodeID;
- (void)addSubNode:(VVBaseNode *)node;
- (void)removeSubNode:(VVBaseNode *)node;
- (void)removeFromSuperNode;

- (BOOL)setIntValue:(int)value forKey:(int)key;
- (BOOL)setFloatValue:(float)value forKey:(int)key;
- (BOOL)setStringValue:(NSString *)value forKey:(int)key;
- (BOOL)setStringData:(NSString *)data forKey:(int)key;
- (BOOL)setDataObj:(NSObject *)obj forKey:(int)key;
- (void)reset;
- (void)didUpdated;

#pragma mark Layout

// calculated result
// DO NOT modify these properties unless you know what you are doing.
@property (nonatomic, assign) CGFloat nodeX;
@property (nonatomic, assign) CGFloat nodeY;
@property (nonatomic, assign) CGFloat nodeWidth;
@property (nonatomic, assign) CGFloat nodeHeight;
/**
 hidden state
 Will be YES if superNode is hidden.
 Will be updated via updateHidden method in layoutSubNodes method of superNode.
 */
@property (nonatomic, assign, readonly) BOOL hidden;
/**
 absolute frame relative to root
 = CGRectMake(superNodeFrameX + nodeX, superNodeFrameY + nodeY, nodeWidth, nodeHeight)
 Will be updated via updateFrame method in layoutSubNodes method of superNode.
 */
@property (nonatomic, assign, readonly) CGRect nodeFrame;
/**
 helper method to get node size = CGSizeMake(nodeWidth, nodeHeight)
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

- (void)setupLayoutAndResizeObserver NS_REQUIRES_SUPER;

- (BOOL)needLayout;
- (BOOL)needResize;
/**
 Will set this node only.
 */
- (void)setNeedsLayout;
// used by setNeedsResize method
- (BOOL)needLayoutIfResize;
- (BOOL)needResizeIfSuperNodeResize;
- (BOOL)needResizeIfSubNodeResize;
/**
 Will set this node.
 Will affect superNode & subNodes if it is necessary.
 */
- (void)setNeedsResize;
/**
 Will set this node only.
 */
- (void)setNeedsResizeNonRecursively;
/**
 Will set whole node tree, please call this method with root node.
 */
- (void)setNeedsLayoutAndResizeRecursively;

- (void)updateHidden NS_REQUIRES_SUPER;
- (void)updateHiddenRecursively;
- (void)updateFrame NS_REQUIRES_SUPER;
- (void)layoutSubNodes;
- (void)layoutSubviews __deprecated_msg("use layoutSubNodes");

- (void)applyAutoDim;
- (CGSize)calculateSize:(CGSize)maxSize;
- (CGSize)calculateLayoutSize:(CGSize)maxSize __deprecated_msg("use calculateSize:");

@end
